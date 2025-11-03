import 'package:flutter/material.dart';
import '../../models/address_model.dart';

class AddressCard extends StatelessWidget {
  final AddressModel address;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onSetDefault;

  const AddressCard({
    Key? key,
    required this.address,
    this.onEdit,
    this.onDelete,
    this.onSetDefault,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderColor = Colors.grey.shade300;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------- Header Row ----------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        address.city,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (address.isDefault)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Default',
                            style: TextStyle(fontSize: 12, color: Colors.blue),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// ---------- Address Details ----------
            Text(
              '${address.addressLineOne}${address.addressLineTwo != null && address.addressLineTwo!.isNotEmpty ? ", ${address.addressLineTwo}" : ""}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 6),
            Text(
              '${address.city}, ${address.state}, ${address.country}',
              style: const TextStyle(color: Colors.black54),
            ),
            if ((address.postalCode).isNotEmpty)
              Text(
                'Postal Code: ${address.postalCode}',
                style: const TextStyle(color: Colors.black54),
              ),
            const SizedBox(height: 8),

            /// ---------- Contact Info ----------
            if ((address.phone ?? '').isNotEmpty)
              Row(
                children: [
                  const Icon(Icons.phone, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    address.phone!,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),

            /// ---------- Latitude & Longitude ----------
            if (address.latitude != null && address.longitude != null) ...[
              const SizedBox(height: 6),
              Text(
                'Lat: ${address.latitude}, Long: ${address.longitude}',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],

            const SizedBox(height: 12),

            /// ---------- Actions ----------
            Row(
              children: [
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 18, color: Colors.green),
                  label: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                  label: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                const Spacer(),
                if (!address.isDefault)
                  TextButton(
                    onPressed: onSetDefault,
                    child: const Text('Make Default'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
