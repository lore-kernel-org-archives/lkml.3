Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab3FXOKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 10:10:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47795 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750900Ab3FXOKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 10:10:31 -0400
Message-ID: <1372083021.21189.19.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH] misc/bmp085: Enable building as a module
From: Ben Hutchings <ben@decadent.org.uk>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Eric Andersson <eric.andersson@unixphere.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 24 Jun 2013 15:10:21 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-HhHxsBAW9HjZ8q6Qkpme"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HhHxsBAW9HjZ8q6Qkpme
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Commit 985087dbcb02 'misc: add support for bmp18x chips to the bmp085
driver' changed the BMP085 config symbol to a boolean.  I see no
reason why the shared code cannot be built as a module, so change it
back to tristate.

Cc: Eric Andersson <eric.andersson@unixphere.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/misc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index c002d86..7a68184 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -451,7 +451,7 @@ config ARM_CHARLCD
 	  still useful.
=20
 config BMP085
-	bool
+	tristate
 	depends on SYSFS
=20
 config BMP085_I2C


--=-HhHxsBAW9HjZ8q6Qkpme
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUchTTee/yOyVhhEJAQpO0RAAi0gXAoDN89exofx8xg2XQ7Y0p1YKD+pu
zybOexLt8g6+wf7T2SYRfcDuk5cvwZhrGVGVOFnPmObgLIbxWpcpmP9VTA42xZ8r
OoTggfVlMYfTo9WO4EeVHhJzorGOr6Js8Gx8WREBocujaRD2KjlUxleB935925dl
c5yGjDLIqpP0asb9ED95rL6qoKB31rkkPFi8EqyXLZ/W8vSZ3x2MoS681V5hDJlW
3xKtSLZiTxoiVoNxYfMcp7WgUQ6mN2abfJdc/stTskMgAaO7W/UYypm2WwHJmeX5
8No7rFbzddAu3Q0a3O+hNCMmeF8xZRFcqsoS4q/htEZOTZri9BByjOB/8AdZmVfH
Apvqac9ybc91jLOhxsKYu8+W4bbUg2YE0yTzUc5I2/qFfcSO+pwMXKVOC4t+QBWR
71NhPs0SHy9jUbBOgH84aPMWltSWszwUNg+8goilyDV1D59MICkm6aMdkgbSUiuG
u57uUd4T8SYfNA/qXoF4mGfnC8H3Q6mzye+EUBjnaeHqJ8qvqjMRK/s66WmNg2bN
cZ/cIuP+TwUU7jfQp6tyeTCV032Y/YnsqD80T1uj40kkNcROzShepOkRwWSjMDD8
UAzv5JIdsM6A1LaRERJ9vEcohcn/EQuW9iXFHUlEl7CspIGkcPXrobdpj5+OrEVh
PKTN7ri+wGk=
=GD0a
-----END PGP SIGNATURE-----

--=-HhHxsBAW9HjZ8q6Qkpme--
