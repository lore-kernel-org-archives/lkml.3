Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbaJ2Cvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 22:51:39 -0400
Received: from ozlabs.org ([103.22.144.67]:55953 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784AbaJ2Cvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 22:51:38 -0400
Date: Wed, 29 Oct 2014 13:51:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the pm tree
Message-ID: <20141029135129.40193e14@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/oCZQcAxsfj5yT8yhtmJLJms"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/oCZQcAxsfj5yT8yhtmJLJms
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

After merging the pm tree, today's linux-next build (arm
multi_v7_defconfig) produced this warning:

drivers/of/base.c: In function 'of_property_read_string_array':
drivers/of/base.c:1472:1: warning: control reaches end of non-void function=
 [-Wreturn-type]
 }
 ^

Introduced by commit ef23586751cd ("Driver core: Unified device
properties interface for platform firmware").  Please don't ignore new
warnings ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/oCZQcAxsfj5yT8yhtmJLJms
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUUFY2AAoJEMDTa8Ir7ZwVLDQQAI+RGrLZagdgAUotqLn1onEB
E18Nq0hqlCCsqzmXrYFk0/nmClZlgGeWXoLB1giheyh62f2G/JfeVFyGpBPmFJyc
oMJ+gR55V24fYvPXVzWSJfewkRtf6TMGpxOcDdVLgNuMcpH0xc+p7ANI6MElR8Gp
YfGyj3ffONptw5JpIlXOoUo11lrM9x9hhCF+jDKy2ZcRqewjXWjTrRcSh8Raf+fx
avWOlRDF7MkWLq6LIwRjV6yQemX0vP49ZtjD5MaZEVFYZ2uzTeempq2y8MgsupAT
jsQmj7GoWSTBoRq1K/eJySnhxA4m0Jr8hpORxNipyX7TUY2E5k6oudLrWWbMoP5Z
Z+zEGQYCDrjkoDpJ+GjPQGGbSA1MpdlPNm4kB5Qq9+C99rCgzelLYUPh3EOGzrpB
C6APm2piJdpW7Agct8c0Z7tW4k0TqaDo8vgEr1GYUlEM52qYA4OQhI0bH+AkmnWu
2jq4jV176jAu9RkRrBVElAvHTTRsqfK8HJTuUDeJ5S0JGHLvV0iLKK15iIGWZUlk
NC2akfvSbpSDhFqgCgycWAEbZtRuYv1UdMvGMh6GThxgoydg7fuaSBIjrtKHythd
QMGgmheiPD/gkZ7X3dKp39PNHy0wRbU6U0KERh0q5WnDJ7WJ03Y39U3vEt2tT0v+
jyy7us19UetDAf7ysona
=jSV4
-----END PGP SIGNATURE-----

--Sig_/oCZQcAxsfj5yT8yhtmJLJms--
