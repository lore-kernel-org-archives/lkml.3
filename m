Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbaHTPcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:32:32 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51136 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbaHTPca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:32:30 -0400
Date: Wed, 20 Aug 2014 10:31:32 -0500
From: Mark Brown <broonie@kernel.org>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: heiko@sntech.de, dianders@chromium.org, grant.likely@linaro.org,
        robh+dt@kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, olof@lixom.net, hj@rock-chips.com,
        kever.yang@rock-chips.com, xjq@rock-chips.com, huangtao@rock-chips.com,
        zyw@rock-chips.com, yzq@rock-chips.com, zhenfu.fang@rock-chips.com,
        cf@rock-chips.com, zhangqing@rock-chips.com, hl@rock-chips.com,
        wei.luo@rock-chips.com
Message-ID: <20140820153132.GY24407@sirena.org.uk>
References: <1408506462-3686-1-git-send-email-addy.ke@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6Jy4/gb9ZgnsEOX8"
Content-Disposition: inline
In-Reply-To: <1408506462-3686-1-git-send-email-addy.ke@rock-chips.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 63.139.182.64
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/rockchip: fixup incorrect dma direction setting
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6Jy4/gb9ZgnsEOX8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 20, 2014 at 11:47:42AM +0800, Addy Ke wrote:
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>

Applied, thanks.

--6Jy4/gb9ZgnsEOX8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIbBAEBAgAGBQJT9L9QAAoJELSic+t+oim9ZIIP+NzHME0U9O4Ork3bB63pU4+a
BHIiDPeJWndMIj8JtOs+oVpp9kooZJHGW6WuiwvbbkIwh2SbKwpCfM2ERyUvANNt
NSSIzY/wp2+PQlUkWgowm2NOjoCzNq+3q8qsQSIA/IcaqoJ4LCZyc+hFaXECO8SN
N0wKy3ijhi5kmTDz8ZQKiDQcBNGM6OcC+QPCI3TsJV6xcgnVaa61t3D8XSK3oAvj
3YRMwZ/JBpss1nlFBCy0sWIgoWDxi8WTuvhbzo51Yc2TCSpBCYj2hJ60BcHvLJ3C
HDXd/uTA5MNtsBpPEwdFm1w0SnOc5lyxc+0BDLR/4H70Dc/1CgiTwN2yWL37LLcu
qMHEFETd5X4UAcP9y9Ue95IwZvpvdt9G36u9KzSCkP7fxCSW69mc1j0+Hfdx4R9M
YV7/zO841X5H4Sd6038DZzH/LpejDvkNzxZpQ1GIm2wXFJuNNp+U4sEXLENeV0RF
94yiNjJk0eX6Jr9eCazsUX9ys5aROuoRcywxh33KakfIhIkXvtGvi3gklYNMjxOR
zjJq+UtVfJpgH6ltLvHnXA/jf0aRBzxCqS7LVphOUEtemlZDBaLYzv4SsXCrSv4J
TpyzGs0HCqhNK8HEtYPk+5kCIRjC7fHD8+Uwjj49IusMtMWczDMpW/O/7ttFxbzq
WZk+5QsHYs8wbaWlkZ4=
=Dua5
-----END PGP SIGNATURE-----

--6Jy4/gb9ZgnsEOX8--
