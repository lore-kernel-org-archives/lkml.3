Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab3LPLbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 06:31:03 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44108 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab3LPLbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 06:31:01 -0500
Date: Mon, 16 Dec 2013 11:30:56 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Mike Turquette <mturquette@linaro.org>, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <20131216113056.GC3185@sirena.org.uk>
References: <1386770863-32247-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rQ2U398070+RC21q"
Content-Disposition: inline
In-Reply-To: <1386770863-32247-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Yow!  I threw up on my window!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] mfd: s2mps11: Fix build after regmap field rename in
 sec-core.c
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rQ2U398070+RC21q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 11, 2013 at 03:07:43PM +0100, Krzysztof Kozlowski wrote:
> Fix building of s2mps11 regulator and clock drivers after renaming
> regmap field in struct sec_pmic_dev in commit:
>  - "mfd/rtc: s5m: Fix register updating by adding regmap for RTC"

Applied, thanks.

--rQ2U398070+RC21q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSruRsAAoJELSic+t+oim9NVYP/10VFBtM+X7q7qBQXBw8OdYH
61H3N2l6BM7HVcoBuPfRhFgXPHo0MUpddo892psL1I8YfVh5+h9D+uBDsQsZy3o9
MZIKPFXNjEAQRiCXTs0NvDAGgIxaKTDpHMQVy0JX4rxJeppvkMtDb9Yc/1430vo9
6MQMMEqInTnOea80n7hToAfDY9dvqb0YmZPhCwxqArlpRENvUq6FdfKlgRUa0TGi
0pbm3hlczzRhruTC91K4zZ0h9m4EMO87u80tH+XSgZbz8C6O4fjV5PHlOTjqqvhq
4oPnGK+Fw+fPBpnVgaTlb7XBcET/by+hhk53zED8x/wzJ82rj/2YeFFS3hzvhKty
xWfyZfI11Tap1nx3K6kkcUZrxbmKznAIsxN5c0q9X+DC8Rd08sfiql8pzrjTvojE
RydYCIClaeLwK57OIY9hFkmwA4Ew3+P3UJBD388/81ksRNNBqDjBDRTu+PGORHSW
UaX9YC16cqw4Qu/zk6DpqkJ8NTF3bgb9cn5i3ttRkvQfBjr9f2sF5E3iBeKrYvGd
mE2TJn+mrQJd0iyEt48S2Hje/8Sc+HCk8OOcvP+T5ATy3uChtiUGzG2WPSLlunxy
sT/hPbotXqQQNWMPQxXYspfG5CurgQdVYCK312w/6Lv1EMdQAtgf/veulK9o6v+Q
YQYS2Na/yAC9Kz8cTNmX
=Ghiu
-----END PGP SIGNATURE-----

--rQ2U398070+RC21q--
