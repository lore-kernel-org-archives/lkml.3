Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964937AbaDIUZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 16:25:42 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46863 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342AbaDIUZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 16:25:41 -0400
Date: Wed, 9 Apr 2014 21:25:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140409202520.GQ6518@sirena.org.uk>
References: <1397028108-10976-1-git-send-email-k.kozlowski@samsung.com>
 <5345279F.6070005@metafoo.de>
 <1397041934.11424.2.camel@AMDC1943>
 <53452F67.3060400@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KHqYxKoy+XnO4RVf"
Content-Disposition: inline
In-Reply-To: <53452F67.3060400@metafoo.de>
X-Cookie: This report is filled with omissions.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: core: Fix Sparse incompatible types warning
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KHqYxKoy+XnO4RVf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 09, 2014 at 01:30:47PM +0200, Lars-Peter Clausen wrote:
> On 04/09/2014 01:12 PM, Krzysztof Kozlowski wrote:
> >On =C5=9Bro, 2014-04-09 at 12:57 +0200, Lars-Peter Clausen wrote:
> >>On 04/09/2014 09:21 AM, Krzysztof Kozlowski wrote:

> >>>-	buf_size =3D min(count, (sizeof(buf)-1));
> >>>+	buf_size =3D min(count, (size_t)(sizeof(buf)-1));

> >>But shouldn't the type of sizeof already be size_t?

> >Hmmm... yes it should. It looks like a false positive from Sparse so the
> >commit message should be rather "Suppress" than "Fix".

> I'm pretty sure it is a bug in sparse, we shouldn't suppress those, but
> rather fix them in sparse itself.

Either that or there's something else going on that hasn't been properly
understood.  The above just looks completely bogus.

--KHqYxKoy+XnO4RVf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTRaysAAoJELSic+t+oim9xl8P/RFokhWPPleqpoQpJ2b8xFD0
EvLvqBXFH03FrdP0Lv0VU5VN0iODmVtWLi9yXmhwHV1oZdZCf0IFRqTMOXg2jxUp
e+UNhNmDRjQg14QFaG7qugURZZdsIsWTwG3HDK8gvamzmuY8XT5DzcAbQ0LTIL9D
2Kw/qCyKuC9v+xM9yk/mZgLHgctCHbRvcmUChzGqUGHLHsjjz0+xIBKNq9a0eq5U
OQl9auLbOavMKSq8RJl80YsssrwC6F+G79EFWN4qI9jPLV0IDEee6NB4sbth9pRA
UTAMV0npziOrJUQ6L515FkYuQa+FKngw5d2xC98ZjDHYVyzUwsdq6gU0qs0hhroT
jLVcOd8vrK/MC5eYsLhp3pgls4GTyWUvY/VdmaSPbiDFuwusoMfGyRY3NTFoeUAT
qhG7ocO218awDciCIaNi93W2yXQfFc895L7jcfKYoKdhfkLqUSrZ3A67EKt+5kFn
J1IzQP6sl7kW/DCeoUctpITocjgGwJq/+oKWGXS7CU8oM4kEbPQEil90svU2HdXF
RrhyvcKEOYEqR8FqrisovBeVl8Ab7H1Fb8DOpZQhRT8NvtKQrjnLXPAjbEaR3ROB
/q6hrCY6EZHY0z2K6+Kn/sbfMRABdX7tMOnMEJBOkuidbF9tFaMjimkIaOVNOlK+
Ln91u/Xxdg4J6VABTKx4
=H4fB
-----END PGP SIGNATURE-----

--KHqYxKoy+XnO4RVf--
