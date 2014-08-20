Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbaHTQ3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 12:29:49 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51428 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaHTQ3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 12:29:47 -0400
Date: Wed, 20 Aug 2014 11:29:00 -0500
From: Mark Brown <broonie@kernel.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        a.zummo@towertech.it, mturquette@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, dianders@chromium.org, heiko@sntech.de,
        olof@lixom.net, sonnyrao@chromium.org, dtor@chromium.org,
        javier.martinez@collabora.co.uk, kever.yang@rock-chips.com
Message-ID: <20140820162900.GB24407@sirena.org.uk>
References: <1408505802-27869-1-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iXVVnr8Hn1WiTnFI"
Content-Disposition: inline
In-Reply-To: <1408505802-27869-1-git-send-email-zyw@rock-chips.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 166.147.103.74
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 4/5] Regulator: RK808: Add regulator driver for RK808
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iXVVnr8Hn1WiTnFI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 20, 2014 at 11:36:42AM +0800, Chris Zhong wrote:
> The regulator module consists of 4 DCDCs, 8 LDOs and 2 switches.
> The output voltages are configurable and are meant to supply power
> to the main processor and other components

Applied, thanks.

--iXVVnr8Hn1WiTnFI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIbBAEBAgAGBQJT9MzEAAoJELSic+t+oim9LFgP8wf08gIYLIrK9ItJ8yi9Y3xX
yD/FV3AobY3E0pjoWHXWZ8bnVZsvUeQrJ4+pZ/M+GUZJrUYXh+R63w6B0XgZqUu3
FnW8174Bge5PNBcx6f1PNmg364cASHjtFMxfpFqTY4lvoxTuXUYAtTrK+Qrnr25s
nQdixfMpyZk92BAHvKbcoyj5lFiJsN4rw8F5kUK4Z20stDXENcDro/B3ggWKxchZ
3JkDUoWLtk5uwmBYb0b8MpHYXT3OpKM16KkmgzgXJe0zVa8foPeNgavcVtyokNkp
oX767Ix8ncS0JAzT9jcgTKLr/xMfjCNrTqCEMz4rV3wYZJtC5AVd6qQDJzorAOmw
8a0K9zIOsrhAu8Y0h+gLQOq2xnN4RXEISn2Yn2sFxHVxofiP4pcJt/6nbzQcMLOb
ACztXSkx8SE5Mb90+23z45/1Laae6iIQPcCHjRbhgkqVuyXcNQrKiN081VSDvp73
PKbfXnbqUWVzK65zkGtHgZLqqzL4nibWy73sC75eKqp0rZIbqE0xx/CT53a/iDxc
wjmYgPuFh5U68n51foaQDr6kvT8RH4z4RiJn4QM0sg6kbcK416/bloCzKcGwvns1
eHzuR7LBf7HO2OpheCXV2N8bTZEqoIiFbBAFwO6JUO+vJiT9TxEqzhkOrXJ58Vra
wpGGapuGkmajBTTAGVg=
=SuaB
-----END PGP SIGNATURE-----

--iXVVnr8Hn1WiTnFI--
