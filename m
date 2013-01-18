Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab3ARRyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 12:54:23 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39453 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab3ARRyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 12:54:21 -0500
Date: Fri, 18 Jan 2013 19:54:08 +0200
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Luciano Coelho <coelho@ti.com>, "Cousson, Benoit" <b-cousson@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, <balbi@ti.com>,
        <linux-omap@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [[PATCH v2]] OMAP: omap4-panda: add WiLink shared transport
 power functions
Message-ID: <20130118175408.GC1035@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <50F7CA82.4050509@ti.com>
 <20130117100510.GI10814@arwen.pp.htv.fi>
 <20130117100919.GJ10814@arwen.pp.htv.fi>
 <1358418917.6252.31.camel@cumari.coelho.fi>
 <50F7D535.6030205@ti.com>
 <20130117173131.GL14149@atomide.com>
 <1358445456.6252.64.camel@cumari.coelho.fi>
 <20130117231608.GP14149@atomide.com>
 <1358499533.6252.80.camel@cumari.coelho.fi>
 <20130118173635.GE15361@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V0207lvV8h4k8FAm"
Content-Disposition: inline
In-Reply-To: <20130118173635.GE15361@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--V0207lvV8h4k8FAm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jan 18, 2013 at 09:36:35AM -0800, Tony Lindgren wrote:
> * Luciano Coelho <coelho@ti.com> [130118 01:03]:
> > On Thu, 2013-01-17 at 15:16 -0800, Tony Lindgren wrote:
> > > * Luciano Coelho <coelho@ti.com> [130117 10:04]:
> > > > But this patch is pretty small and simple, so why not include it to=
 at
> > > > least fix the breakage in 3.7 and 3.8? Whether you take it or not n=
ow
> > > > won't make any difference in the 5k LOC in these kernel versions.
> > >=20
> > > Well we are planning to drop the non-DT support for omap4 as soon as =
it's
> > > usable with DT. For omap4 we are only carrying SDP and panda support =
to
> > > make this transition easier. The only bindings missing AFAIK are wl12=
xx and
> > > USB.
> >=20
> > In my view this is a regression and it should be fixed with as simple a
> > patch as possible.  The alternative to my solution is to revert the
> > patch that removed the enable/disable from the ti-st driver *and* fix
> > u-boot, because if it doesn't mux the UART2 pins properly (and it
> > doesn't) the shared transport still won't work.
>=20
> Fixing the muxing here makes sense naturally as we cannot do that in the =
driver
> until we've flipped things over to use DT.
>=20
> But I don't think we should fix the driver regression by adding more plat=
form
> callbacks as we are getting rid of them anyways.

it's not adding more callbacks, solely implementing them as it should
have been done on Pavan's original patch.

> > > What's your estimate of having minimal wl12xx WLAN DT binding availab=
le?
> >=20
> > To tell you the truth, I haven't even started looking into DT for wl12xx
> > myself.  So I have no idea when it will be ready.  Benoit has been
> > looking into it, but I don't know how far he is.
>=20
> If it's going to take long we should just init the platform data for
> it temporarily even in the DT boot case until the binding is available.

which will boil down to having those platform_data callbacks to have it
at least functional. How will Luca test DT conversion if ti-st isn't
even functional ?

--=20
balbi

--V0207lvV8h4k8FAm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ+YxAAAoJEIaOsuA1yqREC6kP/RR3po7xTPhLRCcdvNhk4Jpj
xhXVQFOy+E/sqZ0u9hM4eFbreCe/ZXfwXfnG4lYoifiyyVH5VA/O+AnmAGRCO0nK
EeTgxif8glYpkgCbADLDl6EM2V8z2q/SNIUjW7hB1D43VJOizPXenI9TfaPeCuG9
G9Jwb+vQrdK41pq9yPTBU5ef1fmf3sThQtF0fsuzkzYh8bpC93Mi0GrfXRtn6oN8
QxXvU2viE+bSLv7mAEd1NoasJ54MsZoAYCBJPX21N5oU1RThW+7p8aP8lPF+Zifh
w6IPcv+pb7NV9DQLnf+CaIEb0CR85SyXpuyCJ2zcr4zWjz4yDOx/CgzoixGzDcma
seqJZsC4uvdjPQ9/xaFpHsiy7tDckqEVAQvvTWQDK6fFWHebGOhtXQJdeT+YcWHf
Qru6woTVujOubsN1DyG3xf/mMI0+aZTAjc6tMI1BTV7LXALsNAYcHlmACJrx/gCZ
B6Kz8RG/GFr0P8DlfgyXXKg7sNZheGpdtB68jlgPUepH9TPVSlYUknif/x1m3S/g
9JI0/ca+40uTIYBAdReiYKdsMMuciLMxx9IsUK4ZxzM2OjNYXj8otlzBVF4mWjIA
XtuP+dijQA2ePS9pOSCvDj1ATEM1EUttKMzFue8hV6Hir7jusyeMyibFjV6C4wAQ
eUD9JprQel88tP7bS/Ek
=CCb5
-----END PGP SIGNATURE-----

--V0207lvV8h4k8FAm--
