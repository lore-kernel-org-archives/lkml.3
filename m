Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbaILDSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 23:18:10 -0400
Received: from ozlabs.org ([103.22.144.67]:49799 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753767AbaILDSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 23:18:08 -0400
Date: Fri, 12 Sep 2014 13:17:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@linaro.org>
Subject: linux-next: build failure after merge of the slave-dma tree
Message-ID: <20140912131755.7a181cc6@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/TqzrKwxGKEKo+95zvA_8e9W"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/TqzrKwxGKEKo+95zvA_8e9W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

After merging the slave-dma tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:


drivers/spi/spi-pxa2xx-pci.c:70:3: error: unknown field 'max_clk_rate' spec=
ified in initializer
   .max_clk_rate =3D 50000000,
   ^

Caused by commit bfe607a528ba ("spi/pxa2xx-pci: Add support for Intel
Braswell").

I have used the slave-dma tree from next-20140911 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/TqzrKwxGKEKo+95zvA_8e9W
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUEmXtAAoJEMDTa8Ir7ZwVuEsP/R8/XQWxiFRp1G1EL4+eVuGw
GSmr3itsLyzY/sJ4o2HUWfOFpxuSlpL9jcDSLbUTynrnGS4NQv1FghYJsrURB3CB
/ysLdkqC6ShDrY409OU74t3k6m6oQQfUB7vlG4aMxb6Y7CaDstaQ+pXXbJOle7V3
ue1asC7HdDPyerXNOamGqBlfD9U7CHZ3da8ibaxo/rKApf0T+P4I3KOLZgGAo/xB
6Zo9+O/n0xgtl8jyjeMFLX1sgJSTnBIuTj1T0708JsXR0LyqIFgZLa7pSnQOxZzu
WDCkOdBIGDsKVgaTHe8SYO07+9v9sDE0oUt+Oym/vBUF4Yt6GHTv0mE/o+OVJtM7
Cf8DPrJ3l3zbiPheS/rK1hUHs9Re5RisI07EIqRiPwhNjfqhVigrFVshqkmSfFRq
RoMOEkL8NcFb/GoT+uw7zC2JHKEPNv/a2E1thb7VDgAZTJ7IKIVbVDYKPVRruMYY
6v/0ESHBL6bwToH2YpOOaLjX0VoA71uFfzn7DAkY1O4/MJoX1+XJp+w1+SbZxdYz
2xBBLYneV31nV9IFu6Eq5+I0HgOTT3Yc8BiPPJ3WGmlt2IyNU715Ls/d8QUU84EJ
k4IcDecRHFFLQS6v/v888OaHkbApXELz1kd+aSKdTwJ8ld0cnuN+8m1EsrmYBrXJ
4hq6odPEsF38aTM6xjuc
=KQsD
-----END PGP SIGNATURE-----

--Sig_/TqzrKwxGKEKo+95zvA_8e9W--
