Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbaI3VWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:22:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45134 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaI3VWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:22:06 -0400
Date: Tue, 30 Sep 2014 16:22:04 -0500
From: Felipe Balbi <balbi@ti.com>
To: Michael Welling <mwelling@ieee.org>
CC: Felipe Balbi <balbi@ti.com>, Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <jic23@kernel.org>, <linux-iio@vger.kernel.org>,
        <pmeerw@pmeerw.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] iio: light: add support for TI's opt3001 light
 sensor
Message-ID: <20140930212204.GC13806@saruman>
Reply-To: <balbi@ti.com>
References: <20140923140924.GA28592@saruman>
 <20140924143610.GA17997@saruman>
 <20140925221619.GA10644@saruman>
 <20140927041959.GA28445@saruman>
 <20140929140227.GD32403@saruman>
 <20140929183856.GA11871@sysresccd>
 <20140929185325.GA1939@saruman>
 <20140929223833.GA13111@sysresccd>
 <20140929224638.GA21681@saruman>
 <20140929234159.GB13111@sysresccd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S1BNGpv0yoYahz37"
Content-Disposition: inline
In-Reply-To: <20140929234159.GB13111@sysresccd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--S1BNGpv0yoYahz37
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 29, 2014 at 06:41:59PM -0500, Michael Welling wrote:
> On Mon, Sep 29, 2014 at 05:46:38PM -0500, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Mon, Sep 29, 2014 at 05:38:33PM -0500, Michael Welling wrote:
> > > > > > Alright, this is already ridiculous. Andrew, if I resend the pa=
tch can
> > > > > > you apply it since maintainer has been ignoring this thread any=
way ?
> > > > > >=20
> > > > >=20
> > > > > Do you reall think this is the best way to approach this?
> > > >=20
> > > > when maintainer doesn't respond for weeks, yeah! Sure it is.
> > > >=20
> > > > > Perhaps it would be better to explain what each field of the
> > > > > configuration register does and then we can move on.
> > > >=20
> > > > perhaps Jonathan could tell me exactly what he wants because I can't
> > > > handle back-and-forth anymore. Specially when he complains about st=
uff
> > > > he asked me to modify himself.
> > > >
> > > > > In particular the OPT3001_CONFIGURATION_L field needs to be expla=
ined
> > > > > such that the ABI can be properly applied.
> > > > >=20
> > > > > Looking at the docs for the Windows demo program the field is ass=
ociated
> > > > > with a latch configuration. What does this bit field actually do?
> > >=20
> > > Still no technical information. Without all the facts how can you exp=
ect
> > > him to tell you what he wants?
> >=20
> > yeah, because clearly he doesn't know himself, right ?
>=20
> Could you explain how it works to me then?

checking how much of the docs I can expose now, gimme a couple days.

--=20
balbi

--S1BNGpv0yoYahz37
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUKx78AAoJEIaOsuA1yqRE17MQAI2TscC+5VNFaR724sxvKChx
3/Zsegh5m/+ZgHe+S9XkQl+OqxTiNgpRByITfioryWKv/EFZSlNKzx2FMotEzbvE
+o+GROToIJ/YokVfzcHUTS0S2y1+wdeGFG93dEaDbSA+EyJBQ+lmtsuyT0PGfgUq
zS7PYbt4zzSiwMKi/YJN8iLVuW4KKV/jIR7D4Btctw/T5AQobfjsoxzAUT9PGT9Z
HuJyZZce8kfDYoQgG4oRlY9S30AQsB8xTgST7f6mn3vPclFWkc7IB/dvKHhKCr3Y
ib6FsvIaYjzR/sYsnuFdvoVOnRi/suP10iRXNVxPgf18WwTw46Dq3SSd7stVsNhs
GohwrzdhnPySXRPrj31zGOhPgRouzvw54b3mNlR+B6vuERNb5/YQJUQ/EdhUrfhV
tjlSLdkGrV7MagR0715UB7gi30qmJsevt/xYS00vXIpttJkB8gnDWY+bn4Cz9IxC
FJtf1LWSLj6uX2dN8FQvhR5jCG9pmcW0Ka5+px+Z5GDLMWrCv8qBZS2ggg2ZMNua
CCukJUcXv+dNG70EGqWPsMK2X6hsNhQpF4PN2M+1FWiZuZVT6axgPJ3ujibi+Tcz
zBWNzSuvgs3BlCPpmzWWAUpYpmb0U6LFw9K8rnOV8lP1H0NcYEOfaTffrA2NtI4U
diKSXe+SHVXFmYs6VXNL
=hlyP
-----END PGP SIGNATURE-----

--S1BNGpv0yoYahz37--
