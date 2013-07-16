Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab3GPEPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 00:15:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39781 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916Ab3GPEPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 00:15:00 -0400
Message-ID: <1373948095.31067.160.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] Documentation: update references to v2.6.x in
 development-process
From: Ben Hutchings <ben@decadent.org.uk>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Willy Tarreau <w@1wt.eu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundati>
Date: Tue, 16 Jul 2013 05:14:55 +0100
In-Reply-To: <1373931284-26333-1-git-send-email-paul.gortmaker@windriver.com>
References: <1373931284-26333-1-git-send-email-paul.gortmaker@windriver.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-CbD1uC+V7ZTecxSLyBp8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CbD1uC+V7ZTecxSLyBp8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-07-15 at 19:34 -0400, Paul Gortmaker wrote:
[...]=20
>  Some kernels are designated "long term" kernels; they will receive suppo=
rt
>  for a longer period.  As of this writing, the current long term kernels
>  and their maintainers are:
> =20
> -	2.6.27	Willy Tarreau		(Deep-frozen stable kernel)
> -	2.6.32	Greg Kroah-Hartman
> -	2.6.35	Andi Kleen		(Embedded flag kernel)
> +	2.6.32	Willy Tarreau
> +	3.0	Greg Kroah-Hartman
> +	3.2	Ben Hutchings
> +	3.4	Greg Kroah-Hartman
[...]

You could also link to <https://www.kernel.org/releases.html> here.

Ben.

--=20
Ben Hutchings
Humans are not rational beings; they are rationalising beings.

--=-CbD1uC+V7ZTecxSLyBp8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUeTIv+e/yOyVhhEJAQpOThAAl+7YhZ1XpuukDI8etLLEXF2dS1YkkFtA
sMr5kdrLTtz/ZE+N3HYwKYxwSEE8e6jYuRDqbGdv8DBL+wrPd1C1YKm1skw766NQ
JqEw2ozt4d7SINn0Y9Mmj47P6hUAwJY5lUXwitdAuHfAZbHcAZwM2N77RRuZNrfD
o/MwK5rSf2Slb/Iu313EFR35qVp1AReSuRBEjRopGfedZSmWtp/aOxElU+OAJBEc
Xw3ZX/jh0QmPuXlfKj3xq5Qn5H84rV0OCDfHpuoIHhW4lhJK/lZJAresYYQZ78ux
3mo9G702i9uJaKnCzK7+JSVRle7Gm/T/g0Vz4FijmsK3/Fd5oK6PwsGnHS8068gf
tQGDtLnb9jTmlQ08LfKFy71MeVYfYGnmNds7l3UrXbfLRSOcAGh0e6kJf4hjibjK
3Uh08dCSvyclx3wqgQwaWTRj1HcrgQcwgm7hpEH6bU95k2iw2PiqtLbUFu5mJ8UN
kV2hSc1sTgP35tRjca8Ttt6BnvrFQlpdu5NmAQlC1rKfRGutilQbkhIS/e57W/BS
XpvoCzPH7NaOqgfh2w4bBAkXLNPcjzhRlZnqOZg6xM4pDs5/khrlweggRCG2WEu7
ScXEUZai4sOaHF3dtcUkR4/Wz3HYYhkiNSQFxsd/BZMKutY+2H2/1+/ddd507UVG
lKbyA5cyeYw=
=KZ3I
-----END PGP SIGNATURE-----

--=-CbD1uC+V7ZTecxSLyBp8--
