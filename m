Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab3KWJhX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 04:37:23 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:53573 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3KWJhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 04:37:18 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [PATCH v2 2/3] hwrng: OMAP3 ROM Random Number Generator support
Date: Sat, 23 Nov 2013 10:37:13 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.2; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>, Matt Mackall <mpm@selenic.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1379534757-20870-1-git-send-email-pali.rohar@gmail.com> <201311182251.35704@pali> <20131119021409.GA2820@gondor.apana.org.au>
In-Reply-To: <20131119021409.GA2820@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1990570.ofrVAdtyRY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201311231037.13908@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1990570.ofrVAdtyRY
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 19 November 2013 03:14:09 Herbert Xu wrote:
> On Mon, Nov 18, 2013 at 10:51:30PM +0100, Pali Roh=C3=A1r wrote:
> > On Wednesday 16 October 2013 14:57:34 Herbert Xu wrote:
> > > On Tue, Oct 08, 2013 at 12:04:09PM -0700, Tony Lindgren=20
wrote:
> > > > * Pali Roh=C3=A1r <pali.rohar@gmail.com> [130920 06:33]:
> > > > > This driver provides kernel-side support for the
> > > > > Random Number Generator hardware found on OMAP34xx
> > > > > processors.
> > > > >=20
> > > > > This driver comes from Maemo 2.6.28 kernel and was
> > > > > tested on Nokia RX-51. It is platform device because
> > > > > it needs board specific function for smc calls.
> > > >=20
> > > > This one is should be merged via the hw_random patches
> > > > seprately:
> > > >=20
> > > > Acked-by: Tony Lindgren <tony@atomide.com>
> > >=20
> > > Patch applied.  Thanks!
> >=20
> > Hello, I still do not see this patch (2/3) in linus tree.
> > But patch 1/3 and 3/3 are already merged. So is there any
> > problem?
>=20
> 2/3 is still in my tree so when Linus pulls it it'll be there.
>=20
> Cheers,

Now 3.13-rc1 is out [1], but your tree was not merged. Can you=20
try to ping Linus what happened?

[1] - https://lkml.org/lkml/2013/11/22/439

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1990570.ofrVAdtyRY
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKQd0kACgkQi/DJPQPkQ1LySgCeKyyCfkkapr+eCrx6VsmOk37t
EAsAoLAqrIRgaulp2fpyvAMCCPJVHKbI
=f4ly
-----END PGP SIGNATURE-----

--nextPart1990570.ofrVAdtyRY--
