Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab3K0Pmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:42:54 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50564 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab3K0Pmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:42:51 -0500
Date: Wed, 27 Nov 2013 15:42:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <20131127154221.GZ14725@sirena.org.uk>
References: <1385559982-32039-1-git-send-email-k.kozlowski@samsung.com>
 <20131127152042.GY14725@sirena.org.uk>
 <20131127152358.GP3296@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iuL7KOmW1iVG2alW"
Content-Disposition: inline
In-Reply-To: <20131127152358.GP3296@lee--X1>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 1/2] regulator: max14577: Add regulator driver for
 Maxim 14577
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iuL7KOmW1iVG2alW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 27, 2013 at 03:23:58PM +0000, Lee Jones wrote:
> On Wed, 27 Nov 2013, Mark Brown wrote:
> > > +	{
> > > +		.name = "max14577-regulator",
> > > +		.of_compatible = "maxim,max14577-regulator",
> > > +	},

> > Why is there a compatible for this at all, would this ever appear as
> > part of a different device?

> For automatic assigning of it's of_node.

> In previous incarnations of this set it was done manually for some reason.

The usual thing to do is of_get_child_by_name() on the parent to get the
container to search in.

--iuL7KOmW1iVG2alW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSlhLaAAoJELSic+t+oim9dQQP/1f8iBNIrClTGQwT63yC+YKx
OzoPXr8gj3AAhtyjhoQRTtXFrMUBlnChrk5rTs7v9wSjrtsTwpUz/Qmt+UPYl6fh
WuCbu7fTSlFrqFp4pQrF4IHFvTXTDuRcw8sbh7XShbtrb+74Vn51Gv990IrBvwo5
p00HpinqORL7h37hddJjubFYbbxiNGVLs2K2u5Q7eidghpcYmehWHnUeiV9qoWWE
5UG6qOEiO7YmEXmmZWZoF/0U6lAKnVx6kk4KxLsueK+RhOkbjS8xzx3tWdjWqN6t
iSSUW0dLPQOeF/ulPiOnMXSA4BvcQHffF94TDCKuiKa12rH/K60U2O5Pq9cxjl/B
SYs8lrUjeHQlR5NMQ8bF+xTGoUBJHsgGjkVciLnx/zUmSqViqv8q+L3aqsT4jMPw
p/01CZAGXFvKudrI8tPNkxzUXN+NNGzZnoUAG8H0yYTgkfQIPuMVO/b2OzNgupsq
dvCn1/bIZzkAJ+SrwbncR6T6fm86g74td98YsIy6ozD3/4yayULJVWTvd4c0KUbv
qxUiRLGzqie/CML/pw06fryysc9DaBnVRMfinC73+sbDgcRouB4OjplmGkSUlmnV
liR1GFGNEE067efEvKJFXV5bzlEOiyJ783vkaEaVGxRYCQ/VHHK89h1Vuh3Ozuif
RhMdiBzUxmuYREOTxi9L
=ZDZm
-----END PGP SIGNATURE-----

--iuL7KOmW1iVG2alW--
