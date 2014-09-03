Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935763AbaICXWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:22:11 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48990 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934455AbaICXWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 19:22:05 -0400
Date: Thu, 4 Sep 2014 00:21:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Peter Foley <pefoley2@pefoley.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Message-ID: <20140903232149.GG29327@sirena.org.uk>
References: <1397743910-18391-1-git-send-email-pefoley2@pefoley.com>
 <53FB9DA0.7000301@infradead.org>
 <CAOFdcFP4b0YFMuUFKm4=FoAGbCObf4u=W0UUPwf-ju_TNvuJaA@mail.gmail.com>
 <540651B3.8030400@infradead.org>
 <20140902232906.GG29327@sirena.org.uk>
 <CAOFdcFPmHH9z+6Kuc5Agu6PDC9+t+420Cb5R6VuHp+MebG+2LQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VvwS7Fyc3fvERiQe"
Content-Disposition: inline
In-Reply-To: <CAOFdcFPmHH9z+6Kuc5Agu6PDC9+t+420Cb5R6VuHp+MebG+2LQ@mail.gmail.com>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] Documentation: use subdir-y to avoid unnecessary
 built-in.o files
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VvwS7Fyc3fvERiQe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 03, 2014 at 07:08:38PM -0400, Peter Foley wrote:
> On Tue, Sep 2, 2014 at 7:29 PM, Mark Brown <broonie@kernel.org> wrote:
> > Your tree either wasn't in the control file that Stephen handed off or
> > got eaten by one off his scripts for some reason.  I've tried adding it
> > back, we'll see if that works tomorrow.

> The patches still seem to be missing from the 20140903 -next tree,
> unfortunately.

The update is not happening because:

| git am ../quilt/rd-docs/001-docum-use-subdiry-avoid-builtin.patch
| Patch format detection failed.

I guess either something changed in the way Randy is generating his
patches or I'm using a different version of git which doesn't like
them - looking at te patch files I'm not *entirely* surprised they=20
have trouble.

--VvwS7Fyc3fvERiQe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUB6KKAAoJELSic+t+oim9HrEP/j1hv0BAmWSvGOEx8t6JWZpE
OCpqH1DCllz/y2k6h2BZJwdfGKDCWc5NnVVmSE8dLPVXHsqaNMA8OjSod8uarJ6S
pM+PGaYaK9X5SlTeEaqew793iNKl4n6vj+KyxVobDqnmVEguIGd4vQxZ4n9QjFqW
L1K9B7IUwyIaLZ0ayE9cPBxSTX7IbyXN0YcHNVxKu/FAJZt8U3Ns9y6I/WPAqV0P
wDtr3TCIDrWwt9CfC+/rqlmlKAQ6iPuqo8sPn+kiaOg9dbTf6iibLPIEhDod96Am
lwtKQELP6rGhPoRuHjxa4mEGTERu47aWHTv6WYUIiTR0he/b5DLQ3QdccNfFsrR+
HoytfYQDT79j3bG/GVOJOAXxWaMXnJn6QQuPsfiJVkAejIxqYZZpRCrkaYI3RaXK
WTd3QbFp8oqDf/+gDmRCzd98jd/ne9iLQFyyKwsJhvANHetAFPZNSKydUm28gQ/+
fycjkTxf26MwMOSzIqyZakMsyzrjHTQ7mK1Mvar0kOIJxFYtSMrNNe8VLoXARIvB
ZuNjfi8F6wM94LqsopVwbKTHJlfgPWOJHPlTJib+25fXUbN6btXvYsqrLT/BdM4d
zyDLfAmR2LuTlar5Xf+pml7KAVQadt5R/UR/fTFiR6yKj1TjVz8S17xV12Kf6l0m
OVKnHepSUXYKAmDHKuCp
=w5+c
-----END PGP SIGNATURE-----

--VvwS7Fyc3fvERiQe--
