Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbaA1KpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 05:45:14 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60528 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaA1KpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 05:45:11 -0500
Date: Tue, 28 Jan 2014 10:45:03 +0000
From: Mark Brown <broonie@kernel.org>
To: Manish Badarkhe <badarkhe.manish@gmail.com>
Cc: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-omap@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-tegra@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140128104503.GG11841@sirena.org.uk>
References: <1390878720-8676-1-git-send-email-badarkhe.manish@gmail.com>
 <10462793.IYoAK2XtXv@phil>
 <CAKDJKT4jPLmtrm6Ngp+nT5vf0H4zXwwAM=oURDF-DSAJodVN6A@mail.gmail.com>
 <1939430.3DVPas1i8V@phil>
 <CAKDJKT5z=-CmK+goocgdqy2eQMZN2tsoPgzOFk4KbFTTTiUNAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AgVde/5+edhW42SA"
Content-Disposition: inline
In-Reply-To: <CAKDJKT5z=-CmK+goocgdqy2eQMZN2tsoPgzOFk4KbFTTTiUNAA@mail.gmail.com>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2] regulator: fixed: update to devm_* API
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AgVde/5+edhW42SA
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 28, 2014 at 02:31:32PM +0530, Manish Badarkhe wrote:
> On Tue, Jan 28, 2014 at 2:25 PM, Heiko St=FCbner <heiko@sntech.de> wrote:

> > I don't have a strong opinion on this and others are most likely more q=
ualified
> > to have a definitive answer, I just found it strange to exchange one op=
en-coded
> > pattern against another open-coded one.
> >
> > So don't let me keep you from it ;-)

> Okay.
> @Mark, Dmitry: Please let me know your opinion on this.

How about implementing devm_kstrdup() and then using that?

--AgVde/5+edhW42SA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS54osAAoJELSic+t+oim9iW8P/1Iv+gJBXlj5GzRiq8GKIo1L
/g4WxiYlSOWmzaM0qsUwIbe5sQCF/wo/0QDKjTe/E80R1UKeFb9DBs4/MDTyWp4B
52Rm/AZBmRiUnA5yo4wjBL+C39e30+xq9kjtWt+TYmRtMr11SqjsrqCU1F5CsIpk
mtcMUkv1+X6rCSb5jHUrmK5m5o/pRnV8qa9kxZbpu2nyiEa070j8wyAtIQVZx+hA
9O19CEEGfa1V+5tmcTY8ecz6FYRh2utBD/1KbC0JCm7sYMXynJEdTfZE88QdMHJJ
tYIC96FrrRFjyYw53DE01EIKicVJZLrctiXXHsCFmtD7ahX+ugCRFB2zi61ojbhE
9i3O0fgV2n22TVXXShMWrQFFTT3qaPUhDbma3hFK5S0Xa5RAmNtnABh20ssmx+My
p0Nfn9bhghS/jJvxGarLdG7M/5YnnXdXkqCm+q17u0w1YbVcInm98rqJvHmoOepG
GRdQ+jxmrkMXX7KgXpPSfP85z5DhpxDNgZGAT6LrYOqz1WXDK3SVvEmFBOuQIw4K
0I6SXcpCyIvncorr7tpmIdO6Pp0OM6XGVfWTOI9gmLZ8r2ZSt6y3cLnz2hKZ+Z6U
BSTbPbw02t72QO7OqTj8oRgAuKCuQMzlNOA5xckbosGG0kREGR5rTrSnSx6AjJPF
2CG6SGBR8FRDAJCkS5ly
=PGRB
-----END PGP SIGNATURE-----

--AgVde/5+edhW42SA--
