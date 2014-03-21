Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964925AbaCUGMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 02:12:20 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:62383 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbaCUGMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 02:12:19 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: microblaze-uclinux@itee.uq.edu.au,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH v2] MAINTAINERS: microblaze: Use LKML as mailing list
Date: Fri, 21 Mar 2014 07:12:11 +0100
Message-Id: <74820135ca159475c5369977a4843b2b1101d597.1395382312.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-6741-1395382331-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-6741-1395382331-0001

microblaze-uclinux mailing list is almost dead and
it is just causing troubles for non subscribers which are
getting email about waiting for moderator.
Approval never happens. Move it to LKML.

Reported-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

Changes in v2:
 - LKML is default mailing list, remove mailing list line
   from Microblaze fragment

 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b3fdb0f..f6fe453 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5702,7 +5702,6 @@ F:	fs/imgdafs/

 MICROBLAZE ARCHITECTURE
 M:	Michal Simek <monstr@monstr.eu>
-L:	microblaze-uclinux@itee.uq.edu.au (moderated for non-subscribers)
 W:	http://www.monstr.eu/fdt/
 T:	git git://git.monstr.eu/linux-2.6-microblaze.git
 S:	Supported
--
1.8.2.3


--=_mimegpg-monstr-desktop-6741-1395382331-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlMr2DsACgkQykllyylKDCFBvwCdHVInG1o2bRfLaOqzq/2OTwtj
MGkAnRK2CiGOty58M/i5Hh9EJLHfeTn3
=rdGB
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-6741-1395382331-0001--
