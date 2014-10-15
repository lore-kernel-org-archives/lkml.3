Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254AbaJONG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 09:06:57 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56035 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaJONGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 09:06:54 -0400
Date: Wed, 15 Oct 2014 15:05:47 +0200
From: Mark Brown <broonie@kernel.org>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: heiko@sntech.de, dianders@chromium.org, grant.likely@linaro.org,
        robh+dt@kernel.org, amstan@google.com, sonnyrao@google.com,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        olof@lixom.net, hj@rock-chips.com, kever.yang@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, zhenfu.fang@rock-chips.com, cf@rock-chips.com,
        zhangqing@rock-chips.com, hl@rock-chips.com, wei.luo@rock-chips.com
Message-ID: <20141015130547.GE27755@sirena.org.uk>
References: <1413372311-4203-1-git-send-email-addy.ke@rock-chips.com>
 <1413372378-4309-1-git-send-email-addy.ke@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YGrZF/eHoPhUd1nD"
Content-Disposition: inline
In-Reply-To: <1413372378-4309-1-git-send-email-addy.ke@rock-chips.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] spi/rockchip: fix bug that cause spi transfer timed
 out in DMA duplex mode
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YGrZF/eHoPhUd1nD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 15, 2014 at 07:26:18PM +0800, Addy Ke wrote:
> In rx mode, dma must be prepared before spi is enabled.
> But in tx and tr mode, spi must be enabled first.

Applied, thanks.

--YGrZF/eHoPhUd1nD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUPnEqAAoJECTWi3JdVIfQZrUH/jLADsi/+19f2WDcj5hK3jK1
GK+w5iwhHmLMkWGfWJh0KDoQrSPq3Z3W34TJP9dAv2svwmfGI0NFr5A/sj9R2YKu
GPLxuycb3gv7Efg/t9Yr3jXXtAqfvJuuCzz1KUFyiNnCrJMrKjpYKLsltR0cCDIq
IS1MTwMH0RzowBBhwvvE6FJSe9BOUlyjt3jYlj+dtHIxNC+NC6uBKgqqRLRDT5hl
jLNyA4SF1j5GwSIN5Wz3m4GlOCk4i3ha5LPU3ZvS0GBKloVQbhfHevxzgz9XVOzr
ehps6hYseb47G9KvUoYmU7ECJYJTXznsNzvkJNtvhxeyzOaNilwZtD2zzhIuniQ=
=kNFe
-----END PGP SIGNATURE-----

--YGrZF/eHoPhUd1nD--
