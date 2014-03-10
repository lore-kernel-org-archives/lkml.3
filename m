Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbaCJJcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:32:35 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49617 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaCJJce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:32:34 -0400
Date: Mon, 10 Mar 2014 09:32:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140310093226.GG28112@sirena.org.uk>
References: <1394440371-29588-1-git-send-email-k.kozlowski@samsung.com>
 <1394440371-29588-3-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+lyI8POnKyxW93e8"
Content-Disposition: inline
In-Reply-To: <1394440371-29588-3-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/8] regulator: max77693: Remove state container as it is
 not needed
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+lyI8POnKyxW93e8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 10, 2014 at 09:32:46AM +0100, Krzysztof Kozlowski wrote:
> Don't store pointers to regulator_dev returned by
> devm_regulator_register() in allocated memory in state container. They
> aren't used anywhere outside of max77693_pmic_probe() function.

Applied, thanks.

--+lyI8POnKyxW93e8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHYanAAoJELSic+t+oim9Q+gP/iIhjpdHrShquXbvcbPnS3a5
B3vODwHm6nbpmce8/kKmyoRFz7NUj+ugDXd+SbDbWi+QMJ3cF5dsOSI8CDEsspEJ
R2UBTMk7ImetY3I7pIyrHVaRu00xCAWJbBw+5gyQtnnFRbKDUiCjgmynvYtdCD8G
C7Cuv829lZuwNlj0NPagyfr3Y96Ai1qj6Mr31RhsvSpYd70Qso70fouTqjiuRTDB
pv25yhq4D9KgH5bJ9Glj/WoRPdbi6qFVbEWl2ocXyXEzQhItAVQgjJ2clLrmfQSQ
mbvIdXGd9qpfXjN05AQe1Md4kL5qhQV+h4G5bxsIozz/xuhRxdrxJ/XDJl9p/LBz
1oN/ZhatoYWDrxOSYpsGGAaoZJSR5E1EPUrW5yRlU1OKY2+FzjeqqQqSPnw397k8
T4DOzvg8ElipQYpGn1MmBkn6Jr5Qdo9k6eH0gbMWRho9mqbNOd7bG73Ldp6aq+AW
yKyN7FVTC+wklGY0C7sYL4BaW4xsM4fFakrVvLsVnl3OMAe6w4SrhxCt9Zcr+dqD
raNYXpiB/J/bjPPiovisY7YhPs6Kl/3m0uTdmRKYwWjC4lM6WByIHVCFMhrdgudZ
uVOAlVLSaqoe48D1xzaAZtHhIHAUX3v+2QuAxcl7YpZLqbmnycd/U/kDjZXrPat8
egUhyHzYA4RLAfSac7wT
=Z7Ew
-----END PGP SIGNATURE-----

--+lyI8POnKyxW93e8--
