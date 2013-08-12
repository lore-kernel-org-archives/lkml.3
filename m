Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab3HLUnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 16:43:53 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46549 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab3HLUnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 16:43:52 -0400
Date: Mon, 12 Aug 2013 21:43:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Message-ID: <20130812204328.GG6427@sirena.org.uk>
References: <1376069102-15658-1-git-send-email-broonie@kernel.org>
 <20130812163324.GB3636@lee--X1>
 <20130812170504.GC6427@sirena.org.uk>
 <CAF2Aj3i3ZCt4Eimp5-4tGnFEAL6gruf+MuH7qEbWezTnfugiqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ra+QPBLzfvE2u76S"
Content-Disposition: inline
In-Reply-To: <CAF2Aj3i3ZCt4Eimp5-4tGnFEAL6gruf+MuH7qEbWezTnfugiqg@mail.gmail.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] mfd: tps65010: Use power efficient workqueue for power
 polling
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ra+QPBLzfvE2u76S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 12, 2013 at 08:57:54PM +0100, Lee Jones wrote:
> Right, I know checkpatch.pl will complain, but one must exercise some
> common sense in situations such at these. To bring down a single zero for
> the sake of the (in my opinion, slightly out of date) 80 char rule seems a
> little rigid.
>=20
> If you feel strongly enough I'll keep your patch in tact however.

Please do.  Lots of people do continue to use 80 column editors and mail
clients and as you say the tooling complains.  It's one thing if it's
hard to find a place to break the line but that's really not the case
here.

--Ra+QPBLzfvE2u76S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCUjtAAoJELSic+t+oim9rp0P/1yLQCeSF7WCo+vTMfHR17RX
1FB7cT5cXf2YxKUZQPQ/UYmzmLTG8/gAeMcug0GZ1bWDp9iYJVqOt2BntyBdk3WX
G+Rq9qWWbmj29ndu9dKOa8AVTxuqVgCRva4ILPZrNt/8ZZu2swLNlPRvMCxR6j9A
yFughQs0RKrtzuqGe2/CbZIVEn9pWJjQ8CA0s80R2MslRGO5RAiVIzPcALUkoVj7
M5zK+lqyvwYZ7sCg1JbdLS0vWpNlqj317M0LWqKOaW/gyJPxClyD/5hYGMUMfkjE
t61uEIkf0mC0YbTucuGcxMs/bFUrw475zD8fFXJG6HEJKjeR3bI9rRxCuKp2T7Do
dPH5l/7uw9WMQlmuq+d8xWVjzCovmNEnHz67Pi2GiYDRZntFHnisnQUKXF1LL9yU
hLkOPaY+jizs4mfleqVO8XzfpMATZ1zbDBv5qDAmjcXLzcfU5RrMdjEKSV7lirft
Lr5wVERVgC8RJPZne6GlrdTCifbpkGiQfTLf27rOvUoFwYvJCScZUZpcMr1iXfz/
lv1CIqqnxl3WTwoIxiVk27PNVnUhRbS8wbm6ard/dMbm6hSjJzFfFN5sDQQ4UELd
MtWAd3HmjyxxhF7XSo3YNKpeoBQ8716FW+i+CHPD0giIgvcl09EqR5zWApVMPJby
bWevZJ+0F0dGOjBF5KUb
=f7zq
-----END PGP SIGNATURE-----

--Ra+QPBLzfvE2u76S--
