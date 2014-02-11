Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaBKM2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:28:09 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40363 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaBKM2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:28:07 -0500
Date: Tue, 11 Feb 2014 12:28:01 +0000
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140211122801.GK13533@sirena.org.uk>
References: <1391669261.24190.1.camel@phoenix>
 <1391669351.24190.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BFVE2HhgxTpCzM8t"
Content-Disposition: inline
In-Reply-To: <1391669351.24190.3.camel@phoenix>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regulator: rc5t583: Allow missing init_data for
 diagnostics
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BFVE2HhgxTpCzM8t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 06, 2014 at 02:49:11PM +0800, Axel Lin wrote:
> The regulator core supports this to allow the configuration to be inspected
> at runtime even if no software management is enabled.

Applied, thanks.

--BFVE2HhgxTpCzM8t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+hdNAAoJELSic+t+oim9OBUP/AljwlSgq7VOQVy7jA4Asun/
/lxEpL7t02EGAsheFEtzsj6TdqcU6iEYZL6aeyNQal78FceRolrmlnE2RUi73E8j
+JbB7ZI7os3eCz2evsdW/HubKP/5ZgLPomx5lOUxHoN6P6Z2yx7dgGnLeVl+1zCV
Al3UuooCYk4+rwQqP1W6lPr7vHejJyLBf4XhLMKQ741n8kfpX89qtqReRB6p9qwn
WNurgmX/eFwvO5L75NAZSNTlKqXH9K7SP9otK3HfzudMPtavDUqcAGaX2+Xc+LSO
0GGUYKXfP0ym1QN/96HrTSARagPeb2TubiGlG/ro0Qod0pJNbugBLfgxsdVs2Ryy
Cnnmmw+eSyM6tw6CJi4m3jMls6X2FvQVm0hiXjQssWrCz9+W2s4ukFktO6yrqMik
fxiUvncTvCw87bHsfIC5hQv32ZNbGJstxmT7XPgD+JzRDwr4sttrE8otqUr7wk0s
OYvh1wJoktmAG5MrqqCaz8xRpC2AP/VqcZ1SxuC7qzOvbGu8qPf3Y9BrJcg0OWr5
J8vxgF7SOA8ePUQpUSaYiK/pqAGTty53H+P+AUvmdDs2kxIwPKMxkMgJR6VT2UBn
k7mbLIj2dAC1fIjBP+8TkrTRTy9W5AbHapspbh9+EDJBmu0NPl/eV/wxImMjnEit
+WbVTjwZBsUHjI0Ag2Nj
=+Nn4
-----END PGP SIGNATURE-----

--BFVE2HhgxTpCzM8t--
