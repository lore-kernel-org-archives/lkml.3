Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbaB1VVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 16:21:42 -0500
Received: from sauhun.de ([89.238.76.85]:59151 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbaB1VVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 16:21:41 -0500
Date: Fri, 28 Feb 2014 22:21:35 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: David Howells <dhowells@redhat.com>
Cc: wolfram@the-dreams.de, khali@linux-fr.org, linux-i2c@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] i2c: Add message transfer tracepoints for SMBUS
Message-ID: <20140228212134.GC2517@katana>
References: <20140218205418.GH18768@katana>
 <20140109214954.25590.73057.stgit@warthog.procyon.org.uk>
 <20140109215002.25590.51609.stgit@warthog.procyon.org.uk>
 <11165.1393507178@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="da4uJneut+ArUgXk"
Content-Disposition: inline
In-Reply-To: <11165.1393507178@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--da4uJneut+ArUgXk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > Also, the I2C tracing has first 'f' then 'a', that should be consistent,
> > too.
>=20
> Flags first or address first?  Do you have a preference (for both)?

I'd say address first, yet no strong preference.

> > Can we have something like this for 'flags'?
>=20
> There's a __print_flags() which should work.  One thing I'm concerned abo=
ut
> there is how do we handle more flags being added - does that count as an =
ABI
> break if the printed format changes?

Not sure, I mean, this is debug output, no?

> SMBus flags are basically the same as I2C flags, right?

Basically, yes.

Thanks,

   Wolfram


--da4uJneut+ArUgXk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTEP3dAAoJEBQN5MwUoCm2n6kP/RTSBe8QE3nBjDQIl5D3Dvsq
3UJRi1j657xk1PzIRwDxlexhKoqamnB/d2D13deOJVM52CCcvGa7XF5B64e2NNwl
DoaiCCGmzLSJAUUaFnnKGC+5LvBLspnSADHHgruRUiXTmITkkmpTIcaDKFkCKbJl
wKpyC/UXv4KAqdjzhVoDkd/+IWAMHrBdf0LfysB8C3b/+34mIMYZa+s8rrsBcpq+
HM4ABbI0s7rtfcf0QSGq34o5DT1IRsKV31+6AoxF+jkGAK+PDRaK5MNZLTLP9jEA
xVAYQn1gKA+79coHcxadD3i+OuHwBp+SKVnILtJSktVJmRfusAJcZ+qDSloMCKrt
st0V0KWOoCOA6TcsKMZo03OT8ONrivMmQaoI883o5VCjpFxxmIOtmy1eVoRRdrUB
gNNDd/xNnaZnW0+ihwmhfMCTJPnC87QuRVs61ABwMV/ekqJWTL9f0N2Wjb1+eFog
bs9Hz4H2d5vk9JWDXglyEU+I7Q57k1CaHaSXnEWwozeY5N7GqSDbJ+KdMf3faIsw
v2/MAhrKGlbXEKGCKfZJC9SOJCaumsbhgqca3p844JBSDkLi7HWTnfXCUqBD1rrV
KMm5gZmOgx2ER0chgrkfTQyzhwOTnLpC0Dep4iosc8bkFLukV0rO+3UbSCnqvCjY
uBogJ8qKXTFhAmLbJZq+
=IYV6
-----END PGP SIGNATURE-----

--da4uJneut+ArUgXk--
