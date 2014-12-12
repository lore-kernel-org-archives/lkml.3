Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935150AbaLLRoq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:44:46 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:54997 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934073AbaLLRoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:44:44 -0500
Date: Fri, 12 Dec 2014 19:44:35 +0200
From: Johan Hedberg <johan.hedberg@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2014-12-12
Message-ID: <20141212174435.GA22678@t440s.P-661HNU-F1>
Mail-Followup-To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

These fixes are intended for 3.19, note that the tree to pull from is
bluetooth-next (unlike the subject implies). I'd have normally done a
pull request from bluetooth.git, but since these fixes for 3.19 is all
we have so far I thought it's simpler if you just pull from our -next
tree. The patches consist of:

 - Coccinelle warning fix
 - hci_dev_lock/unlock fixes
 - Fixes for pending mgmt command handling
 - Fixes for properly following the force_lesc_support switch
 - Fix for a Microsoft branded Broadcom adapter
 - New device id for Atheros AR3012
 - Fix for BR/EDR Secure Connections enabling

Please let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit 5a34bd5f5d8119def4feb1d2b4e3906b71059416:

  Bluetooth: Enable events for P-256 Public Key and DHKey commands (2014-12-05 18:17:49 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to 9845904fd489288bcf693642c1b31cc463c0b660:

  Bluetooth: Fix mgmt response status when removing adapter (2014-12-12 13:20:12 +0100)

----------------------------------------------------------------
Fengguang Wu (1):
      Bluetooth: fix err_cast.cocci warnings

Jaganath Kanakkassery (2):
      Bluetooth: Fix missing hci_dev_lock/unlock in mgmt req_complete()
      Bluetooth: Fix missing hci_dev_lock/unlock in hci_event

Janne Heikkinen (1):
      Bluetooth: Add USB device 04ca:3010 as Atheros AR3012

Johan Hedberg (5):
      Bluetooth: Fix calling hci_conn_put too early
      Bluetooth: Fix incorrect pending cmd removal in pairing_complete()
      Bluetooth: Fix notifying mgmt power off before flushing connection list
      Bluetooth: Fix enabling BR/EDR SC when powering on
      Bluetooth: Fix mgmt response status when removing adapter

Marcel Holtmann (4):
      Bluetooth: Check for force_lesc_support when enabling SMP over BR/EDR
      Bluetooth: Check for force_lesc_support before rejecting SMP over BR/EDR
      Bluetooth: Fix generation of non-resolvable private addresses
      Bluetooth: Fix check for support for page scan related commands

 drivers/bluetooth/ath3k.c  |  2 ++
 drivers/bluetooth/btusb.c  |  1 +
 net/bluetooth/hci_conn.c   |  2 +-
 net/bluetooth/hci_core.c   | 60 +++++++++++++++++++-------------
 net/bluetooth/hci_event.c  | 20 +++++++++++
 net/bluetooth/l2cap_core.c |  5 +--
 net/bluetooth/mgmt.c       | 85 ++++++++++++++++++++++++++++++++-------------
 net/bluetooth/smp.c        |  5 +--
 8 files changed, 126 insertions(+), 54 deletions(-)


--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUiymCAAoJECQj9vv5qNQSTOQP/24LXL/Zc6ny2HLhfWm/XsAI
2Er5dpB9jcMwlkuLgeo64hmHIcWjd0WXFrsHExA5hLcL2j1EWZodeqFGq+Ojo1yV
9Nxn7S/QRxzvpiyQZhxaU0C6iGayVHkNO9/b9VegfPo+ynub8qlGy6j/7oVMwFfA
NSY/uSMRUu1e0VWzPOvXOp6kL2Av1rc/U7chT6CTggAMEUJc8hvoD+p4gmqWYSlt
EjxEKJjb5I5o2zrhb0GV+wpQrixen10apvVjzLNuWX+K0zHLVG5cBJmoG1y9g1pd
xiZllH4hSrb0uzBhN7JtzMOBR8lywyXsvnfGlmOmN9WYPd9GRkIQSZzjeWyGj3wo
0bEaVMmrehxot3eJf33HakJ3eXXSlB8MTCVctaDzhAZtM/Aj2v/GKpbQELev2EUE
bzLam55rdwiT+Cylgo85Nglp8t/o21sb8KXJVzjJe3K57WEB5PSvqcamD28aV28O
opslbin4nRykS5QlK3cPbCI+Q8YmbiY+MEzkJ2GCojdobDOMltwiUTZn1YPlugyh
kIbYfTpA8qd0cjuCZVT1RUUjt7eN9pR7hbMmeqyajP47cmXxxHzSplaVrVYmhFzg
bCxej3WDbFtmm+6ISX2NJj7mtakNxGlFMkwHsia3bQYfZo8LsBSgqiFBKI8dFvSo
qx680iNTcRve2xTd16Py
=gxVH
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
