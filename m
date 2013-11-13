Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab3KMNZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 08:25:34 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41557 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264Ab3KMNZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 08:25:32 -0500
Date: Wed, 13 Nov 2013 13:25:24 +0000
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20131113132524.GH878@sirena.org.uk>
References: <1384325546.7101.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="54u2kuW9sGWg/X+X"
Content-Disposition: inline
In-Reply-To: <1384325546.7101.2.camel@phoenix>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 149.254.183.27
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: lp3971: Convert to devm_regulator_register
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--54u2kuW9sGWg/X+X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 13, 2013 at 02:52:26PM +0800, Axel Lin wrote:
> Both num_regulators and **rdev are no longer required after this conversion,
> thus remove them from struct lp3971.

Applied, thanks.

--54u2kuW9sGWg/X+X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSg33BAAoJELSic+t+oim91HoQAIF6imHQ15Sn5VZbSgI/I0eD
vZXvvpETyvre5gEy/IdHyaWnCv+/HeQAJ6RLl+cvJc4PgCaMgHaTTmHh77AvgXeD
c7xYOM3vuHc42DAkbxV7+Q4txFZrrJlwwsFg0ED9cJS4cXLbKXfKgJsFu5nN8Ozg
mbJ06ao0bj/p54h8sOPAcOjghWMCy8rDH81AxQacymZseyp1dU7zh7oD49Etck2Y
VXWt5QOCN4mYbZzrdJS7qp7UpPf4H6qqPq71vKFAcGc9+2dMwJ//b/Ie8oFMOc7l
YQa5PN2ujnAxs17RvjdbxrNUnP94ymr7NxjNsUax8a9ad37xCicy4PLKR87wNvkv
Mb+koeXblFzFX1hMHOJ+55nqH4cjKRJsW5nnWYowNkQi5qddrOEEA9pToGqrMNdV
8aLfIONmvKzb5hYFDd/G7vPeGt2wp740KjnqaiKNgt5lVpPEJQfi0AzjO+Qhkeet
RdA8xCKUquXFAC56rY3qwpYb7Wt7MhfIX13BT6hUWxjEOVo7A1UrnuZbVFSqTMeO
b8QB1a+Wyjw2ROxcXKX2eOgzy3yQQNmyvogUMQ+vvaFeYzc50mY5vWggyyVYFR+I
43B8XUKCqRpHd4NDiaNV4FUX3Jo5+BRkk20s1pBqyfEXrPL/2kTqOSafOrS+Ms8F
jQRMhWBGLvdzxziV+S8V
=fOLv
-----END PGP SIGNATURE-----

--54u2kuW9sGWg/X+X--
