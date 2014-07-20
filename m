Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaGTHaj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 03:30:39 -0400
Received: from mail.kernel.org ([198.145.19.201]:33415 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbaGTHai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 03:30:38 -0400
Date: Sun, 20 Jul 2014 09:30:26 +0200
From: Sebastian Reichel <sre@kernel.org>
To: weiyj_lk@163.com
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] power_supply: Fix sparse non static symbol warning
Message-ID: <20140720073025.GA19112@earth.universe>
References: <1405834269-7726-1-git-send-email-weiyj_lk@163.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <1405834269-7726-1-git-send-email-weiyj_lk@163.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Jul 20, 2014 at 01:31:09PM +0800, weiyj_lk@163.com wrote:
> Fixes the following sparse warnings:
>=20
> drivers/power/power_supply_core.c:540:5: warning:
>  symbol '__power_supply_register' was not declared. Should it be static?
>=20
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Applied to battery-2.6.git:

http://git.infradead.org/battery-2.6.git/commit/c128d39737fbf23d978eb05a9c7=
915507a69c1df

-- Sebastian

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTy3ARAAoJENju1/PIO/qaaqgP/jFvAQ6B7PpgPLYKcEamJpls
P0Gml5huvvsvnsyP6Nc/BIubekcNkMfVvZssqpUujp+RrIM54lJF6m+izS6NU+uV
ADS14VWzp6bvT80T+dY77+4OPo4pH+V2V4uzCgINoGVpks01nukWs6DQhUZjab5i
63x6HtqFgprXl9fWs7NKgqWpk6Cx8NxKS5iIIU+ncvkbahg1OLNDxloFxjt/tvPy
qCYkwP+3FPRW3U/gG9puaHqOnd2v5qCzSAP9dpBfFf2RtbyS68INmKQkSJdwzJJW
B5xc4N+tJYHsk7XhZi3pA2J8hxbpUuqZQ8K9rTCRqZt60ae9IyrfZNLGImZ7jJPo
BcggpGSWhyTzYPn0esoidSjoMJLlwNZvsawuNZF8OdSnB9RUOg33aCfAdvgVUzTQ
+DPOssniEiGPyTkwCIN2lkPg/APprtNC8UROfQd1HDfp4M5O6BH7mIoFgf3sEZkD
ujKnLTX+LTj3rHC8NcltzQK0IG3J2DLsq9yAYyJaqjD70DeUYb891zCdsucN9peS
Q99GqJvdKOAwLbEWIGlFbgIHfV51uwwFtv6ybmLHaB3qioborKCeE42eCOX/6cbR
dTSzDDqtvZtPEda7HB2taLM702GssPOXPQ3GE0BmN3yw7hnPnxoLXFA4/h9/ceZI
+0IcpbzOeCTLBGEM/Eqi
=k96H
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
