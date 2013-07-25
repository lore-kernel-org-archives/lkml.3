Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab3GYNGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:06:03 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:53674 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954Ab3GYNF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:05:58 -0400
Date: Thu, 25 Jul 2013 14:05:54 +0100
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2013-07-25
Message-ID: <20130725130552.GE9913@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

A few fixes and devices ID additions for 3.11:=20

 * There are 3 new ath3k device ids=20
 * Fixed stack memory usage in ath3k.
 * Fixed the init process of BlueFRITZ! devices, they were failing to init
   due to an unsupported command we sent.=20
 * Fixed wrong use of PTR_ERR in btusb code that was preventing intel devic=
es
   to work properly=20
 * Fixed race codition between hci_register_dev() and hci_dev_open() that
   could cause a NULL pointer dereference.

Please pull or let me know of any issues. Thanks.

	Gustavo

--
The following changes since commit 57bf74407bd501b0599568a3112fc16395b575d9:

  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/bl=
uetooth/bluetooth (2013-06-24 13:53:15 -0400)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth for-ups=
tream

for you to fetch changes up to 352c3b276ca7e2df479cd0b9b87d227f14efb20a:

  Bluetooth: Fix race between hci_register_dev() and hci_dev_open() (2013-0=
7-25 13:55:59 +0100)

----------------------------------------------------------------
AceLan Kao (1):
      Bluetooth: Add support for Atheros [0cf3:3121]

Adam Lee (1):
      Bluetooth: fix wrong use of PTR_ERR() in btusb

Gustavo Padovan (1):
      Bluetooth: Fix race between hci_register_dev() and hci_dev_open()

Johan Hedberg (1):
      Bluetooth: Fix HCI init for BlueFRITZ! devices

Stanislaw Gruszka (1):
      Bluetooth: ath3k: don't use stack memory for DMA

Sujith Manoharan (1):
      Bluetooth: ath3k: Add support for ID 0x13d3/0x3402

Thomas Loo (1):
      Bluetooth: ath3k: Add support for Fujitsu Lifebook UH5x2 [04c5:1330]

 drivers/bluetooth/ath3k.c | 44 +++++++++++++++++++++++++++++++++++---------
 drivers/bluetooth/btusb.c | 17 ++++++++++-------
 net/bluetooth/hci_core.c  | 16 ++++++++--------
 3 files changed, 53 insertions(+), 24 deletions(-)


--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJR8SKwAAoJEPs3PUX4s20oloMP/3xtV+rqwF8B7KDxMaRv4CgN
Nh51XXfGotIph40PNDhj8Q/86FElTVpQYc48J0PqIx2RzMdjPOCDecVUqI5rgc+O
Bf7U/z09mwYJnazQOn+nqAcxLFBn/0OrhRIZdQE8ex48Z1o6M2N/VapVa4gyXN4Y
8xZTjQ8vdKOgaCMOWSkzhYYlOqdIw8qlFA7biL5KgSLeABZWn5KxDvGUf7ktgm3g
YcaoU/7twRwwije3fO9523ak4IQNDREljfo0hw6CCslWKSeu2iVXqsPDViO16e+u
0vFBA1yB+7094SNEI081+fBEE1us21nlUJNME6RGe3z5VGeJWTxy6L2ZWFpr00Px
ZsLbv5zI4KycGuOu1L92RLWc3MXxFe84ccdil47CxLK/L6SEJGp/HanjmxLVlWFo
m4DpOF4RHQ0DmqqnuP687C76TH2cUgmT4MXLhYFLj3LzUVQ1S+2IRp841Mqg+Gej
QxHLw+tLqbIhxRgzCTnToZ18mQvTQGg2n8U+FbG7WfH/OY8Ts0ZkAuu4q2DH+P/Z
FStw9u26kVvBXZAymxMB6JuQf1Ma/a7GjgjtrsFE6khwBu6uT1955M1IYtzt48fe
C4nG6eAQAOmYuow2aNa+zI82si35SON9hWNOf6u2fmMqJzUmujVfJ1El3e5n8phx
i5bCLARqvrOClrAExfIJ
=GOMw
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
