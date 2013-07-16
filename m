Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab3GPMX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:23:28 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:35298 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab3GPMX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:23:27 -0400
Date: Tue, 16 Jul 2013 14:22:37 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: mturquette@linaro.org, emilio@elopez.com.ar,
        gregory.clement@free-electrons.com, cate@cateee.net,
        yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] clk: sunxi: fix return value check
Message-ID: <20130716122237.GF3125@lukather>
References: <CAPgLHd_RTeUgZtsLd=GqW7tG0q-ccDcd8gBNgDxo3E8qLE141g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A9z/3b/E4MkkD+7G"
Content-Disposition: inline
In-Reply-To: <CAPgLHd_RTeUgZtsLd=GqW7tG0q-ccDcd8gBNgDxo3E8qLE141g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--A9z/3b/E4MkkD+7G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wei,

On Tue, Jul 16, 2013 at 08:17:45PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> In case of error, the function clk_register_composite() and
> clk_register_factors() returns ERR_PTR() not NULL. The NULL test
> in the return value check should be replaced with IS_ERR().
>=20
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Thanks for this patch, but Axel Lin already sent a equivalent patch for
this issue last week:
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/183138.html

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--A9z/3b/E4MkkD+7G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR5TsNAAoJEBx+YmzsjxAgDvQQAIAOYBxu+iec2E+0uibxn7rc
yUZHF41jy6Mn9QB7cBSYM6yiL4GzIioLlnxauwbyrBEFJIxCM0esfALap/g8Wb5J
2ChCM9NgVFySZ+S6cVIcspGpu/GOquU/lqeZC5A3GB6cU02uuYjgSnim3jPxDhP6
nJI6ecPtFy8KhiRL0g81oMuvB2qBfMgcxqWBwFwUSVO7RvO9OJDNQiZGkxbHwkdd
E3kj/1HCrfJ9VFQ/7kOUqOh4Sy65LuAf32xNbbgGHCurUr+H3sq1mxBLLEahUdIp
cMue1Pef5PK619uhRoh6P2nM4jEQBWhuklXIvJynu+JcDmEQYIsteYi3xqKjH0SM
ssJL5TnQqFc3lUKA3w0kWzlLumoNH5jeO4f1zyM8uSvIOj4HDPgv3ndJemxxPjfn
SYLtvrHWq7aF+24ECLKyHnQlO5WMGNnyVElMqsRC7h4gUe5IYiOWPEaSHhbpYhut
zPXUaIpFTFTeNUfwOVsSBVIb1FCgKwLJj5mp5CGmMNF4Q4cO5ceebRVKpq0i4QUw
1tMZCI3KgbvMIO5LmxMicpGN//15gHxPdoWYWiM9bEznINagErxgrChBKFmIqBd2
EGe6m7xv4UV2Do/Iaa5JLae4KKgT/YHxnuvkZ1b4twlho1SEfm4gn9zszDkcFDTW
i1xrKQD/9cWmhzz1PZcV
=h2D1
-----END PGP SIGNATURE-----

--A9z/3b/E4MkkD+7G--
