Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbaDWNPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:15:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57462 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751861AbaDWNPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:15:04 -0400
Date: Wed, 23 Apr 2014 15:10:08 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, devicetree@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>, andriy.shevchenko@intel.com,
        linux-kernel@vger.kernel.org, zhuzhenhua@allwinnertech.com,
        shuge@allwinnertech.com, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH v5 7/7] ARM: sun6i: dt: Add A31 DMA controller to DTSI
Message-ID: <20140423131008.GQ24905@lukather>
References: <1394723659-4995-1-git-send-email-maxime.ripard@free-electrons.com>
 <1394723659-4995-8-git-send-email-maxime.ripard@free-electrons.com>
 <201404231435.03920.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FmdPcZLZZW6lDAYm"
Content-Disposition: inline
In-Reply-To: <201404231435.03920.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FmdPcZLZZW6lDAYm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 23, 2014 at 02:35:03PM +0200, Arnd Bergmann wrote:
> On Thursday 13 March 2014, Maxime Ripard wrote:
> > Now that we have a DMA driver, we can add the DMA bindings in the DTSI =
for the
> > controller and the devices supported that can use DMA.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>=20
> Acked-by: Arnd Bergmann <arnd@arndb.de>
>=20
> But why does this patch have to wait for the driver to get merged?

I wanted to make sure that my bindings were ok, and at least reviewed
by someone, but I guess it's done now.

Just applied it.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--FmdPcZLZZW6lDAYm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTV7uwAAoJEBx+YmzsjxAgzDUP/2HNoM1zbu27X+uPIH1nBFOz
pwolbeWkpcULq1yGMx+mTh0tt8wQWXWK1PlRzR3zW1AkQOmaLgvYLUR/sQQafQMK
HmEhudiOreFktV/+qb4g1wsWCTXzpgfuDDj7j7Q55iycVhfRhscsJMb6K5EEgat/
K5209taRjZ+NxLwpGLuRONSumBKOt1AX8H2XRUxqWRYJTAJEnpZvOaPH1y4ZvP+w
E5WProhQ9+gybrxG+kU9CYU/JcujqMAiSLzQZ25SNcMGPBewDkyRTVR2qgik1v/k
9UeS+NJ3vcqYM28DHbri3F9BTTMn6Qc2h4gxRKx4K4GXmPD2YgQCGr0UGorA8kUp
oeOIcCVT4PoUtJ0BjEC7325CP8vGHHZUuPOqYPMlONO3loQhMTvfffg5aOe9kjia
04EO/JTLvhNxrwl+w/Ur+5ihRddCDJK9bybAH4HOnLO6JDsIx2XChEoZVPyGyZDH
Eh3wwCPjNX27dhZo9jsCiXYDNNbP/Tq+Y88sCLwU+YpSXS6HUtz4GxXCC2cbYB0G
9+zuo/TisumEXjFCe5ZjMjVQKcMs0ftnc+d4n4OFNbd0vyXyHwifUNWrnhoujbo0
KHPeLc9LZOvwUj1KHqyKVASI232XChWucwS0F5GA08zTg7HEIAR2/J8KGmuRwQMz
ifUC8fig8uq9gSIF/w2U
=O/3f
-----END PGP SIGNATURE-----

--FmdPcZLZZW6lDAYm--
