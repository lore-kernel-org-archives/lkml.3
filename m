Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069AbbAFNiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:38:19 -0500
Received: from sauhun.de ([89.238.76.85]:37302 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176AbbAFNiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:38:17 -0500
Date: Tue, 6 Jan 2015 14:37:53 +0100
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
Message-ID: <20150106133753.GA3754@katana>
References: <1416821928-11453-1-git-send-email-xudong.chen@mediatek.com>
 <20141124121555.GG3733@katana>
 <1417096856.12707.59.camel@mtksdaap41>
 <20141127164536.GC5667@katana>
 <1418352022.4994.44.camel@mtksdaap41>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <1418352022.4994.44.camel@mtksdaap41>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> We've started upstream work for MT8173[1].
>=20
> We've fixed these issues for new SoC, and we believe it is fully I2C
> compatible now. We'll add mt8173 support to this driver, so this driver
> will support both fully I2C compatible SoC and the current one.

=46rom what you tell, I'd rather add the MT8173 support incrementally.
Let's get first the limited support properly implemented, then add
another controller.

I'll send out my draft for describing the quirks later today.


--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUq+UwAAoJEBQN5MwUoCm2904QAI0JJRo+RFWevqWId5sZ3byr
n6GPy7NT2eZQT54hemxWgDK1fM7DX6QE8GIkx9PDfxjly6UXA2inrWao9YZv41he
84C4vA4IUtZEm+xKNi0B3CzzggRHhJ5b8hePMMZ/E6QmLkwh9vUYhXE780q8QBM5
rf6dDieuj30efM4eFngEjqrfrpqMbRYoK6mAIxImMcYaue84hpkaGIvIR/DIMZT2
J+WBM/H6WtAmU11DQhRQAkeAAKmgtIRxs3+tSVjuhd/W1aPdhRy8K3ROb6V2unFP
f1uIXfDgpGJ7+CcgqNx353b17UYsXqfjlz38gX+XCwP4EhSjkZAVyAERl4fi33+4
oQDD/uCOzL975A5GbCnTWwmnDVdR/FhxfgvdUJsHwk04n5auRZ4zk58pJ/BRl4Fb
RnoDLyWxggWULSMlfjsZSrZqDYupR3Ww1lYw2WH3ZjI4EBepR5xBu73g+Chy5LtM
vQQATtPkpGEjdJJOlpE6QdzuJvUuGjJWuLuNLpmluK6kS/exS7HDc5ZAEBSLq5lm
Y33doHc7llymtDoI7w1xKRntfrrjBa2cE//lB3x9b6LfIz0nEziuHgmJpNBjKzEK
oWb4FJ0SxlHk8Qj+nnE8opuP6J7/Q0rThoFZEro8FXA+oiAbRWLHeWXD44fJVG1x
KkLAAFsukPhC8/FykSbT
=bNyr
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
