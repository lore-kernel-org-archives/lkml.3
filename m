Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab3AXDLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:11:14 -0500
Received: from mail-gg0-f176.google.com ([209.85.161.176]:43609 "EHLO
	mail-gg0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab3AXDLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:11:00 -0500
Date: Thu, 24 Jan 2013 01:10:52 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2013-01-24
Message-ID: <20130124031052.GE1632@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

This is my first pull request to 3.9. The biggest changes here are from Johan
Hedberg who made a lot of fixes in the Management interface. The issues arose
due to a new test tool we wrote and the usage of the Management interface as
default in BlueZ 5. The rest of the patches are more clean ups and small
fixes.

Please pull! Thanks!


	Gustavo
---
The following changes since commit e7f767a7d9f809c494bfffffeda2bbdbfec110b4:

  mwifiex: use map/unmap APIs in TX and RX to reduce memcpy (2013-01-07 15:18:30 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next for-upstream

for you to fetch changes up to 9b008c0457e583e10e62d1215bed6ab26ee54906:

  Bluetooth: Add support for reading LE supported states (2013-01-23 02:09:16 -0200)

----------------------------------------------------------------
Andrei Emeltchenko (4):
      Bluetooth: AMP: Send A2MP Create Phylink Rsp after Assoc write
      Bluetooth: AMP: Clean up logical link create / accept
      Bluetooth: AMP: Remove dead code
      Bluetooth: AMP: Use set_bit / test_bit for amp_mgr state

Gustavo Padovan (1):
      Bluetooth: Fix uuid output in debugfs

Johan Hedberg (25):
      Bluetooth: Fix missing command complete event for mgmt_confirm_name
      Bluetooth: Fix missing command complete for mgmt_load_long_term_keys
      Bluetooth: Fix checking for valid device class values
      Bluetooth: Fix accepting set_dev_class for non-BR/EDR controllers
      Bluetooth: Move non-critical sections outside of the dev lock
      Bluetooth: Fix checking for exact values of boolean mgmt parameters
      Bluetooth: Fix returning proper command status for start_discovery
      Bluetooth: Fix sending incorrect new_settings for mgmt_set_powered
      Bluetooth: Add a new workqueue for hci_request operations
      Bluetooth: Use req_workqueue for hci_request operations
      Bluetooth: Fix using system-global workqueue when not necessary
      Bluetooth: Fix Class of Device indication when powering off
      Bluetooth: Fix checking for correct mgmt_load_link_keys parameters
      Bluetooth: Fix returning proper mgmt status for Load LTKs
      Bluetooth: Fix checking for proper key->master value in Load LTKs
      Bluetooth: Refactor valid LTK data testing into its own function
      Bluetooth: Check for valid key->authenticated value for LTKs
      Bluetooth: Add helper functions for testing bdaddr types
      Bluetooth: Fix checking for valid address type values in mgmt commands
      Bluetooth: Fix checking for valid disconnect parameters in unpair_device
      Bluetooth: Fix returning proper cmd_complete for mgmt_disconnect
      Bluetooth: Fix returning proper cmd_complete for mgmt_block/unblock
      Bluetooth: Add LE Local Features reading support
      Bluetooth: Add support for reading LE White List Size
      Bluetooth: Add support for reading LE supported states

Rami Rosen (2):
      Bluetooth: Remove unnecessary include l2cap.h
      Bluetooth: remove an unused variable in a header file

Szymon Janc (3):
      Bluetooth: mgmt: Remove not needed restriction on add/remove OOB data
      Bluetooth: mgmt: Avoid using magic number in status code
      Bluetooth: Fix pair device command reply if adapter is powered off

 include/net/bluetooth/a2mp.h      |   4 +-
 include/net/bluetooth/bluetooth.h |  23 ++++
 include/net/bluetooth/hci.h       |  18 +++
 include/net/bluetooth/hci_core.h  |   4 +
 include/net/bluetooth/l2cap.h     |   1 -
 net/bluetooth/a2mp.c              |  42 ++++++-
 net/bluetooth/amp.c               |  25 ++--
 net/bluetooth/bnep/core.c         |   1 -
 net/bluetooth/hci_core.c          |  20 ++-
 net/bluetooth/hci_event.c         |  60 +++++++++
 net/bluetooth/hci_sysfs.c         |  22 ++--
 net/bluetooth/l2cap_core.c        |   5 -
 net/bluetooth/mgmt.c              | 270 ++++++++++++++++++++++++++++------------
 13 files changed, 375 insertions(+), 120 deletions(-)




--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRAKY8AAoJEPs3PUX4s20oEhkP/R0ERhijCGwywHGBXiq1u5t7
9T2KZq6cEK+1teMbzH6A0ehynatKCER7LVJkHb1gNjT5wKSFgxa7jfEDo6qLeKHQ
Tgl6PXC3b1GB+QFgBfIiZ7uFdEq/M0MZW/MUHHoR0N38+mnHqvbQtHQnCfcWEbnF
Ybf08EapBlPG2dslhFDk9+xi2/SaaRoPwUiXu9cBatqTG4mLTlTfcp/dnHxRA/50
nWSzwkl8tMNUn0tBkK/NgF7NfOp2jXVYEcMjqEiM1ck3WPIPLSGeTp8ONlGkL+TS
2ppc7s2NDXpkZ9DChofWA6gLSGfqz7f8uWeNSzgVJZygY9M/D5YHFVEuVqbYZ1g4
Ou67W+CEu98iDPJjZtJ07rOq2flZxuAZIrYp+cjH9yIZZRnKa16GuMJEJfVby1tH
6cGZJQZJL7u/Zec564pli3Gpml84czyhsaAR/MY1LTOuUWqq5gMU4pjofEL1wykI
Oh530u2Yk7p/Amvh294dlHP5CbS1OruMlaJfOvZkxTSTm1bbZb9+99Ejiwd7z0t3
vnN32nX4ZgOz09Ka9i38p7TBatVkTqrmjZOZ3+pi2l9Y/OALXhu6k6EcBDqt/LLX
c2XeMl2on6XpYlvmLBhKNCKlsSQMG6ZpZ4Ic9Tnu8OMPZlFv22toWjZknM9b1Qpz
2GEehV/KrFeiKEX1qiwa
=ZKlL
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
