Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770Ab3FQLzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 07:55:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48937 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932390Ab3FQLzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 07:55:19 -0400
Message-ID: <1371470111.3495.5.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [68/83] ath9k: Disable PowerSave by default
From: Ben Hutchings <ben@decadent.org.uk>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 17 Jun 2013 12:55:11 +0100
In-Reply-To: <87fvwhrrhx.fsf@canonical.com>
References: <lsq.1371420098.113375664@decadent.org.uk>
	 <87fvwhrrhx.fsf@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-oW8Obraw7ry9HR3nKW+r"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oW8Obraw7ry9HR3nKW+r
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-06-17 at 10:55 +0100, Luis Henriques wrote:
> Ben Hutchings <ben@decadent.org.uk> writes:
>=20
> > 3.2.47-rc1 review patch.  If anyone has any objections, please let me k=
now.
> >
> > ------------------
> >
> > From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> >
> > commit 73c79617596b89a3693ff0d89d42bcd5ddedcf15 upstream.
>=20
> This SHA1 seems to be wrong, you probably meant
> 531671cb17af07281e6f28c1425f754346e65c41.

What I did here was to resolve the slightly different context by
substituting in the patch I'd already applied to Debian.

I failed to notice that the same change had been committed on two
branches - the one above is for the earlier commit which is only in
wireless-next.  I also failed to add my Signed-off-by.

Ben.

--=20
Ben Hutchings
The generation of random numbers is too important to be left to chance.
                                                            - Robert Coveyo=
u


--=-oW8Obraw7ry9HR3nKW+r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUb75H+e/yOyVhhEJAQpntRAAlzA084IzeqhuUitm4ghFJBeYioUGQEMh
zr17qzun2kSwQAGJ8G4o/JWTXOT4MZV+FVTXqjiCofXI5gmswW6hn3uSs/AMjMou
nBvjx4oJWkpCq44cTrYSeZzqMHy4uxPaRYM5nRFrdK1pwVcAgXx23Wm9utLzYlav
MjaUobwi0CkKi8OrfOsVZ6qV4xwsqffWz+kJ8HXAE6Y2MQ1UjAj2cbirURKwn7Vb
0lZ4VOyusERr+a0+m6mjmDTkjpOtGDX7ReePuQdm++iCUhqs2u9Oop58FMGtUQM/
yqeYFtxLi8BTvhN4LjfldU2Jxlm2+oYAxPRm+CUGojdsz+9LzVUuIyfjlYGO2P2T
ljsbbenTyGUVxaJ82V2p54GMVd+nePLOq3bw87RdF5+1jlK3walt220B9xXa/oM4
urX7r9Z21yhZ9o/6VjJdxe4ou1UOOOFH3Fn4tm4pnz5cGa5seJpnTc5c1RbHmMkX
UHHGCQMpKCnVQe1iU1+g2SSfw0QbiW8a0xXznaqfGAPtKH+19pxs6Qd0zoyMbyRO
dSZ3ZdE0PpvKKwY6e1kXskwfqTlaiiLt4n3LcnP9kXtJYpZ9NUEAFdBn55z9kZSf
SBEG+iQaRULKWcixPWPpr1M+oGlbKueV7UKf0OgsdI9FAvzpYIg50gl1XsJ+PgYP
FZn9e1ZH0wE=
=WAAi
-----END PGP SIGNATURE-----

--=-oW8Obraw7ry9HR3nKW+r--
