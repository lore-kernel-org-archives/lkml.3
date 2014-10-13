Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbaJMNU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:20:28 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50746 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbaJMNU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:20:27 -0400
Date: Mon, 13 Oct 2014 15:19:55 +0200
From: Mark Brown <broonie@kernel.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        kyungmin.park@samsung.com, javier@dowhile0.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Message-ID: <20141013131955.GC27755@sirena.org.uk>
References: <1412940935-14721-1-git-send-email-cw00.choi@samsung.com>
 <1412940935-14721-2-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8GIDNBYM960X1xp6"
Content-Disposition: inline
In-Reply-To: <1412940935-14721-2-git-send-email-cw00.choi@samsung.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv5 1/3] regulator: of: Add support for parsing
 regulator_state for suspend state
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8GIDNBYM960X1xp6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 10, 2014 at 08:35:33PM +0900, Chanwoo Choi wrote:
> The regulation_constraints structure includes specific field to support
> suspend state for global PMIC SUSPEND/HIBERNATE mode. This patch add support
> for parsing regulator_state for suspend state.

Applied, thanks.

--8GIDNBYM960X1xp6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUO9F6AAoJECTWi3JdVIfQKgUH/AqvET4GUcQSoojTVnlI6k5e
y1GDjpEctVra5SDTiDGo+wrD9EsCfpToVr7wyB23AaPSdHcHzO8AJwFLNjgN53GA
HE1zQo6laHlePpZQRv7Pbg3Pw72m7v3ACzYThmOsI8GAk+Oqt4c5yAJ5RsbI6wLQ
tBpGXfENyhruvDulcleINyTTdyjmT8Stbj7sNHvsfexHn2cN9QgNkTBj/5s7u4iE
NsEYTD00qIZ+5rAQi3NqKOBvAN+sx5Bbn2R6xmgMZGlczRdg7Rs0f/xns6nlWt7v
K+FXbJohYXj8RFaOmMd3FQr4YKfaX821JNwo73/07rx10oolI3y1C29O1HQatIc=
=K+dY
-----END PGP SIGNATURE-----

--8GIDNBYM960X1xp6--
