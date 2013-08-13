Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab3HMKS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 06:18:28 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33939 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab3HMKS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 06:18:27 -0400
Date: Tue, 13 Aug 2013 11:18:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130813101821.GR6427@sirena.org.uk>
References: <1375521042.3891.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4CM1oNDqiDLyatGS"
Content-Disposition: inline
In-Reply-To: <1375521042.3891.1.camel@phoenix>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: s2mps11: Fix wrong arguments for
 regmap_update_bits() call
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4CM1oNDqiDLyatGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 03, 2013 at 05:10:42PM +0800, Axel Lin wrote:
> Current code calls regmap_update_bits() with mask and val arguments swapped.

Applied, thanks.

--4CM1oNDqiDLyatGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCgfqAAoJELSic+t+oim94qgP/REIYILKOogwmYq8MGoXoBFl
mo/vPPy2asoCywedghOElitlKmJLb2fBY5RBUjLKGZppJURcC7TVHlzmxa7q6+WX
wDWeqmJ7zfUuKJaQMMGwpMdhgIBB0PpX1/9wVlmL/+nhaLDSFgURDILIUJx/uBBq
T6mEiDsEcUaQxMXajco/3mMpZiz0r1mPe9uikCM1jAGiFHVdaa34HMY8XzEl0Vks
ONNQSuaRXnzEPx7JrGdV9T0RwkUcPjrJ+FD1bwnnmKuh4cPy2ZWvu1uk1FLR1uvl
Y7daSUQUWtgpty0Dhm1P/5FP447eatU65j8Qtdlyg8LiFHBipIiHVcbkhu8wsN6f
I6exhDgyKf111HoNsEqZ5i+xARMZSJpcvNm8dO8xAOavcyXoFLOo3x2mbZRxfxyN
om4x++BaRpGuHKYef68gtVpBmYdgs2gyYdjJ/B7qK6FeVoNGI2tyQ6271Q0sCGBC
rwhDAg7wyk0lhq20byCRFk3uSoNufYxXlzJGIdA72AS2HJEmwf1Bcds8UvuzEV1a
ie2HhvfQA5vETeKp1tGNymkHxkErOGJJuvwZO0WiqwkGXwBStGeum++DVaL+mNQI
dTYjgELWa/nok3nrJdHKnyRedIgvhsY/D8InV3UWM0N4+L21IlvDF+Thb9ksPxf7
QSObviiStRWQQbYTw+TP
=iRm+
-----END PGP SIGNATURE-----

--4CM1oNDqiDLyatGS--
