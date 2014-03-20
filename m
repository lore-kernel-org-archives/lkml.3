Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877AbaCTPKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:10:14 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:58736 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588AbaCTPKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:10:12 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: microblaze-uclinux@itee.uq.edu.au,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] MAINTAINERS: microblaze: Use LKML as mailing list
Date: Thu, 20 Mar 2014 16:09:58 +0100
Message-Id: <4f187754982226c3456c0a9b86050ab4e470aa98.1395328176.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-4854-1395328198-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-4854-1395328198-0001

microblaze-uclinux mailing list is almost dead and
it is just causing troubles for non subscribers which are
getting email about waiting for moderator.
Approval never happens. Move it to LKML.

Reported-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b3fdb0f..1a22c62 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5702,7 +5702,7 @@ F:	fs/imgdafs/

 MICROBLAZE ARCHITECTURE
 M:	Michal Simek <monstr@monstr.eu>
-L:	microblaze-uclinux@itee.uq.edu.au (moderated for non-subscribers)
+L:	linux-kernel@vger.kernel.org
 W:	http://www.monstr.eu/fdt/
 T:	git git://git.monstr.eu/linux-2.6-microblaze.git
 S:	Supported
--
1.8.2.3


--=_mimegpg-monstr-desktop-4854-1395328198-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlMrBMYACgkQykllyylKDCHhWACfSbepagdeizzPfeSM3JzOWmbN
JgMAn37+SHfLfgdY7WPo7BOlYwoCw7zr
=5CVp
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-4854-1395328198-0001--
