Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab3G2TeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 15:34:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50439 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab3G2TeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 15:34:08 -0400
Date: Mon, 29 Jul 2013 20:33:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Christian Eggers <ceggers@gmx.de>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Message-ID: <20130729193357.GF9858@sirena.org.uk>
References: <1388690.s58sU4PUYE@p2400>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cDKaHmvCnPt6GUmS"
Content-Disposition: inline
In-Reply-To: <1388690.s58sU4PUYE@p2400>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [resubmit2] [PATCH] spi: spi-davinci: Fix direction in
 dma_map_single()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cDKaHmvCnPt6GUmS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2013 at 08:54:09PM +0200, Christian Eggers wrote:

> The following patch I already sent on 2013-04-18 and 2013-06-06.=20
> Unfortunately it hasn't been committed yet.

I'm not sure where you submitted this to but it doesn't appear to have
been to either me or to the mailing list.  If you want a patch applying
you need to send it to the maintainer as covered in SubmittingPatches.
Google and your current post suggest it went to lkml and the retired
sourceforge list...

As also covered in SubmittingPatches you should also not include things
like this in the body of the commit message, put them after the ---
where they will be stripped automatically by tools like git am.

> Commit 048177ce3b3962852fd34a7e04938959271c7e70 (spi: spi-davinci:=20
> convert to DMA engine API) introduced a regression: dma_map_single()=20
> is called with direction DMA_FROM_DEVICE for rx and for tx.

This doesn't apply automatically since:

> ---
> --- drivers/spi/spi-davinci.c.orig      2013-04-18 20:54:02.728719412 +02=
00
> +++ drivers/spi/spi-davinci.c   2013-04-18 20:54:51.900623956 +0200

you've generated the patch in -p0 format not -p1 format as covered in
SubmittingPatches.  I fixed this up manually but please do follow the
process in SubmittingPatches, it makes life easier.

--cDKaHmvCnPt6GUmS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR9sOhAAoJELSic+t+oim9SvYP/1fiSaeAuEGu0Ni58FX1J/MJ
pj/JkTaRgnzE5p2D4Nf8PPgCCeOwbg8feCNgjRYVVVbNHGY+g3SGPiJz4xkiVufg
36sjIvlXkqBhljSP2atmmfZn9UfWjLIM2bTGDpsKZfQ9oB8ofPzEt4pfTYZA9xgE
8HZOyj2DqitC1VtVYHh2i0+lHP6HtoRI+m+SUGM10uR0GrPA3NAUbzfnFjQL0AUO
cL/l65fIBJRz2pPr/mSjRMJWl6rfdl7Ckfh7Fc2HJ9zasTkGN8XQxB00+vf8ZpAk
c6UGck9ZrMeEacZaCNg79TvGTD6shvKakEMGohySTJdmE7iz9ymsIykU+7f7mj1E
gJY8mC+RuR0s1mFbnMUWd0lfmk3cJtP3MkOi3FoSt9VYJnnEwrKB/WcIkrLcEOpb
l1PESKSHNxxMeEFZDTbdzFaewMYTgIp5dHn3D456PwcpNAqG1INXE0PV2ZdZNcUm
go5VESWJShbVRSHJ0/8q1FrAYUSvh1cFtRy4ykUletAA3nVE4VHLIbm/Tquf0Ukl
59MBWuP/wN1g28irsVoGBlkyIvPUIsAhP6WbTyHl+nfKnQPixuk2Rm9X+3P+b234
1bFxurH2Vgy1lG7XDGJerGbXhNtMNy10RknIAVdu91XH399f1OQ1efEov5l3D57u
Z2S66SYoD45+MjHZqewr
=dMdk
-----END PGP SIGNATURE-----

--cDKaHmvCnPt6GUmS--
