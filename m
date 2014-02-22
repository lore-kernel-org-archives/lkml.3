Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbaBVCz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 21:55:27 -0500
Received: from mail-yk0-f177.google.com ([209.85.160.177]:40324 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbaBVCzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 21:55:23 -0500
Date: Fri, 21 Feb 2014 23:47:45 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2014-02-21
Message-ID: <20140222024745.GE1417@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/3yNEOqWowh/8j+e"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/3yNEOqWowh/8j+e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

This is our first pull request for 3.15, the main feature here is the addition of
the privacy feature for low energy devices. Other than that we have a bunch of small
improvements, fixes, and clean ups all over the tree.

Please pull or let me know of any concerns you may have. Thanks.

	Gustavo

---
The following changes since commit e57f1734d87aa0e9a00905ed08888f0c62f56227:

  mwifiex: add key material v2 support (2014-02-12 15:36:26 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to 668b7b19820b0801c425d31cc27fd6f499050e5c:

  Bluetooth: Fix iterating wrong list in hci_remove_irk() (2014-02-21 11:07:46 -0300)

----------------------------------------------------------------
Andre Guedes (5):
      Bluetooth: Save connection interval parameters in hci_conn
      Bluetooth: Group list_head fields from strcut hci_dev together
      Bluetooth: Introduce le_conn_failed() helper
      Bluetooth: Introduce connection parameters list
      Bluetooth: Use connection parameters if any

Andrzej Kaczmarek (1):
      Bluetooth: Fix channel check when binding RFCOMM sock

Andy Shevchenko (2):
      Bluetooth: sort the list of IDs in the source code
      Bluetooth: append new supported device to the list [0b05:17d0]

Johan Hedberg (53):
      Bluetooth: Fix outgoing authentication requirement check
      Bluetooth: Fix mgmt error code for negative PIN response
      Bluetooth: Reorder L2CAP functions to avoid forward declarations
      Bluetooth: Queue incoming ACL data until BT_CONNECTED state is reached
      Bluetooth: Remove useless l2cap_seq_list_remove function
      Bluetooth: Rename L2CAP_CHAN_CONN_FIX_A2MP to L2CAP_CHAN_FIXED
      Bluetooth: Switch ATT channels to use L2CAP_CHAN_FIXED
      Bluetooth: Fix BT_SECURITY socket option for fixed channels (ATT)
      Bluetooth: Fix CID initialization for fixed channels
      Bluetooth: Fix respecting le_default_mps value
      Bluetooth: Fix disconnecting L2CAP channel for credits violation
      Bluetooth: Fix disconnecting L2CAP when a credits overflow occurs
      Bluetooth: Free up l2cap_chan->sport when initiating a connection
      Bluetooth: Refuse peer L2CAP address reading when not connected
      Bluetooth: Refuse peer RFCOMM address reading when not connected
      Bluetooth: Always use l2cap_chan->psm for returning PSM to user space
 2     Bluetooth: Remove unnecessary check for chan->psm
      Bluetooth: Enable LTK distribution to slave devices
      Bluetooth: Remove Simultaneous LE & BR/EDR flags from AD
      Bluetooth: Fix long_term_keys debugfs output
      Bluetooth: Make LTK key type check more readable
      Bluetooth: Remove unnecessary LTK type check from hci_add_ltk
      Bluetooth: Fix differentiating stored master vs slave LTK types
      Bluetooth: Enable LE L2CAP CoC support by default
      Bluetooth: Fix missing PDU length checks for SMP
      Bluetooth: Fix minor whitespace issues in SMP code
      Bluetooth: Add smp_irk_matches helper function
      Bluetooth: Add AES crypto context for each HCI device
      Bluetooth: Add basic IRK management support
      Bluetooth: Add hci_bdaddr_is_rpa convenience function
      Bluetooth: Implement mgmt_load_irks command
      Bluetooth: Enable support for remote IRK distribution
      Bluetooth: Fix properly ignoring unexpected SMP PDUs
      Bluetooth: Fix missing address type check for removing LTKs
      Bluetooth: Remove return values from functions that don't need them
      Bluetooth: Fix hci_remove_ltk failure when no match is found
      Bluetooth: Fix completing SMP as peripheral when no keys are expected
      Bluetooth: Fix removing any IRKs when unpairing devices
      Bluetooth: Add convenience function for fetching IRKs
      Bluetooth: Remove SMP data specific crypto context
      Bluetooth: Track the LE Identity Address in struct hci_conn
      Bluetooth: Fix updating Identity Address in L2CAP channels
      Bluetooth: Wait for SMP key distribution completion when pairing
      Bluetooth: Don't try to look up private addresses as Identity Address
      Bluetooth: Look up RPA for connection requests with Identity Address
      Bluetooth: Use Identity Address in Device Found event
      Bluetooth: Avoid using GFP_ATOMIC where not necessary
      Bluetooth: Return added key when adding LTKs and IRKs
      Bluetooth: Move New LTK store hint evaluation into mgmt_new_ltk
      Bluetooth: Track SMP keys in the SMP context
      Bluetooth: Move SMP LTK notification after key distribution
      Bluetooth: Add support for sending New IRK event
      Bluetooth: Fix iterating wrong list in hci_remove_irk()

Jurgen Kramer (1):
      Bluetooth: btusb: Add IMC Networks (Broadcom based)

Lucas De Marchi (1):
      Bluetooth: allocate static minor for vhci

Marcel Holtmann (48):
      Bluetooth: Add LMP feature definitions for Secure Connections support
      Bluetooth: Add HCI command definition for Secure Connections enabling
      Bluetooth: Add HCI command definition for extended OOB data
      Bluetooth: Add definitions for new link key types
      Bluetooth: Add support for handling P-256 derived link keys
      Bluetooth: Enable Authenticated Payload Timeout Expired event
      Bluetooth: Add flags and setting for Secure Connections support
      Bluetooth: Add management command for enabling Secure Connections
      Bluetooth: Enable Secure Connection during power on if configured
      Bluetooth: Limit acceptable link key types to only supported ones
      Bluetooth: Add support for local OOB data with Secure Connections
      Bluetooth: Add debugfs quirk for forcing Secure Connections support
      Bluetooth: Provide remote OOB data for Secure Connections
      Bluetooth: Add internal function for storing P-192 and P-256 data
      Bluetooth: Add support for remote OOB input of P-256 data
      Bluetooth: Track Secure Connections support of remote devices
      Bluetooth: Introduce requirements for security level 4
      Bluetooth: Handle security level 4 for L2CAP connections
      Bluetooth: Handle security level 4 for RFCOMM connections
      Bluetooth: Add debugfs entry to show Secure Connections Only mode
      Bluetooth: Increment management interface revision
      Bluetooth: Add management setting for use of debug keys
      Bluetooth: Add management command to allow use of debug keys
      Bluetooth: Remove use_debug_keys debugfs entry
      Bluetooth: Remove one level of indentation from hci_encrypt_change_evt
      Bluetooth: Track the AES-CCM encryption status of LE and BR/EDR links
      Bluetooth: Remove check for valid LTK authenticated parameter
      Bluetooth: Rename authentication to key_type in mgmt_ltk_info
      Bluetooth: Remove __packed from struct smp_ltk
      Bluetooth: Add management command for Secure Connection Only Mode
      Bluetooth: Include security level 4 in connections check
      Bluetooth: Track if link is using P-256 authenticated combination key
      Bluetooth: Add constants for LTK key types
      Bluetooth: Restrict long term keys to public and static addresses
      Bluetooth: Fix sending wrong store hint for new long term keys
      Bluetooth: Add missing index added event on user channel failure
      Bluetooth: Allow HCI User Channel usage for controllers without address
      Bluetooth: Report identity address when remote device connects
      Bluetooth: Use connection address for reporting connection failures
      Bluetooth: Fix wrong identity address during connection failures
      Bluetooth: Expose current list of identity resolving keys via debugfs
      Bluetooth: Use same LE min/max connection event length during update
      Bluetooth: Don't send store hint for devices using identity addresses
      Bluetooth: Add comment explainging store hint for long term keys
      Bluetooth: Replace own_address_type with force_static_address debugfs
      Bluetooth: Track the current configured random address
      Bluetooth: Provide option for changing LE advertising channel map
      Bluetooth: Increase minor version of core module

Oliver Neukum (2):
      Bluetooth: Enable Atheros 0cf3:311e for firmware upload
      Bluetooth: Add firmware update for Atheros 0cf3:311f

Peter Hurley (24):
      Revert "Bluetooth: Remove rfcomm_carrier_raised()"
      Revert "Bluetooth: Always wait for a connection on RFCOMM open()"
      Revert "Bluetooth: Move rfcomm_get_device() before rfcomm_dev_activate()"
      tty: Fix ref counting for port krefs
      Bluetooth: Fix racy acquire of rfcomm_dev reference
      Bluetooth: Exclude released devices from RFCOMMGETDEVLIST ioctl
      Bluetooth: Release rfcomm_dev only once
      Bluetooth: Fix unreleased rfcomm_dev reference
      Bluetooth: Fix RFCOMM tty teardown race
      Bluetooth: Verify dlci not in use before rfcomm_dev create
      Bluetooth: Simplify RFCOMM session state eval
      Bluetooth: Refactor deferred setup test in rfcomm_dlc_close()
      Bluetooth: Refactor dlc disconnect logic in rfcomm_dlc_close()
      Bluetooth: Directly close dlc for not yet started RFCOMM session
      Bluetooth: Fix unsafe RFCOMM device parenting
      Bluetooth: Fix RFCOMM parent device for reused dlc
      Bluetooth: Rename __rfcomm_dev_get() to __rfcomm_dev_lookup()
      Bluetooth: Serialize RFCOMMCREATEDEV and RFCOMMRELEASEDEV ioctls
      Bluetooth: Refactor rfcomm_dev_add()
      Bluetooth: Cleanup RFCOMM device registration error handling
      Bluetooth: Force -EIO from tty read/write if .activate() fails
      Bluetooth: Don't fail RFCOMM tty writes
      Bluetooth: Refactor write_room() calculation
      Bluetooth: Fix write_room() calculation

Szymon Janc (1):
      Bluetooth: Print error when dropping L2CAP data

Wei Yongjun (1):
      Bluetooth: Convert to use ATTRIBUTE_GROUPS macro

 Documentation/devices.txt         |   1 +
 drivers/bluetooth/ath3k.c         |  84 ++++----
 drivers/bluetooth/btusb.c         |  58 +++---
 drivers/bluetooth/hci_vhci.c      |   3 +-
 include/linux/miscdevice.h        |   1 +
 include/linux/tty.h               |   6 +-
 include/net/bluetooth/bluetooth.h |   1 +
 include/net/bluetooth/hci.h       |  49 ++++-
 include/net/bluetooth/hci_core.h  | 129 +++++++++---
 include/net/bluetooth/l2cap.h     |   8 +-
 include/net/bluetooth/mgmt.h      |  41 +++-
 include/net/bluetooth/rfcomm.h    |  10 +-
 net/bluetooth/a2mp.c              |   8 +-
 net/bluetooth/af_bluetooth.c      |   2 +-
 net/bluetooth/hci_conn.c          | 106 +++++++---
 net/bluetooth/hci_core.c          | 578 ++++++++++++++++++++++++++++++++++++++++++--------
 net/bluetooth/hci_event.c         | 206 ++++++++++++++----
 net/bluetooth/hci_sock.c          |   1 +
 net/bluetooth/hci_sysfs.c         |  18 +-
 net/bluetooth/l2cap_core.c        | 591 +++++++++++++++++++++++++++-------------------------
 net/bluetooth/l2cap_sock.c        |  62 +++---
 net/bluetooth/mgmt.c              | 492 ++++++++++++++++++++++++++++++++++++++-----
 net/bluetooth/rfcomm/core.c       |  92 ++++++--
 net/bluetooth/rfcomm/sock.c       |  33 ++-
 net/bluetooth/rfcomm/tty.c        | 262 ++++++++++++-----------
 net/bluetooth/smp.c               | 250 +++++++++++++++++++---
 net/bluetooth/smp.h               |  13 +-
 27 files changed, 2282 insertions(+), 823 deletions(-)

--/3yNEOqWowh/8j+e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTCA/QAAoJEPs3PUX4s20oUVMP/i2+ex4piHUBr0kML9uyQUm/
nB9OLDk6N+0rMTISQ4tsexf63WBH+KZ3dajAPN5uEinuA35QxPVn2cV5QzRFaROp
Je/qufn6VYq4ohkmd/DOFKmCc6Wc9G+GlpkBSfeX8889QnlzObBzRjfZplVbsHrh
HWx9K1vhKUbwATevEhlI2u4Ytyj5Z01HmBSGYLCKj5mshSvPMLZ3/JGDmkygcSze
/RcSmjxDD9wJ5Nh819SaY3h6o6U/o57rwXMhsorIV40xQIwPyLEdQE0DzOYC4+e6
DVuld8jdNYUq9p2YVhARJBe5Y64F/JPB12v/wE5b5uln7p0QL44tWyn2DKWgtbvU
hkUSjrwKyogu6RIuX7de1+0vtrcL72jS+dHAGYA6L18EE4EW2WvUvfksiHAC3N0w
0SA6tWPrruDbvnE7zmld0W4ixkg9JbVHBivk9oBh3OEr7wO51rZtUINqfy/H6iMO
uNpRQCNZBAHdh28tkVbB8CD2piYgVEZXbYkyayy9QboEfbw9eBt/cvXHqs7IaVuZ
PHdCYk4N8pTVLQh7S1DoLeUXtBiLJTdXmji2iT7UvXnCjpphf5StXQhT5sngo9fq
1n9vK2KCGPK6fd4wiNrkNfIaHvCP3M6H3kNRuHRLIL5J0l7OKxjZvQawRKoeB8X2
X6fvnJbJPsl7Nn4R0eIB
=uegU
-----END PGP SIGNATURE-----

--/3yNEOqWowh/8j+e--
