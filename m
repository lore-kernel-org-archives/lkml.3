Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbbAMJ5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:57:42 -0500
Received: from sauhun.de ([89.238.76.85]:34834 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbbAMJ5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:57:39 -0500
Date: Tue, 13 Jan 2015 10:57:26 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Liguo Zhang <Liguo.Zhang@mediatek.com>,
        Xudong Chen <xudong.chen@mediatek.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        srv_heupstream@mediatek.com,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        YH Chen <yh.chen@mediatek.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Jean Delvare <jdelvare@suse.de>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v3 0/2] ARM: mediatek: Add driver for Mediatek I2C
 controller
Message-ID: <20150113095725.GC1059@katana>
References: <1416821928-11453-1-git-send-email-xudong.chen@mediatek.com>
 <20141124121555.GG3733@katana>
 <1417096856.12707.59.camel@mtksdaap41>
 <20141127164536.GC5667@katana>
 <1418352022.4994.44.camel@mtksdaap41>
 <20150106133753.GA3754@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cHMo6Wbp1wrKhbfi"
Content-Disposition: inline
In-Reply-To: <20150106133753.GA3754@katana>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cHMo6Wbp1wrKhbfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 06, 2015 at 02:37:53PM +0100, Wolfram Sang wrote:
>=20
> > We've started upstream work for MT8173[1].
> >=20
> > We've fixed these issues for new SoC, and we believe it is fully I2C
> > compatible now. We'll add mt8173 support to this driver, so this driver
> > will support both fully I2C compatible SoC and the current one.
>=20
> From what you tell, I'd rather add the MT8173 support incrementally.
> Let's get first the limited support properly implemented, then add
> another controller.
>=20
> I'll send out my draft for describing the quirks later today.

What do you think about my two proposals?


--cHMo6Wbp1wrKhbfi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtOwFAAoJEBQN5MwUoCm2EccP/RS4dHJuEzMWgB63gBreS80V
YO0Xtq1BxM4Q7yDuHnzKVHF4K8rCPbxRZNgpx/xQBOyynE0ZpM/rqnNShRhMty4H
Pl+pr0aG5++hw5zOP32yoaEJtJkzP9US+FZxKphnMPO3+vpqSZvcXQNi/HVcG05c
6WepQcC9YM/bRcQKY79tHvyH4E1qvs0MaX0GYESC9Vw07KQa9tlg38LLkqvidTC7
BYjjrVuim98t8O4BtxN4O8tPY6ASCK5WA2h/IpKQOyWKWQQXI4R/ZqELLF2y6WtR
vPkD4tgQVwmPe67K5rTmNzEv5EgI0GFb8yXXK7BZVdioh4+5db2oFWKYAEE0Xdsj
KLMYgwgvM9HFG63vffqSpXvJXybNwJgTYRTcU/sEtBGHvC5VZUxsEyi2WCRlsEoJ
ULbGZtHRJ4SwBE0nkpKLJCBYO/KnxRcNBFG/vKfnR1fh9UN1pQeLzZlTunrcO7wY
GxclcKMU42mn1y8iGTT+fBB24xc+oxnclqXw75/8BzK4UTskshVbgXRql4WdPRrG
PoFh8OaMcKQmO9QCDqWm9yWbwdScVdcU+S9qK/KhLKUCS6LFMy6pKML+X1+w56iN
M51V91A/6lhBqSDx1pZkm0HpwHJJEyqNTCpvMAf68z6ZHvAswolSl4O2Cu5KgKvZ
pmYlTBo7NbEbt9CmIROC
=IYs2
-----END PGP SIGNATURE-----

--cHMo6Wbp1wrKhbfi--
