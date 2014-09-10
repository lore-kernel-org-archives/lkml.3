Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaIJKwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 06:52:33 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60780 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbaIJKwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 06:52:31 -0400
Date: Wed, 10 Sep 2014 11:51:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: dianders@chromium.org, heiko@sntech.de, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        a.zummo@towertech.it, mturquette@linaro.org, akpm@linux-foundation.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, olof@lixom.net, sonnyrao@chromium.org,
        dtor@chromium.org, javier.martinez@collabora.co.uk,
        kever.yang@rock-chips.com
Message-ID: <20140910105131.GT2601@sirena.org.uk>
References: <1410311886-4579-1-git-send-email-zyw@rock-chips.com>
 <1410311886-4579-4-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+xp03240ql3JIIXA"
Content-Disposition: inline
In-Reply-To: <1410311886-4579-4-git-send-email-zyw@rock-chips.com>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 81.132.226.177
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v10 3/3] regulator: RK808: Remove pdata from the regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+xp03240ql3JIIXA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2014 at 09:18:06AM +0800, Chris Zhong wrote:
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>=20
> Tested-by: Heiko Stuebner <heiko@sntech.de>

Applied, thanks.  You shouldn't have spaces like the above in your list
of tags and as Doug says e-mail addresses should have a space between
the name and the <.

--+xp03240ql3JIIXA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUEC0zAAoJECTWi3JdVIfQp24H/AmSKVhbb+ZxBcBCAvpGU0gg
NbuXBoN4wVYBiRnUD+HHHJaCXmtYI9SWv9aGq57Fkbu2UCH/VBfmn5Q46+Atf51m
ORX3Nv0q5D2fLt0O5D42gtCGnIB9hjGdDeTYGzsYqpJATv3FwD/cJX3jvpaeVobi
ujK8bFjpmU/8mvrSaobnbXu7c2TGa4tPC+MvQ76HCERhGi6DgF7AP+PsKB72SzUm
dXQUCsqfIuBM7mmlBr6A0+RjjYyMsOSlgCdaARpRycMMEnO/V8kwXjFYZN32j4XE
nLzIvj0P++Wdtow1Mq3IE4WDO/ItrKWJVIGbYO1Qu6B7PIOjPvbppUzxy79pw58=
=LEK2
-----END PGP SIGNATURE-----

--+xp03240ql3JIIXA--
