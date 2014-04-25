Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbaDYMqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 08:46:11 -0400
Received: from mail-yk0-f180.google.com ([209.85.160.180]:62683 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaDYMqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 08:46:08 -0400
Date: Fri, 25 Apr 2014 09:46:02 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2014-04-25
Message-ID: <20140425124602.GF7832@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Md/poaVZ8hnGTzuv"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Md/poaVZ8hnGTzuv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Some fixes for 3.15. There is a revert for the intel driver, a new device i=
d,
and two important SSP fixes from Johan. This one is rebased on wireless/mas=
ter.

Please pull or let me know of any concerns you have. Thanks!
=09
	Gustavo

---
The following changes since commit ffa216bb5eecfce0f01b0b2a95d5c320dde90005:

  brcmfmac: Fix brcmf_chip_ai_coredisable not applying reset bits to BCMA_I=
OCTL (2014-04-24 21:46:22 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git for=
-upstream

for you to fetch changes up to 1fb4e09a7e780b915dbd172592ae7e2a4c071065:

  Bluetooth: Add support for Lite-on [04ca:3007] (2014-04-25 09:47:16 +0300)

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


--Md/poaVZ8hnGTzuv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWlkKAAoJEPs3PUX4s20oaP8P/0L4mTwU2Ek/GSV3MGv+sZx+
8jeW319sWQYW9jo1CqNOqbgvuSecgnaptHInuz5AlHnjHycRlB4o3vRWgeqHhbRf
1v/zB5iyXjinvd7r32d5GdDem7OUs46LWhAo4Qv65RW6XaoRR8iE/DbL2uHXF7gk
fmknTntK8QHKjVwZmpbo14FnahCDLvxff0fMM7gkuEZntYFmj8LbEoNjZMU8bwgD
86AWhCIfijzKUhkXNYaiVLPd9xzk8rApH8ziJaYfocGuO9o4/yexLr2Gqi5e7XyI
u6gqYXBg8y6LeA3MlF7O5Vb1w5f4zmzfnz6c3js+qRq1nKrSteKYzINwKXE52zVd
EbmqnOxbUThCG0Z2N/aIp7kBprit3IoW2OlT6lOI6CdgmQAUsOjGd21SjNHIPvTq
ZjcdhsDdekrM7KrGq5q94WdmnfidFTa6j7ZwqRkUsR8bAY6do5uYlY+DSBrkJrTH
VmNnGm72zXnlYdmWFBP1NEvQYx/+EEuoEfJnmRu+jG/0v3WReLhHBq1/TqPGDCdq
YxDzgK+rjyEBeVOB2h9BUpJYwp+++1BLfG2X6gj6SFlsab8PC+YS6HD+JD7AgXHH
yJXbx/lZeClHeby6UtOcg8Zt2fFvxWoywijkiozDTWLe3v3NRngMaDy+ufeHVfNh
4Ms5NZ5mL4320Gand74C
=PzFE
-----END PGP SIGNATURE-----

--Md/poaVZ8hnGTzuv--
