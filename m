Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab3FQHQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 03:16:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49103 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab3FQHQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 03:16:24 -0400
Date: Mon, 17 Jun 2013 17:16:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Simon Horman <horms@verge.net.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jingchang Lu <b35083@freescale.com>, Greg KH <greg@kroah.com>,
        Ulrich Hecht <ulrich.hecht@gmail.com>
Subject: linux-next: manual merge of the renesas tree with the tty tree
Message-Id: <20130617171622.450bae1a5319f54004a18e2d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Jun_2013_17_16_22_+1000_Xa70K/Ac/ne9=b/U"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Jun_2013_17_16_22_+1000_Xa70K/Ac/ne9=b/U
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Simon,

Today's linux-next merge of the renesas tree got a conflict in
include/uapi/linux/serial_core.h between commit c9e2e946fb0b ("tty:
serial: add Freescale lpuart driver support") from the tty tree and
commit 24610a30600b ("serial: sh-sci: HSCIF support") from the renesas
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/uapi/linux/serial_core.h
index c8eaeb5,26eee07..0000000
--- a/include/uapi/linux/serial_core.h
+++ b/include/uapi/linux/serial_core.h
@@@ -226,7 -226,7 +226,10 @@@
  /* Rocketport EXPRESS/INFINITY */
  #define PORT_RP2	102
 =20
 +/* Freescale lpuart */
 +#define PORT_LPUART	103
 +
+ /* SH-SCI */
 -#define PORT_HSCIF	103
++#define PORT_HSCIF	104
+=20
  #endif /* _UAPILINUX_SERIAL_CORE_H */

--Signature=_Mon__17_Jun_2013_17_16_22_+1000_Xa70K/Ac/ne9=b/U
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRvrfGAAoJEECxmPOUX5FEayQQAJ0JEsBuXGCQLIW5U3hvvfOc
CG6Zu4Va3Jp9xEzaGS0tggDODs/BeD9DCP5N0zTp9VU9lC5pBao/mFqpptnrK2us
vXMMhjmXZHuZLOZtrI5lIzYh8V021HbQ2xvOwbgjVXtnTuNVdbXNmBeRXNNIfwSg
I1a+gV7/knjRLmBpYSzbHcb9NWdKKgjUKPU9hq6Kr5935dM0CiHw1ek93UfXcGOX
45rH0ubYEO6seGGNJZaCVfRPQHMmjrYoY5OI8Qjj1QKChILDX1HqGllc48WWiWmc
NgtHkYZWxwHG+SHBlcePQMZ/cWBOIUkAdHjEpUfgonTNFpzvPpS2lYybFBI64mmz
xjtxWeDpQuewfD7H27l1MEuLjRerFpI33t3YPlIw6cTGPN6VIXT37ZaPrdNPQ3MP
dTXjXNVhP3LBSrhQDhK+NHea+PeItzqj28tfapZL840PbP0hiPlTKYkSX1as0LMK
yqpBoZSISO8BzX5oUeKBmDIdSG60w8ZIQuGDFe9VEmrWWoDzd5IZpQkfNswWHaWx
G6pya1acvpZqEI3Gb5jdnTYuLoT2Nd35Ujt11Fu7tB3bktRUBeAOT8i6x1LHGuxw
jtohvTNTXqWvvJFEaAivOUVnfFShIUJwt1KMShxX7110btZjCPGWgeDIYsEV7/NG
RI780yR00OMos1thj2Gd
=jxwe
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Jun_2013_17_16_22_+1000_Xa70K/Ac/ne9=b/U--
