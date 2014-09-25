Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbaIYNJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:09:37 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40368 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbaIYNJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:09:35 -0400
Date: Thu, 25 Sep 2014 14:08:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: heiko@sntech.de, dianders@chromium.org, grant.likely@linaro.org,
        robh+dt@kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        olof@lixom.net, hj@rock-chips.com, kever.yang@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, zhenfu.fang@rock-chips.com, cf@rock-chips.com,
        zhangqing@rock-chips.com, hl@rock-chips.com, wei.luo@rock-chips.com
Message-ID: <20140925130847.GQ27755@sirena.org.uk>
References: <1411628381-4029-1-git-send-email-addy.ke@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rKoHqF+aPLVth8b2"
Content-Disposition: inline
In-Reply-To: <1411628381-4029-1-git-send-email-addy.ke@rock-chips.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.248.7
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/rockchip: fix bug that cause the failture to read
 data in DMA mode
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rKoHqF+aPLVth8b2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 25, 2014 at 02:59:41PM +0800, Addy Ke wrote:
> In my test on RK3288-pinky board, if spi is enabled, it will begin to
> read data from slave regardless of whether the DMA is ready. So we
> need prepare DMA before spi is enable.

Applied, thanks.

--rKoHqF+aPLVth8b2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUJBPfAAoJECTWi3JdVIfQUpcH/jwD1U4mFyYRJ0NxDY7xL/6c
TVWcpXm9CuQPWc8T4Wy/DP6C7z3NRp536fWn2wgIfV5X87aGlRtdqqZ21aI4tnw5
NmkRDu1isk1FplzR9eitLArFZFsUaeMFwHS88H2r+3FbvBfOSo1g80p701ebtVUb
Sso5wMEpuc3pUFIvbVQDmqoOIOS+bJgkYFmqZVPYNHyT7gctj+alznM0PvR28uzp
h42VF71K/1Kw4BQuMER4inc0z06rchMHmkfQJq4l19mfUDsdmyW7KizQM7eKNSc3
npDuiSgT3Whonl+NvDoNsSmZLt5GYSNRsZUWbl3RhHHMJRl2tZASLADVj4yoFxQ=
=x3pf
-----END PGP SIGNATURE-----

--rKoHqF+aPLVth8b2--
