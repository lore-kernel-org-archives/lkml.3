Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbaI2Wq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 18:46:56 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44363 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605AbaI2Wqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 18:46:55 -0400
Date: Mon, 29 Sep 2014 17:46:38 -0500
From: Felipe Balbi <balbi@ti.com>
To: Michael Welling <mwelling@ieee.org>
CC: Felipe Balbi <balbi@ti.com>, Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <jic23@kernel.org>, <linux-iio@vger.kernel.org>,
        <pmeerw@pmeerw.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] iio: light: add support for TI's opt3001 light
 sensor
Message-ID: <20140929224638.GA21681@saruman>
Reply-To: <balbi@ti.com>
References: <20140919162129.GE26946@saruman.home>
 <20140922140914.GC25620@saruman>
 <20140923140924.GA28592@saruman>
 <20140924143610.GA17997@saruman>
 <20140925221619.GA10644@saruman>
 <20140927041959.GA28445@saruman>
 <20140929140227.GD32403@saruman>
 <20140929183856.GA11871@sysresccd>
 <20140929185325.GA1939@saruman>
 <20140929223833.GA13111@sysresccd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <20140929223833.GA13111@sysresccd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 29, 2014 at 05:38:33PM -0500, Michael Welling wrote:
> > > > Alright, this is already ridiculous. Andrew, if I resend the patch =
can
> > > > you apply it since maintainer has been ignoring this thread anyway ?
> > > >=20
> > >=20
> > > Do you reall think this is the best way to approach this?
> >=20
> > when maintainer doesn't respond for weeks, yeah! Sure it is.
> >=20
> > > Perhaps it would be better to explain what each field of the
> > > configuration register does and then we can move on.
> >=20
> > perhaps Jonathan could tell me exactly what he wants because I can't
> > handle back-and-forth anymore. Specially when he complains about stuff
> > he asked me to modify himself.
> >
> > > In particular the OPT3001_CONFIGURATION_L field needs to be explained
> > > such that the ABI can be properly applied.
> > >=20
> > > Looking at the docs for the Windows demo program the field is associa=
ted
> > > with a latch configuration. What does this bit field actually do?
>=20
> Still no technical information. Without all the facts how can you expect
> him to tell you what he wants?

yeah, because clearly he doesn't know himself, right ?

> > > Either have TI release the documentation or add comments to each of t=
he
> > > fields of each of the registers such that we can understand what exac=
tly
> > > they are doing.
> >=20
> > TI will release the documentation when that's all cleared up with Legal.
> > You can't expect it to be any earlier than that.
>=20
> I am a little fuzzy on how the source code can be released when an NDA
> is required to access the datasheet.
>
> Isn't the source code going to be breaking the NDA by releasing informati=
on
> that is in the datasheet?

that's really not my role inside TI, though. I have no degree by any law
school from any country. When I get asked to write a driver, all I do is
request permission to release it, if that says "okay, release it", I
don't go after the Lawyer who decided it was okay to release the driver.

On top of that, what does that has anything to do with anything ? I'm
pretty sure many have released code based off of either simulation or
pre-release HW. Lack of public documentation does not prevent source
code from being released at all.

Try to get documentation for most of SoCs supported under the ARM tree
and you'll see at least 80% of them will require NDA and/or a big
purchase order of many SoCs before you can get documentation.

--=20
balbi

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUKeFOAAoJEIaOsuA1yqRE1IkP/01sAjz6HVvNHk4B91BOfkOF
K0LvNRO9D9gWF5QpQZOZ1/bLutFRS6OelpI3nB04x0W7G/FqccFIw6/wuAppNBXH
1z2gfWkowfhmgGwaHQLvF+lGhW5vVZCjTQun0KXv1ZADD0NlHbPH2RJTLEdKiNLd
mOP7NHViPl28eEbXBL0P5BT/vpCSCYEqPVQ5+PgvGdvyZnlPEgB8PENtURXRalQ9
+Fp1URyAkbJWf7d+w2/ZyN1jR5nzzmFlkCbqiMz+CHiCy30Z8ldGLqwPrOF94BQA
HtEqs+vxdjs0Lj3HYeOYT2KQa2+mbCnKzYmDzunxiXnJi6nGEjd5A6X3IzLmR2g5
NRigaK9vB5grWv8Dl5TXMY2yIqayjz/M0u7i+Hj+7WuIWTI8gS6ya5M8yPMNOjxY
AoKCJKvFqwzL/KGk8z6KYjvimsKcWbgOXalAWAfQjoTNLp6xT+HhoGhcKdjyGQ4k
LfY99MyvCAlU4cPw17gVgjClZireErQtMjF3c+N4u4K0O1K3d2n81BqY5NPwON60
eHFznRYiSTVlUbeS5WB6Dz80+yMdD7h3Be3MO0xXSiZTSWfoBNvuCCHdA/lPq86g
JOfjiHbxJUuTCY56ZgpBLfAXdzkX6fDftWNzMjZ2GVQ144bekjrfaP3r7slvaHMY
oLo6Mknyf6WLZzjj3Rbn
=1VQA
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
