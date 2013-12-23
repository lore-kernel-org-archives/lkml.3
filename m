Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869Ab3LWUhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 15:37:32 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:53112 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab3LWUha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 15:37:30 -0500
Date: Mon, 23 Dec 2013 14:36:02 -0600
From: Felipe Balbi <balbi@ti.com>
To: Matt Porter <mporter@linaro.org>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>, Tomasz Figa <t.figa@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dinh Nguyen <dinh.linux@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH v8 9/9] ARM: dts: add usb udc support to bcm281xx
Message-ID: <20131223203602.GC15101@saruman.home>
Reply-To: <balbi@ti.com>
References: <1387462990-12039-1-git-send-email-mporter@linaro.org>
 <1387462990-12039-10-git-send-email-mporter@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TYecfFk8j8mZq+dy"
Content-Disposition: inline
In-Reply-To: <1387462990-12039-10-git-send-email-mporter@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TYecfFk8j8mZq+dy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 19, 2013 at 09:23:10AM -0500, Matt Porter wrote:
> Adds USB OTG/PHY and clock support to BCM281xx and enables
> UDC support on the bcm11351-brt and bcm28155-ap boards.
>=20
> Signed-off-by: Matt Porter <mporter@linaro.org>
> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> Reviewed-by: Tim Kryger <tim.kryger@linaro.org>

doesn't apply to my tree:

checking file arch/arm/boot/dts/bcm11351-brt.dts
checking file arch/arm/boot/dts/bcm11351.dtsi
Hunk #1 FAILED at 243.
1 out of 1 hunk FAILED
checking file arch/arm/boot/dts/bcm28155-ap.dts

I will skip this patch from my tree, all others are now in my
testing/next branch after fixing dependency ARM-only for now.

Send me a patch removing ARCH dependency for v3.15, since this driver
can be used in other arches too.

cheers

--=20
balbi

--TYecfFk8j8mZq+dy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSuJ6yAAoJEIaOsuA1yqRElJUP/i7GVyFrlkcDYkiYO8++VYV5
RDQ8Vz3OT7sLc0L2B0OvRGbLrWeVvNogPwfRddlqtrs9Q3nWrovaWuFONaUrYrKm
2XQnLINdSFzMlfH/VH7Zu0Xsy2emwZ+xCrCNSUYc2iv11CGMWMF3ATFJ0rkguUes
VftXXVzqDai724Pongf1mPZ5yVWjoPUSxN/Y0SYPNTxtlPoOlvxgKRBEsyWosV6h
C7WL9ZGL6u85t/bFRTRgaAn6Uokp1XUn2otUokcQTWXwnL/lsfgnmqDgDEqUtUKK
FcyEu2/gQXYhQ2hNphxAXBj2zg87I39ze1wibhEDAHXDfTs2TSl1/Mv9wBhOLdcn
awlHTiSB2PnVOsk04dTh4Vmfr5srOAkyHhqiwI9MREB2jpqvcq05XHDAQ9jUtla1
BJLi0xq+6fI+mc2Oag5Omo+Cy15t8Sk3z3C1N/Sz0STY6j/gLPqC2kPKQeUgZ+NQ
VNjmUG8qkEEvxj6nJmeRt5LztZ9e/k6xyco2irIIujEZumAcIhttstkpqn+/bqHG
Je8X4aEVnAkNRULew6Whulp50xWRWI0cOu+hyTmjEAPXlRcUZNXiTubKi1i1gx1/
AvuTi0bauah2skuDki5XZ5fPg+lWtbQR3ZNuSLXaiM3cEbARJ2GIoK9GZDUAvvzM
9QvZKJhvjWhgOj9pT8DP
=JJkD
-----END PGP SIGNATURE-----

--TYecfFk8j8mZq+dy--
