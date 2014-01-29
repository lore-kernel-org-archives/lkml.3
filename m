Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbaA2Lkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 06:40:35 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60842 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaA2Lke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 06:40:34 -0500
Date: Wed, 29 Jan 2014 11:40:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Manish Badarkhe <badarkhe.manish@gmail.com>
Cc: Joe Perches <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140129114027.GX11841@sirena.org.uk>
References: <1390968181-31800-1-git-send-email-badarkhe.manish@gmail.com>
 <1390968181-31800-2-git-send-email-badarkhe.manish@gmail.com>
 <1390969124.11756.43.camel@joe-AO722>
 <CAKDJKT7ZpH89k6a4yfbBt+dpQ3oM9Khe42VwFmEjKqmu55jNzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2COlia7yG8D6H0/1"
Content-Disposition: inline
In-Reply-To: <CAKDJKT7ZpH89k6a4yfbBt+dpQ3oM9Khe42VwFmEjKqmu55jNzw@mail.gmail.com>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V3 1/2] devres: introduce API "devm_kstrdup"
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2COlia7yG8D6H0/1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 29, 2014 at 04:38:20PM +0530, Manish Badarkhe wrote:
> On Wed, Jan 29, 2014 at 9:48 AM, Joe Perches <joe@perches.com> wrote:

> >> +     buf = devm_kzalloc(dev, size, gfp);

> > If this is really necessary, please use devm_kmalloc

> devm_kzalloc is always better giving zeroed memory locations.
> Is there any reason not to go for it?

If the allocated memory is going to be immediately overwritten with the
string then it shouldn't make any difference if it was zeroed when
allocated.

--2COlia7yG8D6H0/1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS6OioAAoJELSic+t+oim9t+QP/2zjG2oqXZCn04Wt+SgWImZo
7sXR/F/ekqbnKxxLnj25ZPLLVw0ikhqsLtwRTq1xkVqlPWk+zi/wK8AK/e/5bCD4
eZ4UWK2cRaK0V9Yy9cFophyLXQjO7D13Pnm8c1YLjTbOmINWv7PU9EPUac9bQ8X5
TWvsgTBEP4qTrZwSadJZRXJeoUv1L0kQ7Y4xiJ05AG1y+hAdObt0RxJGOKlAySSx
wtdbfsNzPIfHc0ftxWY0Hrjm98OoXciDliXuw4VJG54PdsMMDR+M/4sEUkrcXf5r
PjbjQ9+fzNFCY2Gt8YdkEzQTDtc+V3IdKpN5uMplcynLWScNhn38W6zuyCia2z5/
kLj4HaBvzXg6nfyPF+0MfZ8so5x7vccn211y6VeDmFolAwL8b5M8v+Up1RL1YjNN
TgMMyld3kIybKdoRuGaOADxycCCaeHRSvzVw/eoMGh1EbxVnlo4pQ/mG4ynhBNdb
MMp6zPhSbdFznyk6Y672XJ8F/N05U76xljcEYk+XOp4dhUEB1TstG9NTt+wzhw8U
85q2tT4yDB12UbItUSSi4Yw8vA6sY4CPOgxGUw5Q+ueaTq83LQz9HN9st9QmbXNe
cb3BX3oGBNLvGX76Zg9CZEC9JmVfzGiWYkjS1v0gwyadeZ3Ifrr7dTZWZx8gqtKY
0On6zruDR522F0X8Uy/7
=z+W0
-----END PGP SIGNATURE-----

--2COlia7yG8D6H0/1--
