Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbaFMQX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 12:23:59 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39823 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbaFMQX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 12:23:57 -0400
Date: Fri, 13 Jun 2014 11:23:13 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Benoit Cousson <bcousson@baylibre.com>,
        Paul Walmsley <paul@pwsan.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Add support for am437x StarterKit
Message-ID: <20140613162313.GG8319@saruman.home>
Reply-To: <balbi@ti.com>
References: <1402676147-3711-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IuJpT0rwbUevm2bB"
Content-Disposition: inline
In-Reply-To: <1402676147-3711-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IuJpT0rwbUevm2bB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Fixing Benoit's address

On Fri, Jun 13, 2014 at 11:15:45AM -0500, Felipe Balbi wrote:
> Hi,
>=20
> The following two patches (one of which is a resend from a patch which ha=
s been
> pending since May 19th!) enable AM437x StarterKit to boot in mainline.
>=20
> Patches have been tested on top of 27a4e439fe5cd92b70137ae237c7aa6888c07b=
5a
> (next-20140610). With these we even have X with I3 running on this board,=
 with
> audio, touchscreen, networking, blinky leds and others.
>=20
> Felipe Balbi (1):
>   arm: dts: add support for AM437x StarterKit
>=20
> Sathya Prakash M R (1):
>   ARM: AM43xx: hwmod: add DSS hwmod data
>=20
>  .../devicetree/bindings/arm/omap/omap.txt          |   3 +
>  arch/arm/boot/dts/Makefile                         |   1 +
>  arch/arm/boot/dts/am437x-sk-evm.dts                | 539 +++++++++++++++=
++++++
>  arch/arm/mach-omap2/omap_hwmod_43xx_data.c         |  98 ++++
>  arch/arm/mach-omap2/prcm43xx.h                     |   1 +
>  5 files changed, 642 insertions(+)
>  create mode 100644 arch/arm/boot/dts/am437x-sk-evm.dts
>=20
> --=20
> 2.0.0.rc1
>=20

--=20
balbi

--IuJpT0rwbUevm2bB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTmyVxAAoJEIaOsuA1yqRE4+cP/RBgWHtT9Q5V2Cs4GZ535HY3
efQooIoOsDpK/Y7YtmGPfeDksZDcs530AwJdRH9J2BfECmC2n75rYOIS3HH78nDq
/4blCkJJo2AkJY7/4yEWlx0oOxHE6gPk7KK9Oc0kXvtfAQ5WVgvk0GOLlFkLD6Lu
c3MMRl15Rw8uLoO1DOGVGgEHSYiXLA/HH1qjWGNbg807fAG7HWrCgFeaG/IUWpZ/
aoeS+w9aaqQ3Li+us5ykEGh+js+ocUpSORJMQ02+YTSXyAn88H6s+WtJXiF4FW67
u42IfarmVUx/Dq4GfH+AFJ1RFbGowI8bTnMRT/7XMlCZJTQHQchqsKIyd+NxUT0Y
TNctwtwpn5/OzQj3iKnw/6DHfCjBrcOrGiJ+2php1uRurdeRs0pDWM+XIL7xF1xI
W1xPPHRkr884SeSryIJ9LnmkzCNFYUGG65sQnptOTr52C898L19JUQ3L2qL9cxHJ
JY+ro6T92FL6O6WaxBVSGwlX6uBFAdo1Ss0399MVPPeD10HkzHvHx8DaEznGSM6a
arX73ykV8V5bOPHPgzkFvf6kVbYT+jwyCLP3rgkFFkToTwS1vgFsziBoh2GnnzJ4
29XTMR2T35MJGs4bZdcQAeMGSTRHdoMOzNpEC8mHbPSWuvKQvmdBEJUjDKQ9xHE0
B/v1ZyACAN6C49YfYQ+A
=CvOM
-----END PGP SIGNATURE-----

--IuJpT0rwbUevm2bB--
