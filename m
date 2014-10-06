Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaJFMkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 08:40:23 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47411 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbaJFMkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 08:40:18 -0400
Date: Mon, 6 Oct 2014 14:40:15 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-pwm@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Yao <mark.yao@rock-chips.com>
Subject: Re: [PATCH v7 10/11] ARM: at91/dt: add LCD panel description to
 sama5d3xdm.dtsi
Message-ID: <20141006124014.GD26833@ulmo>
References: <1412175188-28278-1-git-send-email-boris.brezillon@free-electrons.com>
 <1412175188-28278-11-git-send-email-boris.brezillon@free-electrons.com>
 <20141006110115.GH25202@ulmo>
 <20141006142538.76d2df29@bbrezillon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uxuisgdDHaNETlh8"
Content-Disposition: inline
In-Reply-To: <20141006142538.76d2df29@bbrezillon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uxuisgdDHaNETlh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 06, 2014 at 02:25:38PM +0200, Boris Brezillon wrote:
> On Mon, 6 Oct 2014 13:01:16 +0200 Thierry Reding <thierry.reding@gmail.co=
m> wrote:
> > On Wed, Oct 01, 2014 at 04:53:07PM +0200, Boris Brezillon wrote:
> > [...]
> > > diff --git a/arch/arm/boot/dts/sama5d3xdm.dtsi b/arch/arm/boot/dts/sa=
ma5d3xdm.dtsi
[...]
> > > +		backlight =3D <&backlight>;
> > > +		power-supply =3D <&panel_reg>;
> > > +		#address-cells =3D <1>;
> > > +		#size-cells =3D <0>;
> > > +		status =3D "disabled";
> > > +
> > > +		port@0 {
> > > +			#address-cells =3D <1>;
> > > +			#size-cells =3D <0>;
> > > +
> > > +			panel_input: endpoint@0 {
> > > +				reg =3D <0>;
> > > +				remote-endpoint =3D <&hlcdc_panel_output>;
> > > +			};
> > >  		};
> >=20
> > There's no support for OF graphs in simple-panel, so this is unused,
> > isn't it?
>=20
> Actually I use it in my atmel_hlcdc_ouput implementation to figure out
> the link between a panel and a device connected on the RGB/DPI bus.=20

That's kind of weird and one of the reasons why I can't make myself like
the OF graph bindings. It requires drivers for one device to reach into
the device tree node of some other device and look for content. Or put
another way, a DT node for a panel that works on one platform doesn't
work on another because the display controller needs additional DT
content that isn't required by the original binding for the panel.

Thierry

--uxuisgdDHaNETlh8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUMo2uAAoJEN0jrNd/PrOhev0QAIy54IWOvWGVgP6gPbnSqfNd
ERgjVfwptdHhpAK+IV3zBgK2lk/M9E3GMAgcqU33ThNgnKxfCDHngJndQpOf0g8w
GZFs1AqMvMOdF84Qf/phJ8i4ZuG2DdS8wdP6QG1ru13iwYcU3NsWfgU1ByVs92rG
hlo6OBXZ2HCXPlY+uC1nee56A2NHzxVumg2nr2QWwxItSTm15KNVRCobu3RqIQrg
s1w3dvoFGlSC+pSyuz3pkrIwL/7o3yQ+OA47mUadVWa6N7FX4RolPKEzaV1sMm+E
Y6LlDCxPl00hSxMek5WSf4zD/EhrkRIntfwUvUH7QzIUsB32Zd0xnGbCAqfUAPFd
PU1UC2XXi3wOdGo//fXwlFWL1xTlyzY/EpqANaApLFiAm17NNV7syjsn/i33oo1M
YXy9S9WIWhLX5vq4/5N1483x6ZQxAKrSML3aeHJUIiNlWXeHsJjsxT8R8r0EjXhU
j1eoIpXtC6sF9o71PhmMfLonGX3PZRaw0fhWF8hyuvrqZqzwm578cNlNKj3wME+L
aUpCcZvWgStmLm1S8gNsM3obiqpjnPnHQd2oe1n3utxjvv7rvsm/f/uvtpAj3Gtj
aIlKPK+5qB8DoU7rS4BNbcRy5JQ5HMcFsOEpimlSOLVwPhmPXybLc6gW0QMXsQV2
jL/jZlBd6Grnod1n/uog
=hwdk
-----END PGP SIGNATURE-----

--uxuisgdDHaNETlh8--
