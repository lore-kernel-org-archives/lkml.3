Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbaIMQiz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 12:38:55 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39358 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbaIMQiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 12:38:52 -0400
Date: Sat, 13 Sep 2014 09:38:35 -0700
From: Mark Brown <broonie@kernel.org>
To: Jianqun <jay.xu@rock-chips.com>
Cc: heiko@sntech.de, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, huangtao@rock-chips.com,
        cf@rock-chips.com
Message-ID: <20140913163835.GM7960@sirena.org.uk>
References: <1410568723-21559-1-git-send-email-jay.xu@rock-chips.com>
 <1410568898-21773-1-git-send-email-jay.xu@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oNVW4gaiVGQBzhrj"
Content-Disposition: inline
In-Reply-To: <1410568898-21773-1-git-send-email-jay.xu@rock-chips.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.49.225.226
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/5] ASoC: rockchip-i2s: add dma data to snd_soc_dai
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oNVW4gaiVGQBzhrj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 13, 2014 at 08:41:38AM +0800, Jianqun wrote:
> Add playback/capture dma data to snd_soc_dai.
> Test on RK3288 with max98090.

Applied, thanks.

--oNVW4gaiVGQBzhrj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUFHMKAAoJECTWi3JdVIfQHiQH/1kSmEpRRSJZmMgvyQj1k6ie
B4Rad4ujsWbWnqaR6y8A8/Qdf8t1rXqjOaALFGlyERFqA7jHjnVtDQBEvey+uxtI
KdsAh9UlRtWWSk0lUqHkDKOU1d+1RBiUXbFps4UO9Pf/diD7kUo3cW4erUv3JkSW
QZRBkC8gCMHtfUtMB6BqRI/Iw3mSEV9MOAA+MG/6YEDbnwzcPc1wlIYU+vgjt6QZ
KCuUJCHMZ/DY42tWValePpbbobYkahYz3bDaJxJkhB02eAQVuKFKOqtM3sNLSuzb
jK31ybSJrxjrZOjyQX014cGxmLbotbIACGQLsZUIiXZNAlIbeO/xbGXK9CaS1RY=
=TXwI
-----END PGP SIGNATURE-----

--oNVW4gaiVGQBzhrj--
