Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaIMQip (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 12:38:45 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39350 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbaIMQin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 12:38:43 -0400
Date: Sat, 13 Sep 2014 09:38:24 -0700
From: Mark Brown <broonie@kernel.org>
To: Jianqun <jay.xu@rock-chips.com>
Cc: heiko@sntech.de, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, huangtao@rock-chips.com,
        cf@rock-chips.com
Message-ID: <20140913163824.GL7960@sirena.org.uk>
References: <1410568723-21559-1-git-send-email-jay.xu@rock-chips.com>
 <1410568819-21671-1-git-send-email-jay.xu@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcLgruZUVNEEX12n"
Content-Disposition: inline
In-Reply-To: <1410568819-21671-1-git-send-email-jay.xu@rock-chips.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.49.225.226
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/5] ASoC: rockchip-i2s: fix rockchip i2s defination more
 reasonable
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcLgruZUVNEEX12n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 13, 2014 at 08:40:19AM +0800, Jianqun wrote:
> Fix SND_ROCKCHIP_I2S to be more reasonable - SND_SOC_ROCKCHIP_I2S,
> SND_SOC_ROCKCHIP_I2S should select by audio driver, instead of
> SND_SOC_ROCKCHIP.

Applied, thanks.

--HcLgruZUVNEEX12n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUFHL/AAoJECTWi3JdVIfQJKwH/2nMzzZRyd5T5SHRcdmMuHHS
i3A087dfRr9FQvxiqmdxzw1f2dANqoScqDs+KZg+ASofPoBMjWUwvqkhW59plPGe
mRtwUSs5j6Ur0YFC3DUgl9NOHh1FWA2QcnDy9U5DONukZp8OfV7daRm5Am7o66I9
55i9Brrfv/Wk4KBIsWa+9C8Ij1Q5XkL8h+zh8b9KOU9RpOlvbAh9XplfynAoJGwH
i1d810ZQDYOlzKCqcW/3lXe7MuMafGzhloZ+JD1QvHDNyagbq6Y7OU5MGXdEjF1H
chtCZGiCJip9K4SwizqPgKtIepPTiJV9HaZUKj8qJFwPRi2V0vcj6/ztREZhDME=
=YJPi
-----END PGP SIGNATURE-----

--HcLgruZUVNEEX12n--
