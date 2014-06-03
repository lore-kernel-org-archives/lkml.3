Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933811AbaFCUDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:03:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52350 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933011AbaFCUDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:03:46 -0400
Message-ID: <1401826083.2412.17.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH linux-firmware] README: Update the submission address to
 linux-firmware@kernel.org
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, linux-firmware@kernel.org
Date: Tue, 03 Jun 2014 21:08:03 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-4ET3mth3tUCg0UcvyrIc"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4ET3mth3tUCg0UcvyrIc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This new alias will reach all maintainers.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
I've just cleared out my patch queue, applied this change and pushed.
If I get any later submissions with only individual addresses, I'll
request re-submission to linux-firmware@kernel.org

Ben.

 README | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/README b/README
index 0ed6d79..f2ed92e 100644
--- a/README
+++ b/README
@@ -13,8 +13,7 @@ been permitted to redistribute under separate cover.
=20
 To submit firmware to this repository, please send either a git binary
 diff or preferably a git pull request to:
-      David Woodhouse <dwmw2@infradead.org>
-      Ben Hutchings <ben@decadent.org.uk>
+      linux-firmware@kernel.org
 and also cc: to related mailing lists.
=20
 Your commit should include an update to the WHENCE file clearly

--=20
Ben Hutchings
If more than one person is responsible for a bug, no one is at fault.

--=-4ET3mth3tUCg0UcvyrIc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUAU44rKOe/yOyVhhEJAQrN9g//UVfZ6ecCaM/5bPetv3KiXYjlTlqhsYhC
fP4v8734lmKHqnIlfrDzRE1LISvoVKI2NijknYkfmpFGyG9mk+AcgXygxI04AKvV
zQwyNjoMGXO7SH02MYNPBch2zl8F4YTmG7B+zSRAx7Y/PLCcelB0AYp0MFBg+hhJ
nYZfwZfR5kVRf7v4y2LhDoCsNRH32PC6CPKwnJSZfiDdhAW483VcBLxhfJmuuG+p
4+gVR5cbR64WWVF8rJFyU/0jyPlmBOfrhV42r+Cl+eauu0mVSH7PMFuZmzroSYqG
oHcUJNUXKJBhctBO2cpLKUYpzDB4K4piY676ZP59UEopuYHz7G7kOaZhTkKCNu6N
KbVF02bhVv88jxv+MvP1ybeT+6kDKUM4O59WaBfQJ6Hrp2BOnJ2POTrgIItqMk7f
k/Y8yfdCYLSqR2+Pta1S8SKNbtqX7XK4oxNpUIhqcZmujaT6hyfc40V4+TneHK4L
i3GVoOOGEWDl7YYWqP9zRnPFpFxrCQm7xvo3M2qllt6/BQQ+GykjtLsWEARMrHPQ
bSHJu5It1GWrRXvnXzZDj7gBPNX7YmFh6NiIzA8JLHGr0TzFWuP9xlQRg8G3+Ygw
Y1X6hAXzTBY8hRxw0niFF7zW7GjtXmAZMuS9Pt30Z/KQZDZ35d9L8W77EetsSnST
NorudZYeZGg=
=fsW3
-----END PGP SIGNATURE-----

--=-4ET3mth3tUCg0UcvyrIc--
