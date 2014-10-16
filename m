Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbaJPKGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:06:32 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58296 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaJPKGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:06:30 -0400
Date: Thu, 16 Oct 2014 11:34:40 +0200
From: Mark Brown <broonie@kernel.org>
To: addy ke <addy.ke@rock-chips.com>
Cc: heiko@sntech.de, dianders@chromium.org, grant.likely@linaro.org,
        robh+dt@kernel.org, amstan@google.com, sonnyrao@google.com,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        olof@lixom.net, hj@rock-chips.com, kever.yang@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, zhenfu.fang@rock-chips.com, cf@rock-chips.com,
        zhangqing@rock-chips.com, hl@rock-chips.com, wei.luo@rock-chips.com
Message-ID: <20141016093440.GC2200@sirena.org.uk>
References: <1413372311-4203-1-git-send-email-addy.ke@rock-chips.com>
 <1413372378-4309-1-git-send-email-addy.ke@rock-chips.com>
 <20141015130547.GE27755@sirena.org.uk>
 <543F8F2A.9040904@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pAwQNkOnpTn9IO2O"
Content-Disposition: inline
In-Reply-To: <543F8F2A.9040904@rock-chips.com>
X-Cookie: Is this really happening?
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


--pAwQNkOnpTn9IO2O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 16, 2014 at 05:26:02PM +0800, addy ke wrote:

> The following changes is nessarry:(if tx complete, spi must be disabled too)
> diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
> index 153269b..87bc16f 100644

Please send this using the normal submission process.

--pAwQNkOnpTn9IO2O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUP5EvAAoJECTWi3JdVIfQCXQH/RU6JwnyaxOhvqyazCG1SBn/
mAWJ2EyFc+hhm1ao/caDwG0TKP1HXS35JbflhETePYeTaiVvmG7RDRvsRXDHe/qi
G6vWXcxdalH3tcCES+CUAbFcW1RAgbUjlWKjIOGB1Z04F4x7OusdRoqQZhKCMr9D
OhEFP0z3iH3s8ET4hPUw1vv4HzNFVBrndSZfGKi7KCUPpNAseplII49ZigaFC8KX
4o86FWM0qJt9wy7y2VHQxYXaapjoYeHiAyEmT6dfAYsQE0yNmaXoNo2OWvYiv7HX
wT+Zpo4goW4ZVG40AwLIyqmhBMWxn48X4MfFU/ieLGJa+mpqWoJ6eokYYuv7dL0=
=mqAw
-----END PGP SIGNATURE-----

--pAwQNkOnpTn9IO2O--
