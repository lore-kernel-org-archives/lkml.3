Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab3L3MnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 07:43:09 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49602 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786Ab3L3MnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 07:43:06 -0500
Date: Mon, 30 Dec 2013 12:42:41 +0000
From: Mark Brown <broonie@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Srinivas Ramana <sramana@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20131230124241.GU31886@sirena.org.uk>
References: <52AA42FD.4040503@codeaurora.org>
 <20131213104128.GT11044@sirena.org.uk>
 <20131213213707.GO21983@codeaurora.org>
 <20131216210153.GA3185@sirena.org.uk>
 <20131217023047.GC31766@codeaurora.org>
 <20131218184541.GH31886@sirena.org.uk>
 <52B897A1.8030205@codeaurora.org>
 <20131224125358.GB30815@sirena.org.uk>
 <20131226193416.GI31766@codeaurora.org>
 <20131226215204.GL31766@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L7QcuKEPlEDqpLxW"
Content-Disposition: inline
In-Reply-To: <20131226215204.GL31766@codeaurora.org>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regmap: Allow regmap_bulk_write() to work for
 "no-bus" regmaps
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L7QcuKEPlEDqpLxW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 26, 2013 at 01:52:04PM -0800, Stephen Boyd wrote:
> regmap_bulk_write() should decay to performing individual writes
> if we're using a "no-bus" regmap. Unfortunately, it returns an
> error because there is no map->bus pointer. Fix it.

Applied, thanks.

--L7QcuKEPlEDqpLxW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSwWo+AAoJELSic+t+oim9pvwQAINXQViy083caO4NPXI6Nja0
bN0hFdNIlB19M7jRYueHpK5zn9hZdBv6hrOWzQr1e/u5Ra2/BquHNUs8wuBFp+tm
0GWuH/JJ3U5ncp84PzoC7kaJTr9WkEOIXsjCfgQhJkQVTyB/j01wW/QTghF1j6aO
PDqaNSa+vT2bUe/13Oiupr+R9OQX27e9SeRH/luxc93ay+A8VRp4Ig6WcrkGr1fu
mM40bgAtWraS2f4+dWWu06lQhwnERa4leWpv+AC59DcR+P2VmoEZ/lVoBJwqacdO
zIInlubOxvMaF7ZN2Kre46eQQKB55wW2xWrIingkq0xxvJI7GN8rWh2O6ON4H/KP
hFM8rDf1TAwCh0tv8AsXo2KL/zbr2rXfZd29hlYLep8Ad36Evuj4D1TDWHk9AeYH
qcPaG+mK1IkDQ0037/G7JL7A4P4tki0QfOUAPASb+Vv9BSDHGUaNogyT3j0BVYJQ
EPowHQb5bWzY/2JWG/xp4OBCO+Krd7wOGDc67X8J7/U9rQx7kZID4icMdhU7ErOY
qfci3TZ+wfjLhrRm/w9ZSYCuspesoqBKNksVtpMji+V5AFlfTMY+ba4/4VzX7c56
zcW2+JeDV8mTUXUKU2c1QsmdpnSQcflGupIAeJ/Y1Tk0gL1MI0WjKuuL7iz0NZce
brfhZvOixIqZn9/KKbQ5
=DtOb
-----END PGP SIGNATURE-----

--L7QcuKEPlEDqpLxW--
