Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbaJQMas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 08:30:48 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33159 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaJQMaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 08:30:46 -0400
Date: Fri, 17 Oct 2014 14:29:37 +0200
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
Message-ID: <20141017122937.GK1820@sirena.org.uk>
References: <1413510253-3519-1-git-send-email-addy.ke@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mZBmBd1ZkdwT1ny"
Content-Disposition: inline
In-Reply-To: <1413510253-3519-1-git-send-email-addy.ke@rock-chips.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/rockchip: spi controller must be disabled in tx
 callback too
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mZBmBd1ZkdwT1ny
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 17, 2014 at 09:44:13AM +0800, Addy Ke wrote:
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>

Applied, thanks.

--5mZBmBd1ZkdwT1ny
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUQQuwAAoJECTWi3JdVIfQmn4H/jutDQY3t8Ck34xwvUpl1tbr
ttypqQoJHVRBQKcfabAO8GH3caU246mIwQ43SgpBHAE0oQZh3CaGuUmaPNeLy4Yo
JYNb99McbD3EPDWRyBIKaZUIAjddUOz5NCwH+80v7b4uCHNazM6MO2/UIwjEBtAD
I4cbCHKi/MR7BcaYgDCp6L9KYCWjoBqPwZYKQm3udY0M+iuIIRx6Xz30DiaJ+Gic
6rWBK8R39riv0oH6SQ8zFFdO9hx6TfqA2BDQBjhB0GzWNrX0dHaSNBs/UAxoI6AQ
XIsCss0MTtSmr5morvZ4rb1eNL4w8hr+QEkMvRgyztqJs2mGqjQO4lj//8Y25LM=
=g+oM
-----END PGP SIGNATURE-----

--5mZBmBd1ZkdwT1ny--
