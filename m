Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaG2IUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 04:20:00 -0400
Received: from ozlabs.org ([103.22.144.67]:36940 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbaG2IT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 04:19:58 -0400
Date: Tue, 29 Jul 2014 18:19:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <treding@nvidia.com>
Subject: linux-next: manual merge of the gpio tree with the arm-soc tree
Message-ID: <20140729181949.427a7fb5@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/8jVaTAtv_zGX=9MpMoKYX1v"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/8jVaTAtv_zGX=9MpMoKYX1v
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the gpio tree got a conflict in
arch/arm/mach-tegra/board-paz00.c between commit a0524acc94c9 ("ARM:
tegra: Sort includes alphabetically") from the arm-soc tree and commit
0a6d315827ee ("gpio: split gpiod board registration into machine
header") from the gpio tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-tegra/board-paz00.c
index bb4782a32713,91fd858ced0d..000000000000
--- a/arch/arm/mach-tegra/board-paz00.c
+++ b/arch/arm/mach-tegra/board-paz00.c
@@@ -17,10 -17,9 +17,10 @@@
   *
   */
 =20
- #include <linux/gpio/driver.h>
 -#include <linux/platform_device.h>
+ #include <linux/gpio/machine.h>
 +#include <linux/platform_device.h>
  #include <linux/rfkill-gpio.h>
 +
  #include "board.h"
 =20
  static struct rfkill_gpio_platform_data wifi_rfkill_platform_data =3D {

--Sig_/8jVaTAtv_zGX=9MpMoKYX1v
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT11krAAoJEMDTa8Ir7ZwVKQIP/2pQVsM3P9Y6eCyTaxrc+24H
KW2AyR30PHSpyCUaolfiQmz3RiqAI6Ceq+2oDHkYxNQXFRQF0QMwTcm5zNRy0g8u
B4Y+rA257l7intACU7iMQtPdeP5+s4NBn+RIgKQVrZOZ1FfZTqsaBHlymjSfVX3y
6dXvzk37gJ0KcpzeqE18Ir1Dg3O/269l7GKXGs3b5WUgekpQ8Rs4bnB3EpdYaeYs
wkg0F10dLIx5oeoUnzeEPXy186rNazDg3wxwh1Dsy2HhosUBfMhUqsL5Pp72e71F
lf5yt49qFR4/lZ8RlP6Pdp2mhodSbbCcP6xffzRs2NDsS7ffEcAB6/J++fCxKYRG
7t/RGm+G4f+hFKJzIktaJpvodQWUXthPH+1AwHn3NHfScpk3ZK6dzkgqcAquE+s4
R9f8RON+o7iyI2ssn3zmWgm72yJwdvOThIBQLkeA0jzcKr6MsOn+M8lmThrIuVIf
j8ys9uIJ0iXnjU9YU647o6O86Wv0e+PXTOl4I4XChmMbZTbrtgPJ6cctq/x9yamO
yJS79zeLU9CIFJQvAxVl/WCZh7EvOzsDJRLP4EitbCjwCHVLrT/m5MqPL/LHTMfO
Q2/+xWIwnvMQk5lovimZlzaL7wodWUmRY1sZ8nvIjZaKz3RtXuvM3wVxVu69HltB
/FqoyUUu4dOf7B7smmPW
=R7F3
-----END PGP SIGNATURE-----

--Sig_/8jVaTAtv_zGX=9MpMoKYX1v--
