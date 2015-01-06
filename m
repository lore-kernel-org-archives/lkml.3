Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbbAFNNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:13:00 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:52353 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248AbbAFNM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:12:58 -0500
Date: Tue, 6 Jan 2015 09:13:03 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Javi Merino <javi.merino@arm.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Punit Agrawal <Punit.Agrawal@arm.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH v6 9/9] of: thermal: Introduce sustainable power for
 a thermal zone
Message-ID: <20150106131301.GC4661@developer>
References: <1417806260-9264-1-git-send-email-javi.merino@arm.com>
 <1417806260-9264-10-git-send-email-javi.merino@arm.com>
 <20150102155256.GD10683@developer>
 <20150106094215.GB2885@e104805>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qjNfmADvan18RZcF"
Content-Disposition: inline
In-Reply-To: <20150106094215.GB2885@e104805>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qjNfmADvan18RZcF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 06, 2015 at 09:42:15AM +0000, Javi Merino wrote:
> On Fri, Jan 02, 2015 at 03:53:00PM +0000, Eduardo Valentin wrote:
> > On Fri, Dec 05, 2014 at 07:04:20PM +0000, Javi Merino wrote:
> > > From: Punit Agrawal <punit.agrawal@arm.com>
> > >=20
> > > Introduce an optional property called, sustainable-power, which
> > > represents the power (in mW) which the thermal zone can safely
> > > dissipate.
> > >=20
> > > If provided the property is parsed and associated with the thermal
> > > zone via the thermal zone parameters.
> > >=20
> > > Cc: Zhang Rui <rui.zhang@intel.com>
> > > Cc: Eduardo Valentin <edubezval@gmail.com>
> > > Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> > > ---
> > >  Documentation/devicetree/bindings/thermal/thermal.txt | 4 ++++
> > >  drivers/thermal/of-thermal.c                          | 4 ++++
> > >  2 files changed, 8 insertions(+)
> > >=20
> > > diff --git a/Documentation/devicetree/bindings/thermal/thermal.txt b/=
Documentation/devicetree/bindings/thermal/thermal.txt
> > > index f5db6b72a36f..c6eb9a8d2aed 100644
> > > --- a/Documentation/devicetree/bindings/thermal/thermal.txt
> > > +++ b/Documentation/devicetree/bindings/thermal/thermal.txt
> > > @@ -167,6 +167,10 @@ Optional property:
> > >  			by means of sensor ID. Additional coefficients are
> > >  			interpreted as constant offset.
> > > =20
> > > +- sustainable-power:	An estimate of the sustainable power (in mW) th=
at the
> > > +  Type: unsigned	thermal zone can dissipate.
> > > +  Size: one cell
> > > +
> >=20
> > Please, include examples of this property, as you mentioned in the
> > governor documentation.
>=20
> I'd rather put a pointer to the documentation instead of repeating the
> same thing here.  What do you think?

The point is that device tree and Linux are supposed to be independent
entities. I would prefer if you could extend the explanation of what is
'sustainable power' in the above entry. On top of that, pick one of the
existing examples and extend it to include the 'sustainable-power' property,
with a comment explaining it, for instance.


--qjNfmADvan18RZcF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUq99UAAoJEMLUO4d9pOJWhloH/1+5RteprDWJ9gFG3LqM+OXL
YPocC7EO/Yko6BJo7vShkV4beWbMDEXgvlxqEiFLGYybKlRQNZ6+eZvJdZWEXBln
ye+I8nS/t72Y78LPSIjq72f/LoWLSGk7Jt0yXYDpNO3Zl/LjmcAEBru09nHfKT+g
VtNR8d5/M67gdqih7TI7bamQoMDs5YTy/MyhqZvWy0ZmKPfOrwgDFXVWJGdsy5YG
C9cE2q4+aC5kDw2GEhqkyAZFZZpoUw6+niMbrYJqAMQpVlwP0do4EOGimeMYAiii
/adrXRlUqB3/DANW1YiFMyrH2tW2FAXyqH8t1hS1QCFMSTqncileMRANcnrSPWE=
=iPpV
-----END PGP SIGNATURE-----

--qjNfmADvan18RZcF--
