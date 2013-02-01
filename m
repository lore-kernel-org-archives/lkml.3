Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab3BASCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 13:02:40 -0500
Received: from mail-gh0-f179.google.com ([209.85.160.179]:64660 "EHLO
	mail-gh0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab3BASCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 13:02:38 -0500
Date: Fri, 1 Feb 2013 15:33:02 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2013-02-01
Message-ID: <20130201173302.GC4733@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

Two simple fixes for 3.8. One of the patches fixes a situation where the
connection wasn't terminated if a timeout ocurrs for LE an SCO connections.
The other fixes prevent NULL dereference in the SMP code, it is a security fix
as well.

Please pull, or let me know of any problems!

        Gustavo

---
The following changes since commit b7e98b5100aad9290d7f06fcb9d1e80f7f62f05f:

  Bluetooth: Check if the hci connection exists in SCO shutdown (2013-01-10 03:53:32 -0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth for-upstream

for you to fetch changes up to 4c02e2d444595200d0b18b889994aac3611cd288:

  Bluetooth: Fix hci_conn timeout routine (2013-01-31 15:38:02 -0200)

----------------------------------------------------------------
Andre Guedes (1):
      Bluetooth: Fix hci_conn timeout routine

Johan Hedberg (1):
      Bluetooth: Fix handling of unexpected SMP PDUs

 net/bluetooth/hci_conn.c |  6 +++---
 net/bluetooth/smp.c      | 13 +++++++++++++
 2 files changed, 16 insertions(+), 3 deletions(-)

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRC/xOAAoJEPs3PUX4s20oCc4QAKY9IS8/VoAdwYvBLtxqMH5I
o29e2M1ELWDauTU88dG7IgRFrNpe+STnlJM57u4sfqo9fhasSFMTvA1AtvlkYTtP
k4j9AGGVhkTL8JcYT1Gz5dIVxSuExv20lsXK/uHEJYtiO7krs1TYwh9paGbjMwFK
ff13uKEuIyNxJ28JisyDrN2TbSr/AuVNUraAfuXLSjWU0qWt30ec9+cUKGUrhmS/
+hHKQfLJZiVPISoE0g9lirRljEKG2virLC9/kXCzyJqdiufJ1QFTUJPtZ1y4S9N+
U7R+2pbc4gF8E/WXqerMyciQrwKP3LZVNdUfU9IIHN5TbN5LHFh9Z0egv9/Id2MV
JJeh0Ygf5r6gyNvDvyxA6nNXfNlPPqEcGlyVSUtPcnuuXR7dwKgBIEKnWL+9/leT
JUO4/e/deKaSoB7IKIgZaYH3U2bjAS9M35SejDtc1uLnfemEJ5HKZqNzML7RdFjN
C+TvKjAgA2O2PMMGlOgg8w0kE95IDRvSXTnLX8QHP8poeVPOKyR4KKIi0hl0csR2
NK57y8cmsKSLUiyoUkIiRypk7aGAaRFhASn+8Oocbj6u2xKsDnpvA5oAkBz0uo/p
qz3naWoplG1n39NxtJ4btGcLGcF2nisQ7IHMaF5I2v0cgtqpagf07FvaDrRea792
lgySATt0MNaVfMWcdFNQ
=2CcP
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
