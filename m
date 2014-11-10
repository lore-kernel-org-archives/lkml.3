Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320AbaKJFxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 00:53:24 -0500
Received: from ozlabs.org ([103.22.144.67]:46875 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaKJFxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 00:53:23 -0500
Date: Mon, 10 Nov 2014 16:53:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pratik Patel <pratikp@codeaurora.org>
Subject: linux-next: manual merge of the char-misc tree with the staging
 tree
Message-ID: <20141110165316.5c122b47@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ysQ3bEgt8xBvWAbgw7wU+ip"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ysQ3bEgt8xBvWAbgw7wU+ip
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the char-misc tree got a conflict in
drivers/Makefile between commit 777783e0abae ("staging: android:
binder: move to the "real" part of the kernel") from the staging tree and
commit a06ae8609b3d ("coresight: add CoreSight core layer framework")
from the char-misc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/Makefile
index 60d19820a4d4,628b512b625b..000000000000
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@@ -161,4 -161,4 +161,5 @@@ obj-$(CONFIG_POWERCAP)		+=3D powercap
  obj-$(CONFIG_MCB)		+=3D mcb/
  obj-$(CONFIG_RAS)		+=3D ras/
  obj-$(CONFIG_THUNDERBOLT)	+=3D thunderbolt/
 +obj-$(CONFIG_ANDROID)		+=3D android/
+ obj-$(CONFIG_CORESIGHT)		+=3D coresight/

--Sig_/ysQ3bEgt8xBvWAbgw7wU+ip
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYFLQAAoJEMDTa8Ir7ZwVgwsP/j6DriI03MGWtcs039ikD5Ql
eHtUrEa8QoohHxApzTOZVZt7/0htoRtvHYCnMx85aD723HcLlvZFHSed4mpQPb/9
gNotSrNg6LzvKX14Sbt0h9Ymxw19F7dYNUAQaljcWJnflePMMUgLOwU8lVUpXKct
tTngR4hMab5Q839EheS9SVKHm3Ag6TeQKfQ3WCBQ5Ra1gpizVe77deKPfF4JLDgf
hy+5saF3/56ZVnVb2Et0DSD0UWYBCGC30fd7b8IYbFSRCIaeb1gDAnhjqLkJQt4P
Kbbk/NBvofmpJIhyuPfjwT4VkrsDHSqecYJVpeXT70z+8OHLVIgariPYJy5fZnmL
YmUDf4lV9yhiPRHT/jivSC1WWzrZo6lTW+2GbSntb6KRAfYNYpYPYKe/dLoQhZbB
+LVlUZQz44nceA/4BPSM7oHCXEiJIw6Qa4UXLCbaSValYKywRPTX/xV1xnZJyO21
3a+G2cO8vc0ij3BvyARk3v3QxaengMxTa6ShHSdlLHAxJw1iwWEFL4fKjhxH8kDB
+vEyMsoCECIc7ttVavy3lOyho4mKCpjxEc1BoaH5dSE4EN7A/p3nIrBGEzn0wAiw
UbEY3/co9mK+tRwPP8gS/PoZvq0dNEQcdGbZ8wYIe6q71m7JUraY5ciyobEc0wsZ
9wGIzhCRzY0pcTnkihEW
=OKGY
-----END PGP SIGNATURE-----

--Sig_/ysQ3bEgt8xBvWAbgw7wU+ip--
