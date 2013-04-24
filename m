Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab3DXJx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 05:53:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49732 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932347Ab3DXJx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 05:53:26 -0400
Date: Wed, 24 Apr 2013 10:53:18 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [PATCH] regulator: max8973: Don't override control1 variable
 when set ramp delay bits
Message-ID: <20130424095318.GZ5019@opensource.wolfsonmicro.com>
References: <1366733695.7020.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3rx43rDlPB5nB2+S"
Content-Disposition: inline
In-Reply-To: <1366733695.7020.1.camel@phoenix>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3rx43rDlPB5nB2+S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 24, 2013 at 12:14:55AM +0800, Axel Lin wrote:
> Current code overrides control1 variable when setting ramp delay bits.
> Fix it by just setting ramp_delay bits.

Applied, thanks.  Laxman, please check your acks can be cut'n'pasted -
there's regularly things I need to fix up by hand.

--3rx43rDlPB5nB2+S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRd6uFAAoJELSic+t+oim9dPYQAIygT+DvRdoLYUXJ/6GwXxV3
Tu21ECcwC18V2Fm7cMWTWOkIIPvV9CF97onqx2PLGT4WghPVZ1zq8Pv46Xeb+dAZ
2JF7O1jaO6n2FDDT2ojukd9UO9eQ3KYMcaSxq5LGE2qnt/+obnVUxNdaAxzCF+2K
7TLNZoSLR+a3H5AcjXehxVVgRNzxTlBn/sUbHN/YYsV8kz82INe8YHRKWGr+7DQl
ZSktDur7yZMm/lWF9kl293edoCqSo8VbZFfCNhwQggWP3gaX0Eu66B06ApM2nSDn
K6YKJtaJBJGJUUeQ5DEaXrrn5FXrFjJWGFw3taJ001kZmzrNoiwH5P/2ZAw4vjqt
X9kSEJOCaQ/0b3EtdCN8XXwUWHrKU0hzFYP0UorEL/OnPC2/k3D4gleXXOrs3i1n
9kJEC+Qf9/jwKHTqNafh2rZTpSiQTPW6IePPwcwx5QKGGwvTplKL+3Lc/2arcwMd
PeGQ3WRGPtLaBBWUuseTZz84RHLemGOWSBBV6nOfCw7NMGrEdF1DjWiomVhbZZHZ
GQ/PMVQ+QBngzbgxIlKf+Jb+uF4GNyQk5A6MqlfNrHbWRWBWQvAhjibRSuE6L05r
S/PhFAEWodPtcNkik3Z5cK8+Dkzh1WLD8G4fvE/JT2tuX5X0SlJm8ST3O8X5Qt4L
hRWbnvV11hXpeNA5j0G9
=Dyaa
-----END PGP SIGNATURE-----

--3rx43rDlPB5nB2+S--
