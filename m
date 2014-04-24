Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827AbaDXOxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:53:37 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:38069 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235AbaDXOxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:53:34 -0400
Date: Thu, 24 Apr 2014 11:53:29 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2014-04-24
Message-ID: <20140424145329.GD7832@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

Some fixes for 3.15. There is a revert for the intel driver, a new device id,
and two important SSP fixes from Johan.
Also we've noticed that your wireless.git tree is not up to date, so this pull
was rebased on top of net.git. If you pull from this you'll will be pulling
net/master from yesterday as well.

Please pull or let me know of any concerns you have. Thanks!

	Gustavo

---
The following changes since commit 6a51b5e4d59e00051e65e836520912cd7c717be1:

  hisax/icc: add missing semicolon after label (2014-04-22 21:22:47 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git for-upstream

for you to fetch changes up to b66a81831359495b3768ace72452209cdf5d6614:

  Bluetooth: Add support for Lite-on [04ca:3007] (2014-04-24 12:43:33 +0300)

----------------------------------------------------------------
Johan Hedberg (2):
      Bluetooth: Fix triggering BR/EDR L2CAP Connect too early
      Bluetooth: Fix redundant encryption request for reauthentication

Marcel Holtmann (1):
      Revert "Bluetooth: Enable autosuspend for Intel Bluetooth device"

Mohammed Habibulla (1):
      Bluetooth: Add support for Lite-on [04ca:3007]

 drivers/bluetooth/ath3k.c | 2 ++
 drivers/bluetooth/btusb.c | 5 ++---
 net/bluetooth/hci_conn.c  | 9 ++++++---
 net/bluetooth/hci_event.c | 6 ++++++
 4 files changed, 16 insertions(+), 6 deletions(-)


--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWSVpAAoJEPs3PUX4s20oLWQP/1hhfe6EZ45Sec94NIsSYB5K
EZYvvOX4sKj3VhTT/dzKIBZDp7aLHyBZGB4HRBezKe0KqiNFV3eVU9Um1BsWxCgH
u5S/PgS1yj2BOSgCJAy2dZPYqQii8KEUugIocRMzqs6ZtolbnaucQexSy65af4hY
MVyHPUCRgtYi9tMDu/JTyi3b+LDzYgztYG5mgLzuw3zz2SaGc9bLdJIQ4aPyaIge
rwzoLxPJKxfF+7xIObhVccMK150AjwapsN9/oV+FGDmP83zxXxGoBOFGf8lorQbh
2C4Ol0zqJj8pob3cQxExwZjmVX9LG0vm/wqeNW9E3wKfelhkwdf4cF25kvfvnPAl
pjhhjp7ssbEBnPhxwKqJIEb6VuAaZPMYuV+62g9gcU3wq2LCSSRI1s31LgEiNBbh
7HedJ12UD4Q6BqHzrSf4Mc3Bhli1jz1HL4wwZy2DxqhAu7mlRxHVjkg+iupeSp6l
jJDjbWdzF3WH/E+lhJCI9mgGQb97X1ZwzCjLJxO2/QXDs2RlQU6+bSjbDbUDec9+
0mrRNbfJgzdezuHBFWQEX0UkKG6E6mliXmJ+GH9OJDHA+VTIyMtm7vjowe68jMZW
a1Iq52ijBMKlo1goMlkVR8K3KE0PpWNSSh0TdoYzrYWzBo8uM80uasyuNDvyhdqc
Ab1PYbsWaogXz91HHxYG
=TAG1
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
