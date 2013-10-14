Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab3JNXw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 19:52:27 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:34024 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260Ab3JNXwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 19:52:24 -0400
Date: Mon, 14 Oct 2013 20:52:18 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2013-10-14
Message-ID: <20131014235218.GE2305@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

More patches for 3.12, busy times for Bluetooth. More than a 100 commits since
the last pull. The bulk of work comes from Johan and Marcel, they are doing
fixes and improvements all over the Bluetooth subsystem, as the diffstat can
show.

Please pull or let me know of any problems! Thanks.

	Gustavo
--
The following changes since commit 4f3e219d95a3c31b916dcd5e2631c4e440736f79:

  Bluetooth: Only one command per L2CAP LE signalling is supported (2013-10-03 16:09:59 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next for-upstream

for you to fetch changes up to 4b836f393bd8ed111857a6ee1865e44627266ec6:

  Bluetooth: Read current IAC LAP on controller setup (2013-10-14 19:31:18 -0300)

----------------------------------------------------------------
Andre Guedes (4):
      Bluetooth: Rename hci_conn variable in hci_connect_le()
      Bluetooth: Initialize hci_conn fields in hci_connect_le
      Bluetooth: Use HCI request for LE connection
      Bluetooth: Refactor hci_connect_le

Johan Hedberg (17):
      Bluetooth: Rename HCI_LE_PERIPHERAL to HCI_ADVERTISING
      Bluetooth: Add public mgmt function to send New Settings event
      Bluetooth: Fix re-enabling advertising after a connection
      Bluetooth: Fix changing advertising setting while LE is connected
      Bluetooth: Fix potential double-frees of L2CAP skbs
      Bluetooth: Fix checking for HCI_SETUP flag when receiving mgmt commands
      Bluetooth: Reorganize set_connectable HCI command sending
      Bluetooth: Move more logic into set_connectable complete callback
      Bluetooth: Add missing error handling for Set Connectable
      Bluetooth: Move static advertising functions to avoid forward declarations
      Bluetooth: Fix updating advertising data needlessly
      Bluetooth: Make Set Connectable also update the LE advertising type
      Bluetooth: Move set_bredr_scan() to avoid forward declaration
      Bluetooth: Fix updating scan mode in set_bredr()
      Bluetooth: Convert Set Discoverable to use an asynchronous request
      Bluetooth: Reject invalid bdaddr types for sockets
      Bluetooth: Check that bind() bdaddr type matches connect()

Johannes Berg (1):
      Bluetooth: Fix variable shadow warnings

Marcel Holtmann (117):
      Bluetooth: Fix controller list for AMP discover response
      Bluetooth: Remove useless external function to count controllers
      Bluetooth: Add constants for AMP controller type
      Bluetooth: Separate AMP controller type from HCI device type
      Bluetooth: Use explicit AMP controller id value for BR/EDR
      Bluetooth: Rename AMP status constants and use them
      Bluetooth: Remove pointless inline function
      Bluetooth: Remove check for number of AMP controller
      Bluetooth: Move hci_amp_capable() function into L2CAP core
      Bluetooth: Simplify check if L2CAP connection is AMP capable
      Bluetooth: Check for non BR/EDR controller in AMP discover response
      Bluetooth: Reject enabling controllers without valid addresses
      Bluetooth: Use explicit check for BR/EDR device type
      Bluetooth: Simplify device type check for AMP discover response
      Bluetooth: Use random address if public address is not available
      Bluetooth: Add HCI structure for LE advertising parameters command
      Bluetooth: Make it clear that disabling LE disables advertising
      Bluetooth: Use helper functions for enabling/disabling advertising
      Bluetooth: Add constants for LE advertising types
      Bluetooth: Set LE advertising parameters before enabling it
      Bluetooth: Use helper function for re-enabling advertising
      Bluetooth: Remove no longer needed mgmt_new_settings() function
      Bluetooth: Remove mgmt_valid_hdev() helper function
      Bluetooth: Send new settings only when pairable changes
      Bluetooth: Make mgmt_index_added() and mgmt_index_removed() return void
      Bluetooth: Make mgmt_set_powered_failed() return void
      Bluetooth: Make mgmt_disconnect_failed() return void
      Bluetooth: Make mgmt_connect_failed() return void
      Bluetooth: Make mgmt_device_connected() return void
      Bluetooth: Make mgmt_device_disconnected() return void
      Bluetooth: Make mgmt_device_found() return void
      Bluetooth: Make mgmt_remote_name() return void
      Bluetooth: Make mgmt_discovering() return void
      Bluetooth: Power off AMP controllers after setup phase
      Bluetooth: Make mgmt power down notification for BR/EDR explicit
      Bluetooth: List powered down AMP controllers correctly
      Bluetooth: Read supported features and commands on AMP controllers
      Bluetooth: Read location data on AMP controller init
      Bluetooth: Read flow control mode on AMP controller init
      Bluetooth: Remove unneeded val variable when setting SSP
      Bluetooth: Restrict high speed support to SSP enabled controllers
      Bluetooth: Fix too long line with set_advertising() function
      Bluetooth: Use hci_conn_num() for checking number of LE connections
      Bluetooth: Use hci_conn_num() instead of direct connection hash access
      Bluetooth: AMP contollers do not support the legacy ioctls
      Bluetooth: Remove unused bfusb_ioctl() callback
      Bluetooth: Remove unused bluecard_hci_ioctl() callback
      Bluetooth: Remove unused bt3c_hci_ioctl() callback
      Bluetooth: Remove unused btuart_hci_ioctl() callback
      Bluetooth: Remove unused dtl1_hci_ioctl() callback
      Bluetooth: Remove unused btmrvl_ioctl() callback
      Bluetooth: Remove hdev->ioctl driver callback
      Bluetooth: Move amp.h header file into net/bluetooth/
      Bluetooth: Move a2mp.h header file into net/bluetooth/
      Bluetooth: Move smp.h header file into net/bluetooth/
      Bluetooth: Move skb->dev assignment for hdev->send into central place
      Bluetooth: Remove pointless check of hci_send_frame parameter
      Bluetooth: Remove return value from hci_send_frame() function
      Bluetooth: Remove unused h4_check_data_len() function
      Bluetooth: Provide hdev parameter to hci_recv_frame() driver callback
      Bluetooth: Add hdev parameter to hdev->send driver callback
      Bluetooth: Remove pointless parameter check in bfusb_send_frame()
      Bluetooth: Remove pointless parameter check in bluecard_hci_send_frame()
      Bluetooth: Remove pointless parameter check in bt3c_hci_send_frame()
      Bluetooth: Remove pointless parameter check in btmrvl_send_frame()
      Bluetooth: Remove pointless parameter check in btuart_hci_send_frame()
      Bluetooth: Remove pointless parameter check in dtl1_hci_send_frame()
      Bluetooth: Remove pointless parameter check in hci_uart_send_frame()
      Bluetooth: Remove pointless parameter check in vhci_send_frame()
      Bluetooth: Declare btusb_table[] and blacklist_table[] as const
      Bluetooth: Declare bfusb_table[] as const
      Bluetooth: Declare bpa10x_table[] as const
      Bluetooth: Declare ath3k_table[] and ath3k_blist_tbl[] as const
      Bluetooth: Make LE scan interval and window a controller option
      Bluetooth: Add management command for setting LE scan parameters
      Bluetooth: Fix endless loop with HCI_QUIRK_RESET_ON_CLOSE
      Bluetooth: Don't advertise high speed support without SSP
      Bluetooth: Add MGMT_OP_SET_SCAN_PARAMS to supported commands list
      Bluetooth: Fix HCI init for 1st generation BlueFRITZ! devices
      Bluetooth: Fix PSM value for L2CAP connectionless data packets
      Bluetooth: Limit security mode 4 level 0 to connection oriented channels
      Bluetooth: Allow 3D profile to use security mode 4 level 0
      Bluetooth: The L2CAP fixed channel connectionless data is supported
      Bluetooth: Unicast connectionless data reception is supported
      Bluetooth: Remove l2cap_conn->dst usage from AMP manager
      Bluetooth: Remove l2cap_conn->src and l2cap_conn->dst usage from SMP
      Bluetooth: Remove l2cap_conn->src and l2cap_conn->dst usage from L2CAP
      Bluetooth: Remove l2cap_conn->src and l2cap_conn->dst pointers
      Bluetooth: Remove pointless bdaddr_to_le() helper function
      Bluetooth: Store the source address type of LE connections
      Bluetooth: Store source address of HCI connections
      Bluetooth: Update source address and type for incoming LE connections
      Bluetooth: Use hci_conn->src address for SMP functions
      Bluetooth: Use hci_conn->src address for L2CAP functions
      Bluetooth: Fix input address type for SMP C1 function
      Bluetooth: Fix coding style violations in SMP handling
      Bluetooth: Update L2CAP socket source address from HCI connection
      Bluetooth: Store address information in L2CAP channel structure
      Bluetooth: Return the correct address type for L2CAP sockets
      Bluetooth: Access RFCOMM session addresses through L2CAP channel
      Bluetooth: Access CMTP session addresses through L2CAP channel
      Bluetooth: Access HIDP session addresses through L2CAP channel
      Bluetooth: Access BNEP session addresses through L2CAP channel
      Bluetooth: Use SCO addresses from HCI connection directly
      Bluetooth: Store SCO address information in its own socket structure
      Bluetooth: Store RFCOMM address information in its own socket structure
      Bluetooth: Remove src and dst fields from bt_sock structure
      Bluetooth: Use l2cap_pi(sk) directly where possible
      Bluetooth: Add support for per socket msg_name callback
      Bluetooth: Provide msg_name callback for L2CAP connectionless channels
      Bluetooth: Increase minor version of core module
      Bluetooth: Adjust header for proc socket information
      Bluetooth: Introduce L2CAP channel flag for defer setup
      Bluetooth: Introduce L2CAP channel callback for resuming
      Bluetooth: Check that scan window is smaller or equal than scan interval
      Bluetooth: Read number of supported IAC on controller setup
      Bluetooth: Read current IAC LAP on controller setup

 drivers/bluetooth/ath3k.c             |   4 +-
 drivers/bluetooth/bfusb.c             |  31 +--
 drivers/bluetooth/bluecard_cs.c       |  30 +--
 drivers/bluetooth/bpa10x.c            |  11 +-
 drivers/bluetooth/bt3c_cs.c           |  30 +--
 drivers/bluetooth/btmrvl_main.c       |  26 +-
 drivers/bluetooth/btmrvl_sdio.c       |   8 +-
 drivers/bluetooth/btsdio.c            |   6 +-
 drivers/bluetooth/btuart_cs.c         |  30 +--
 drivers/bluetooth/btusb.c             |  21 +-
 drivers/bluetooth/btwilink.c          |   9 +-
 drivers/bluetooth/dtl1_cs.c           |  30 +--
 drivers/bluetooth/hci_bcsp.c          |   5 +-
 drivers/bluetooth/hci_h4.c            |  24 --
 drivers/bluetooth/hci_h5.c            |   2 +-
 drivers/bluetooth/hci_ldisc.c         |  12 +-
 drivers/bluetooth/hci_ll.c            |  14 +-
 drivers/bluetooth/hci_vhci.c          |  15 +-
 include/net/bluetooth/bluetooth.h     |   5 +-
 include/net/bluetooth/hci.h           |  49 +++-
 include/net/bluetooth/hci_core.h      |  79 ++-----
 include/net/bluetooth/l2cap.h         |  14 +-
 include/net/bluetooth/mgmt.h          |   7 +
 include/net/bluetooth/rfcomm.h        |   2 +
 include/net/bluetooth/sco.h           |   5 +-
 net/bluetooth/a2mp.c                  |  63 ++---
 {include/net => net}/bluetooth/a2mp.h |   0
 net/bluetooth/af_bluetooth.c          |  23 +-
 net/bluetooth/amp.c                   |  10 +-
 {include/net => net}/bluetooth/amp.h  |   0
 net/bluetooth/bnep/core.c             |  18 +-
 net/bluetooth/cmtp/core.c             |   6 +-
 net/bluetooth/hci_conn.c              | 156 ++++++++----
 net/bluetooth/hci_core.c              | 156 +++++++-----
 net/bluetooth/hci_event.c             | 103 ++++----
 net/bluetooth/hci_sock.c              |  10 +-
 net/bluetooth/hidp/core.c             |  18 +-
 net/bluetooth/l2cap_core.c            | 221 ++++++++++-------
 net/bluetooth/l2cap_sock.c            |  86 +++++--
 net/bluetooth/mgmt.c                  | 550 ++++++++++++++++++++++++++++++-------------
 net/bluetooth/rfcomm/core.c           |  19 +-
 net/bluetooth/rfcomm/sock.c           |  28 ++-
 net/bluetooth/sco.c                   |  44 ++--
 net/bluetooth/smp.c                   |  81 ++++---
 {include/net => net}/bluetooth/smp.h  |   0
 45 files changed, 1192 insertions(+), 869 deletions(-)
 rename {include/net => net}/bluetooth/a2mp.h (100%)
 rename {include/net => net}/bluetooth/amp.h (100%)
 rename {include/net => net}/bluetooth/smp.h (100%)


--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSXIOyAAoJEPs3PUX4s20obCIP/2v7q6M6iWGExllqLdrbm76o
5FpHsm8cXT0xeFeURzPtUrRdpzP1Ae6ITFR87YllKehSCSCoNt7KFQHS+zeKGK97
3Poag/lN/nz6MMpEemYLlBoQEHqWE5sTCq5j9K00GJcx9x3kKlEccjgeo2eclbnf
EqP9oY/BBaCaH+Q/ilrKFh0ZBM0J0L+zEwsQ3Qy26YkbjMntq1vgK04khomyc/2T
uJ2Azrpe1kL0WO9TjbtMxeGSc1dH096QsXCYzGwPhcM2gYsv3nP/E5kQ3C+7U0Ev
WciC63psVC9lyGMhYxlRYnYy5DL/lP14W36LtFRNIx5LOwTQ2FdrizYvpcAHT36Q
iWk9Uz4mBCPIC5uM1KuBKQRsfH3XJtdCCX1jqR4AWN9AUgyyaFvUSKucv9m/n38U
f2sMC1FPt7iiFR1ANW2Yrv3yehbIj5N5lfe3cM03hgnyZKZy/2qruC9B0PCNW3Cm
Sq1qgiMdZvwMST8qf74pedkTNhDgWwEFhh8460MrkHTti0B5XDZaB7Gv+z93FxNw
zxXMv9DFoeINbBcheKQAadN0Hn51YAu3kW15YOghCEAqTpP+839oDJRbLNkVJdSW
u4c/VlRBqC2Dxf0gnJbsBkJ+YpTkjGL57Ac/BIZ3GHeqOf7f+GIhChZnlaVknztu
TCKnejAc7wiznf+1K8xP
=FPHs
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
