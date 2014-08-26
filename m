Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbaHZHbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:31:40 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33459 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbaHZHbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:31:37 -0400
Date: Tue, 26 Aug 2014 08:30:50 +0100
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
Message-ID: <20140826073050.GX17528@sirena.org.uk>
References: <1408973826-23845-1-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7LcHW5enrYT/B6h/"
Content-Disposition: inline
In-Reply-To: <1408973826-23845-1-git-send-email-zyw@rock-chips.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 4/5] Regulator: RK808: modify for struct rk808 change
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7LcHW5enrYT/B6h/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 25, 2014 at 09:37:06PM +0800, Chris Zhong wrote:
> The "dev" has been deleted from "struct rk808" in rk808 mfd driver
> so rk808->dev should be replaced by &client->dev here.

Applied, thanks.

--7LcHW5enrYT/B6h/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/DenAAoJELSic+t+oim9x0gP/0zi7e0HTlygyZgbyf7dxrhe
WtQ4Dlq5sDpCDZOj1xVbiOdOrvYHh4LjrUJJYE+8bvvHfpnQQZastW5IjaK+cWZR
WSSP4wV0I5wCplcQq2WqsKAMIM/HfZFMF2vQihvYhiXvztzD8Xs/3BfllxFxBJ0r
5frLWul0U8YK1IKrurRCVFO4WUAQLlUzqL6N0z0ia/X3q1b6TagZTfSumhaGXgvi
ZY0MkkAUQTzoUD5CYAjoz0euUIz3oOm5MKJU/6f+tds3HtH8dMkoCiiNqn1zW1/7
8WXbrCO+lt1THbX4j3cZXYVQkbPBsyc11T9RsyqY0qoJ4JKnR4zbGMC3L9fA1g3G
47g/0aNe8NEg3T8y/0/ZojTMJwKdAgeU7VBCwxvLHQyunDMf2h9eJA9UmiDgN4Yj
ns4D95LPxfegAhy09Z9IdZijU+FuWSRV8KXn28Ez7jl+3lYvtNnob98OBWdvgEdu
kDZAmVWe/NFRmeB1Ra9uPiXqlbFK9/jjg+r+ozvN6BRvCN3Zh5o221oI5hYu6Zv/
9+jAY/o2uoteph9leN7hVZIN31DX4rC1iB/sqdqTrwqO0lGfIotmYJxVuYWqev/l
9XDK+li43xt335Uyu9vaBr5+farfpJ3QO5y+G4xJH0mR5DiJnw4GHn9ds8jBkc49
eGfusMAZBaOQ2mPmP5zR
=Mm4l
-----END PGP SIGNATURE-----

--7LcHW5enrYT/B6h/--
