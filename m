Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbaBTIKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:10:17 -0500
Received: from top.free-electrons.com ([176.31.233.9]:55240 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752514AbaBTIKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:10:15 -0500
Date: Thu, 20 Feb 2014 09:09:55 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "b.brezillon@overkiz.com" <b.brezillon@overkiz.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv2 1/8] ARM: at91: Add at91sam9rl DT SoC support
Message-ID: <20140220080955.GA3142@lukather>
References: <1392823951-26053-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1392823951-26053-2-git-send-email-alexandre.belloni@free-electrons.com>
 <20140219170020.GA25079@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AX2clmtSw6ieHBMM"
Content-Disposition: inline
In-Reply-To: <20140219170020.GA25079@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AX2clmtSw6ieHBMM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Wed, Feb 19, 2014 at 05:00:20PM +0000, Mark Rutland wrote:
> > +                       adc0: adc@fffd0000 {
> > +                               compatible =3D "atmel,at91sam9260-adc";
> > +                               reg =3D <0xfffd0000 0x100>;
> > +                               interrupts =3D <20 IRQ_TYPE_LEVEL_HIGH =
0>;
> > +                               atmel,adc-use-external-triggers;
> > +                               atmel,adc-channels-used =3D <0xf>;
> > +                               atmel,adc-vref =3D <3300>;
> > +                               atmel,adc-num-channels =3D <4>;
> > +                               atmel,adc-startup-time =3D <15>;
> > +                               atmel,adc-channel-base =3D <0x30>;
> > +                               atmel,adc-drdy-mask =3D <0x10000>;
> > +                               atmel,adc-status-register =3D <0x1c>;
> > +                               atmel,adc-trigger-register =3D <0x04>;
> > +                               atmel,adc-res =3D <8 10>;
> > +                               atmel,adc-res-names =3D "lowres", "high=
res";
> > +                               atmel,adc-use-res =3D "highres";
> > +
> > +                               trigger@0 {
> > +                                       trigger-name =3D "timer-counter=
-0";
> > +                                       trigger-value =3D <0x1>;
> > +                               };
>=20
> A unit-address should go with a reg value. Either this needs a reg and
> the parent node needs #address-cells and #size-cells, or the
> unit-address should go, and the names made unique through other means.

What do you suggest to make the name unique then?

The ePAPR is pretty clear that the above is the way to go, so I'm
unclear on what you have in mind here.

Plus, I haven't seen anywhere that reg was actually mandatory.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--AX2clmtSw6ieHBMM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTBbhTAAoJEBx+YmzsjxAgd7EQAK+Z1StU2REP26cFmJzUeSO2
CwC3wP6lVl1+T8Sqwfl8E+wxyeCGYny3tUo/NUbJXb+0CP+r3CDU9ShrjP1N+WL7
EcdMR20T5FXicpUZGDFR2omqsFGNMx1MUozgVTi7q0G7AidqUqaOJaoZLrsy/AIW
Z7CfNQ7a9q/GI18yWU57HEBBilrw+XswKWkuIq6A92NIzfutffzcjGTbQZuPqelX
LHOsSohEXpj/P4Rl0BfyhWmStnoMxf9jiEwS3Gk9kgXPBIDBB4y/y/dVY0bKVcsq
Nrch103hL8ZkDUFLhfHZUcsC5vx3mZ8XKCIJPTrqJsu9T347i10r2lf7vODkbO3U
jrn/2rEUl3035Y/wu69f5BDKw575+sJ9fPV496/hm5gXIuJAHjo/0O8VkY82Ne/5
+p82Hpbr7ow5k1KxRA26BO4N6Tqo1Z9cS4yAZYDVkJ90u4TIKj3m4kczxpfiEUqP
6YEQsKaBJYRM44zqwoLkY0J+NRbnQRhyl0VPVuly51r7M5AfEk75wMxnRnLmi3tj
mzqYwp8TbTeMKqPflZ/Kz8YlKQI7AUnS5Ijq0DUiw3QZEOjTTeKIFE88EUVxfpbJ
NXJgfgK4AeMDjCtDf9ZPuxImDKfyhxSMp1POQTj5dvNMAjMw7AgH8iCZxbOtyhLd
Ps2XATPTEcIW33sUh+9b
=MzOr
-----END PGP SIGNATURE-----

--AX2clmtSw6ieHBMM--
