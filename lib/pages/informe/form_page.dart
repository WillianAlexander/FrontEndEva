import 'dart:io';

import 'package:eva/provider/state/user.state.dart';
import 'package:eva/provider/usuario/user.provider.dart';
import 'package:eva/services/report_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  String? _pdfPath;
  File? _selectedFile;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale('es'),
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _pdfPath = result.files.single.name; // Nombre del archivo
      });

      print('Archivo seleccionado: $_pdfPath');
    } else {
      print(
        'No se seleccionó ningún archivo o el archivo no tiene un path válido.',
      );
    }
  }

  Future<void> _saveData(BuildContext context) async {
    final Usuario? user =
        Provider.of<UsuarioProvider>(context, listen: false).usuario;
    if (_selectedFile != null && _selectedDate != null) {
      try {
        // Mover la operación pesada a un hilo secundario
        final response = await Future.delayed(Duration.zero, () async {
          return await ReportService().saveToDatabase(
            _selectedFile!,
            user!.usuario,
            Estados.recibido,
            DateTime.now(),
            _selectedDate!,
          );
        });

        // Verificar el código de estado de la respuesta
        if (response.statusCode == 201) {
          // Limpiar el formulario después de guardar
          setState(() {
            _selectedDate = null;
            _pdfPath = null;
            _selectedFile = null;
          });
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Datos guardados correctamente')),
          );
        } else if (response.statusCode == 409) {
          // Manejar error de clave duplicada
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ya existe un informe con los mismos datos.'),
            ),
          );
        } else {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error al guardar los datos. Código: ${response.statusCode}',
              ),
            ),
          );
        }
      } catch (e) {
        // Manejar excepciones
        print('Error al procesar el archivo: $e');
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar los datos')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona una fecha y un archivo PDF'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fecha de entrega:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate != null
                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                      : 'No seleccionada',
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Icon(Icons.calendar_month),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Subir documento PDF:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    _pdfPath ?? 'No seleccionado',
                    overflow:
                        TextOverflow
                            .ellipsis, // Trunca el texto si es muy largo
                    maxLines: 1, // Limita el texto a una sola línea
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _pickPdf,
                  child: const Text('Subir informe'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton.icon(
                onPressed:
                    () => _saveData(
                      context,
                    ), // Llama al método para guardar los datos
                label: const Text('Guardar'),
                icon: Icon(Icons.upload_file_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
