Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaBMHKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 02:10:55 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:62834 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaBMHKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 02:10:53 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: netdev@vger.kernel.org
Cc: Srikanth Thokala <sthokal@xilinx.com>, monstr@monstr.eu,
        John Linn <John.Linn@xilinx.com>,
        Anirudha Sarangi <anirudh@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 0/2] Xilinx axi ethernet bug fixes
Date: Thu, 13 Feb 2014 08:10:41 +0100
Message-Id: <cover.1392275432.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-8689-1392275443-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-8689-1392275443-0001

Hi,

Based on our discussion I am sending 2 bug fixes for axi ethernet
driver against your net tree.

Thanks,
Michal

Changes in v2:
- Separate bug fixes from features and cleanups

Michal Simek (2):
  net: axienet: Fix compilation error
  net: axienet: Fix compilation warnings

 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--
1.8.2.3


--=_mimegpg-monstr-desktop-8689-1392275443-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlL8b/MACgkQykllyylKDCHyCACgjqv47KMKIfebYTiCVTRVOC9q
SN8AniECpoRBPXSvMRsqjkwM4TBevyTp
=pEsV
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-8689-1392275443-0001--
