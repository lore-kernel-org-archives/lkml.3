Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbaHKS64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 14:58:56 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58612 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaHKS6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 14:58:55 -0400
Date: Mon, 11 Aug 2014 19:58:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140811185849.GK17528@sirena.org.uk>
References: <1407557707.21696.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vy7kBIpA56vuXHtb"
Content-Disposition: inline
In-Reply-To: <1407557707.21696.1.camel@phoenix>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: Add stub function for
 devm_regulator_get_exclusive
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vy7kBIpA56vuXHtb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 09, 2014 at 12:15:07PM +0800, Axel Lin wrote:

>  static inline struct regulator *__must_check
> +devm_regulator_get_exclusive(struct device *dev, const char *id)
> +{
> +	return NULL;
> +}
> +
> +static inline struct regulator *__must_check

This should be returning an error pointer, something wanting exclusive
control of a regulator would normally expect to have an actual regulator
and want to do things with it and so probably won't work well with a
dummy regulator.

--vy7kBIpA56vuXHtb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT6RJmAAoJELSic+t+oim9ebUP/1wp2iRR6/Oqk0Yks7nv7aQe
9Cko5caxn/nwyDspuwtY84jKo7G08z4d24gAwEEsVcNJWfr20nq1/MSqcnwLNcYA
pHrxqKUAdJdhB0iT17TgjC071Ae6yZrcjrGymXAoUSSSrya/uW9ZqMn2dFtXDseW
yyhAns36F2sx6uETtW+dE/X0ijNeJpNVSPmWci1H6NYROnGXmdJFL5eMoDdHjSPn
0hDnBe5Qd9gJNe8pSsh87BMUqUIfR+spWeplV9Vn+D2+BlAhBUdDgJNbRk6HIBrx
9cRtxoLyIbkaVFlvC0M25GX+C6tDhoU1lrM2eNE2rphArHdd25/IiJZR240+PvgO
QAhsOg7nw92J4RHyVuprspi5LiAXtm8PRJ8HEKxxL5EMcVOZSjwB7vcaiSfsSguO
+XGF/Y/WT5w5FxSO1jxyYXNNB3yvMmuldLo98DU2yHtLvBNVmBweMNfenMzXbncX
GyuHzW3mBDa58CvbfnSSau6/JnC/Hi+miJpa3CLOh9WhU4+4RWxmUxhu4Zx7lVc7
nxNeioyuX6SFbnMbf4ceaIGmoOC2A4QlH4pNZySybsaYZKRlYVmcpwV+MVATDno3
JsJkg3gm++XBwV6NFj6k3+aU7858Ci+9eoGfqTffyc4ynmCacY19n2l6cLaBDLt6
yROjvXyRKN/yDBgQ1LMD
=5YeC
-----END PGP SIGNATURE-----

--vy7kBIpA56vuXHtb--
