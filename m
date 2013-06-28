Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab3F1MTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 08:19:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49535 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab3F1MTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 08:19:40 -0400
Date: Fri, 28 Jun 2013 15:18:59 +0300
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
CC: <balbi@ti.com>, <mturquette@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-arm@vger.kernel.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] Documentation: dt: bindings: TI WiLink modules
Message-ID: <20130628121859.GP11297@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372149330-24335-1-git-send-email-coelho@ti.com>
 <20130628093848.GA2139@e106331-lin.cambridge.arm.com>
 <1372413215.21065.41.camel@cumari.coelho.fi>
 <20130628102145.GB2139@e106331-lin.cambridge.arm.com>
 <1372415514.21065.50.camel@cumari.coelho.fi>
 <1372418531.21065.53.camel@cumari.coelho.fi>
 <20130628114129.GO11297@arwen.pp.htv.fi>
 <1372421632.21065.60.camel@cumari.coelho.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e2bLSPRkEYxxSNev"
Content-Disposition: inline
In-Reply-To: <1372421632.21065.60.camel@cumari.coelho.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e2bLSPRkEYxxSNev
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 28, 2013 at 03:13:52PM +0300, Luciano Coelho wrote:
> On Fri, 2013-06-28 at 14:41 +0300, Felipe Balbi wrote:
> > On Fri, Jun 28, 2013 at 02:22:11PM +0300, Luciano Coelho wrote:
> > > On Fri, 2013-06-28 at 13:31 +0300, Luciano Coelho wrote:
> > > > (fixed Mike's address)
> > > >=20
> > > > On Fri, 2013-06-28 at 11:21 +0100, Mark Rutland wrote:
> > > > > On Fri, Jun 28, 2013 at 10:53:35AM +0100, Luciano Coelho wrote:
> > > > > > On Fri, 2013-06-28 at 10:38 +0100, Mark Rutland wrote:
> > > > > > > On Tue, Jun 25, 2013 at 09:35:30AM +0100, Luciano Coelho wrot=
e:
> > > > > > > > +Optional properties:
> > > > > > > > +--------------------
> > > > > > > > +
> > > > > > > > +- refclock: the internal WLAN reference clock frequency (r=
equired for
> > > > > > > > +  WiLink6 and WiLink7; not used for WiLink8).  Must be one=
 of the
> > > > > > > > +  following:
> > > > > > > > +	0 =3D 19.2 MHz
> > > > > > > > +	1 =3D 26.0 MHz
> > > > > > > > +	2 =3D 38.4 MHz
> > > > > > > > +	3 =3D 52.0 MHz
> > > > > > > > +	4 =3D 38.4 MHz, XTAL
> > > > > > > > +	5 =3D 26.0 MHz, XTAL
> > > > > > > > +
> > > > > > > > +- tcxoclock: the internal WLAN TCXO clock frequency (requi=
red for
> > > > > > > > +  WiLink7 not used for WiLink6 and WiLink8).  Must be one =
of the
> > > > > > > > +  following:
> > > > > > > > +	0 =3D 19.200 MHz
> > > > > > > > +	1 =3D 26.000 MHz
> > > > > > > > +	2 =3D 38.400 MHz
> > > > > > > > +	3 =3D 52.000 MHz
> > > > > > > > +	4 =3D 16.368 MHz
> > > > > > > > +	5 =3D 32.736 MHz
> > > > > > > > +	6 =3D 16.800 MHz
> > > > > > > > +	7 =3D 33.600 MHz
> > > > > > >=20
> > > > > > > This looks suspiciously like what we have the common clock bi=
ndings for:
> > > > > > >=20
> > > > > > > refclk {
> > > > > > > 	compatible =3D "fixed-clock";
> > > > > > > 	#clock-cells =3D <0>;
> > > > > > > 	clock-frequency =3D <19200000>;
> > > > > > > }
> > > > > > >=20
> > > > > > > wilink {
> > > > > > > 	compatible =3D "ti,wilink7";
> > > > > > > 	interrupt-parent =3D <&some_interrupt_controller>;
> > > > > > > 	interrupts =3D <0 1 1>;
> > > > > > > 	clocks =3D <&refclk>, <&refclk>;
> > > > > > > 	clock-names =3D "refclk", "txoclk";
> > > > > > > };
> > > > > > >=20
> > > > > > > Could you not use them?
> > > > > >=20
> > > > > > Hmmm... this actually does look good.  But these are internal c=
locks in
> > > > > > the modules, they cannot be accessed from outside.  Does it mak=
e sense
> > > > > > to register them with the clock framework?
> > > > >=20
> > > > > Given we already have a common way of describing clocks, I think =
it
> > > > > makes sense to use it -- people already understand the common bin=
dings,
> > > > > and it's less code to add add to the kernel. I don't think the fa=
ct
> > > > > these clocks are internal should prevent us from describing them =
as we
> > > > > would an external clock.
> > > >=20
> > > > Yes, I agree with you.  Thanks for the suggestion! I think it will =
look
> > > > much better.  And now that I dug a bit more into the code, I can see
> > > > that there are only structs being populated, so there shouldn't be =
any
> > > > other side-effects.
> > >=20
> > > Hmmm, one thing that escaped me.  Besides the frequency, I also need a
> > > boolean that tells if the clock is XTAL or not.  I can't figure out h=
ow
> > > to pass this if I use the generic clock framework.  Any suggestions?
> >=20
> > Could you use clock-output-names for that ?
> >=20
> > XTAL clock:
> >=20
> > refclk {
> > 	compatible =3D "fixed-clock";
> > 	#clock cells =3D <0>;
> > 	clock-frequency =3D <19200000>;
> > 	clock-output-names =3D "xtal";
> > };
> >=20
> > non-XTAL clock:
> >=20
> > refclk {
> > 	compatible =3D "fixed-clock";
> > 	#clock cells =3D <0>;
> > 	clock-frequency =3D <19200000>;
> > 	clock-output-names =3D "osc"; /* any better name ? */
> > };
>=20
> This starts looking a bit hacky.  Using the output name as a flag is not
> very pretty.
>=20
> I think it would be better to have a separate flag for it in the wlan
> node.  Like an optional "refclock-xtal" boolean or something.  The
> downside of this is that we would be adding information about the clock
> details in the wilink node. :(
>=20
> OTOH, we could add a flag to the generic clock binding? A new optional
> boolean that tells whether the clock is XTAL or not:
>=20
> refclk {
> 	compatible =3D "fixed-clock";
> 	#clock cells =3D <0>;
> 	clock-frequency =3D <19200000>;
> 	clock-xtal;
> };
>=20
> Do you think that would make sense?

sure, that looks alright to me. Surely there are other devices out there
who want to know if the clock comes from a crystal or not ?!?

cheers

--=20
balbi

--e2bLSPRkEYxxSNev
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRzX8zAAoJEIaOsuA1yqREsWsP/iiJyFZ9PJ3JykDgPSb6Ih5D
RQ2zf/mXGunKREm78Sym+8iz/1vsdwcxXt7YM7V+JrMU0DNrMc9m5Z93w/iKbe3y
gz57n+C7hPeL7Ji+fu1f3ugLEPaJcYBraHtRIyY6SA7EsKGoc9+4i2jYa8VvOKs1
nBeJXVcrWwnqsyWg7MSQ+zHUZdt9B/FnXqcEo1cPlD3ilG1hMxnDPomhqnedv2gZ
Tk/w3xoKhMKFnmpTlsVg3hYTS/xMAcAr1hBO2nCucLV9EjpsmcmxC6JS7I1SdxpU
vxyviRd3F/a1oMzs/jpwess2B73hqrfsEDseMRiYGolNxHD4BBV70ARwuoJO8/kk
3EryxTORyX1XAI1tuNsov9FkWNRCwobP1j6sosr7t/RypZ5rQcUIIUhwoMLvUWNo
giYdDU939aUngYMxiI6Yzaodj9IPwHq7xHV76c7yYZmcFvTpT4SPGALv/FHFg+h2
I/W03AXqETT0S0RWxf50cvDbOFu0sO6gvdJWPZ6BNpTQaBShMUBYut6gUhbSCdIF
jUhPIhEsb0s1TFxQz9ce+Dj0wve4f6+6rhQXRfjztBhE90sgvf0fIvjhSoOWCiak
FapSNpbSnKg1u89TNJMedPtZI5FEVyHQ8V/ZVG6HAtbLRuUwzMy5R+NrITnwFgxP
fkGiI0Nr0KJkWwNu1tF8
=ZHWz
-----END PGP SIGNATURE-----

--e2bLSPRkEYxxSNev--
