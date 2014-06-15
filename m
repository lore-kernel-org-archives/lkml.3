Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaFOQed (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 12:34:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34711 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690AbaFOQeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 12:34:23 -0400
Message-ID: <1402850052.7797.29.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH] firmware: Update information in linux.git about adding
 firmware
From: Ben Hutchings <ben@decadent.org.uk>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-firmware@kernel.org, Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Sun, 15 Jun 2014 17:34:12 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-XCxbpGAifIN76+n0m1U0"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XCxbpGAifIN76+n0m1U0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Kyle McMartin recently joined the linux-firmware maintainers, and we now
have an alias <linux-firmware@kernel.org> which reaches all of us.
Include that instead of the individual addresses.

Add some further recommendations that were already included in the
README in linux-firmware.git added by Xose Vazquez Perez
<xose.vazquez@gmail.com>.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 firmware/README.AddingFirmware | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/firmware/README.AddingFirmware b/firmware/README.AddingFirmwar=
e
index ea78c3a..bcb5f46 100644
--- a/firmware/README.AddingFirmware
+++ b/firmware/README.AddingFirmware
@@ -21,15 +21,25 @@ been permitted to redistribute under separate cover.
=20
 To submit firmware to that repository, please send either a git binary
 diff or preferably a git pull request to:
-      David Woodhouse <dwmw2@infradead.org>
-      Ben Hutchings <ben@decadent.org.uk>
+      linux-firmware@kernel.org
+and also cc: to related mailing lists.
=20
 Your commit should include an update to the WHENCE file clearly
 identifying the licence under which the firmware is available, and
 that it is redistributable. If the licence is long and involved, it's
 permitted to include it in a separate file and refer to it from the
 WHENCE file.
+And if it were possible, a changelog of the firmware itself.
=20
 Ideally, your commit should contain a Signed-Off-By: from someone
 authoritative on the licensing of the firmware in question (i.e. from
 within the company that owns the code).
+
+
+WARNING:
+=3D=3D=3D=3D=3D=3D=3D
+
+Don't send any "CONFIDENTIALITY STATEMENT" in your e-mail, patch or
+request. Otherwise your firmware _will never be accepted_.
+
+Maintainers are really busy, so don't expect a prompt reply.

--=20
Ben Hutchings
Tomorrow will be cancelled due to lack of interest.

--=-XCxbpGAifIN76+n0m1U0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU53LCee/yOyVhhEJAQq61BAAy+fDUU2v6PFKWBDmBbRBtm1AJJ7yvW0D
cD/pRgTnOCB1sfV4T0bDyQMgWEmCes8OoN0CiXhvlwehbOFTq04ERnB6jHCvEh6F
icYZnK+Fz/hPXMn6qbvImy+EXzskEyaVKYyl9Tu/5Z0HPIOwmFLNXfYN6eQRfOj+
dhLNG5BIesD0v1BydgicOlbJoCuVBL3X0BBKL9CIbKlOgwxuLaO8IRkngOzuY+7P
CyhJfxDZS9XvuFLRTW0lyL9bDIWA4o0tSkaOxLM8u3VLm1bgKX3oETRIob2y+Jbi
rVRh2QZ921ZzgSKhVwZmNpN88P2CrEycbKdHC4XST0Gfvq1fir0fIpQK4S9bt04A
vmUMH60oqx/429mmyU2YYSFNaKEnH6ItMjQWIXMYaJAFEkklY9RxVV3HKSImkrMt
8ltO4XBcdyx2n5r/GGLWloyjkci7w3d6KVR1XFA49ZAtyHpT71lj7k/VUb0lmHNM
zGqw8ppakyrJmsngMWJGX5WD1LXz0rdboCPkOPr7LiGFCSCyZsJ09La6SHlM0TXj
YPRym/pg4amcXxLkkXO/+HSGnyILlcL/+z0T9179iMgb6vFdKwO3ck+TkAmQZ834
TuZ+KVuIIvF1/loqSNnNqFI7rcxoXYjOHUVvlWvV4wvXjayf3LJE2Wi01hO1P1sV
vlULSLL3RvE=
=EaUQ
-----END PGP SIGNATURE-----

--=-XCxbpGAifIN76+n0m1U0--
