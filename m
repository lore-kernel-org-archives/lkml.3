Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab3IJRUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 13:20:31 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56781 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab3IJRUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 13:20:30 -0400
Date: Tue, 10 Sep 2013 18:20:06 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Message-ID: <20130910172006.GZ29403@sirena.org.uk>
References: <1378808106-29865-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qh6PfPWXtGpbNfLf"
Content-Disposition: inline
In-Reply-To: <1378808106-29865-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: core: provide fixed voltage in desc for
 single voltage rail
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qh6PfPWXtGpbNfLf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 10, 2013 at 03:45:05PM +0530, Laxman Dewangan wrote:
> If given rail has the single voltage (n_voltages = 1) then provide the
> rail voltage through regulator descriptor so that core can use this
> value for finding voltage.

Applied both, thanks.

--qh6PfPWXtGpbNfLf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSL1TDAAoJELSic+t+oim9E1kP/0ff/HAKUw4Q1pZx9w9NZOF9
sIqhuIg/QH5xzO8eibhCQiEmrE8Yjs2cD5mxin0D5BYnX+Gj5pj4AGILdCVlxHF9
WUKK46USrkmpRPSjBd1IxDOlz5vh1kClhRZKVpYFudhOp8KMJtqy7casdVEzkKhq
w3LIiPlPByC4ey96En+r3J5ntORJhvO6hhD9HTsU70H9GvlyW8bhYk73yDUiR7gt
5/pxz45dKsbXdWtnDQ3mLIlPUeJELZ4olgLCkhQVNph4o8dYWE8GM2i21obS1ixm
c6N7Y+sGC15X9ccjEUf5oy8yhnub6/8+gbbd/bzz9MxjjFbMgQNNydRv5z3yAyeZ
IEEQT7toL6QD9hC+19FnchWoFX1hLM8kA2o8IhU2pvKYfq3rAz5oFqcWH9OtfDgV
CTQ0lYTYTXpBiIPk3RqJYI98NDeDkTwW2VO25x41+kwFPsjJdEroF1e10UfpIUfv
hdjQwwCQzPH10suUIOe614FGxcJCYT637AsqG56yhp7U2ub/8qD9oetlPW3ndar9
aAz8ROqxnOCCrsdUXZ8+gGODZiqH8JWLYdqEjc/8/QMj8Gh9jkvPkCDJD0RfJXje
tiPIX5FBvPyxVitknnvPpV19oS9ErUFAvjNVt8nhloKB0jQzP9L0R4bI/oHnpF9h
Sq6wFyIcmO6PVYaFixcv
=6gT7
-----END PGP SIGNATURE-----

--qh6PfPWXtGpbNfLf--
