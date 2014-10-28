Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaJ1AEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 20:04:21 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51910 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbaJ1AEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 20:04:20 -0400
Date: Tue, 28 Oct 2014 00:03:56 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Sangbeom Kim <sbkim73@samsung.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20141028000356.GF18557@sirena.org.uk>
References: <1414424654-27277-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZF1t0IC2USSPoN83"
Content-Disposition: inline
In-Reply-To: <1414424654-27277-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] regulator: dummy: Make regulator_desc array const
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZF1t0IC2USSPoN83
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 27, 2014 at 04:44:11PM +0100, Krzysztof Kozlowski wrote:
> The regulator_register() expects array of 'regulator_desc' to be const.

Applied all, thanks.  One thing with the changelog - "expects" makes it
sound like this is a fix when really it's just a cleanup, it's always OK
to add consts just not to remove them.

--ZF1t0IC2USSPoN83
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUTt1rAAoJECTWi3JdVIfQ/WMH/jwyuMTA+4M2datKoKMzjfVh
nKAEKUpZ443EWM2GcUz5D+rnBx2ViLJrGJ8C2IYbOEejvDE60gnNZWPQ6ulyEVwq
SByqKGMi9e8wy0LtEcMJ+vWzYvhfxJAvpjtU5pw0YuHAAFVS6urptn094OfGSl77
mzJ07zz5rm5lPYHP1p6R7KELWD0NinO5SDOTjcLB+vzJGuTsqXAk0/k6eLjdXuxh
F6d9Lq6bdxkybY6Bcrnz43rQaCUx7Sf7GNkTcBmpd9mGjZwEkE3Lr1r2jPEeIo65
ZzTgXJ/O+DrlNFuOQI/dIOWmReVjTzPVVOkTzsXVIRUNibHCSxai/kj080KoSkM=
=bqqL
-----END PGP SIGNATURE-----

--ZF1t0IC2USSPoN83--
