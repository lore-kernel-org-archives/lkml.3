Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab3BLD7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 22:59:23 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59252 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab3BLD7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 22:59:21 -0500
Date: Tue, 12 Feb 2013 14:59:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        "Peter Ujfalusi" <peter.ujfalusi@ti.com>
Subject: linux-next: manual merge of the arm-soc tree with the usb tree
Message-Id: <20130212145919.e1f7ba0e693b69f40f5724dd@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__12_Feb_2013_14_59_19_+1100_ECmjO9gGfK061g2/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Feb_2013_14_59_19_+1100_ECmjO9gGfK061g2/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-omap2/board-zoom-peripherals.c between commit 51482be9dcfd
("ARM: OMAP: USB: Add phy binding information") from the usb tree and
commit c5913935657f ("ARM: OMAP: zoom: Audio support via the common
omap-twl4030 machine driver") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/board-zoom-peripherals.c
index dc5498b,0745bd9..0000000
--- a/arch/arm/mach-omap2/board-zoom-peripherals.c
+++ b/arch/arm/mach-omap2/board-zoom-peripherals.c
@@@ -20,7 -20,7 +20,8 @@@
  #include <linux/wl12xx.h>
  #include <linux/mmc/host.h>
  #include <linux/platform_data/gpio-omap.h>
+ #include <linux/platform_data/omap-twl4030.h>
 +#include <linux/usb/phy.h>
 =20
  #include <asm/mach-types.h>
  #include <asm/mach/arch.h>

--Signature=_Tue__12_Feb_2013_14_59_19_+1100_ECmjO9gGfK061g2/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRGb4XAAoJEECxmPOUX5FE+X4QAKCRj8Xqe697UtvZwRNrEUlm
qKOQ74u/tkLknt82IkFaQrqhCQiaDBV4NN4DyuvL8dQjdy2KR9ab0huwnkjs3kcx
whh+L8ZDvGvvhlmpMJx/eMQDQEiT++Z2UhnzshJS3TOxqeUkiiI6aXVfmToSLIsn
0tvUfnVOdw0d+MlJM3BgP6xSBUaZKYw6b9Zphw7VrPZNPXmG7b0KvS1gz4hPOXGI
wP7J/4jfq5uUM/gVu/HrDcJe6MnHK84kGcPmBlxpqU+bjj+xYh22Ko96vi4R3RLw
zGNH26OtZmlyzcLP/ntD1m3mWduo2sc5qiqXe2Z+2yeC7hulywZn9DzU4hrytiwZ
2omCqycQ1N8XlJsyii0PVTPA955cDWvKjx//76PhYYI8zZEsfNcMf9nrc9aLeRys
vzjLUWa1TEJTefs3kMQKNbiQXqxiaBpWbyxTho+vaa5Qt0uvIj/3Zpx9D1NdqjL7
HM6a35YqGQmusGKFjT7Z2YcAiwaa+rSrbgE9G/qc8QuxWrl0AxYiTx8cYTIENc8n
MqKk8nyY1je1zMsWf3tZG5bYf4eKKzVZRHU36FTadXiV7fJWVtVw9sjRIEE29QGC
7wirZUSvUu6Z2BWiwzfxR6//52MJRLFm6fJ0rJAi7WIH1XEeLfN2IDWHfoGGTJ5Z
9Zi4ioX8FMpgxCNRmTx7
=s7U7
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Feb_2013_14_59_19_+1100_ECmjO9gGfK061g2/--
