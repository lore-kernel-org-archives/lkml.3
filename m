Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaIMQgd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 12:36:33 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39320 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaIMQgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 12:36:31 -0400
Date: Sat, 13 Sep 2014 09:36:13 -0700
From: Mark Brown <broonie@kernel.org>
To: Jianqun <jay.xu@rock-chips.com>
Cc: heiko@sntech.de, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, huangtao@rock-chips.com,
        cf@rock-chips.com
Message-ID: <20140913163613.GI7960@sirena.org.uk>
References: <1410568723-21559-1-git-send-email-jay.xu@rock-chips.com>
 <1410568932-21823-1-git-send-email-jay.xu@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xdAuejbAAr3yyIdQ"
Content-Disposition: inline
In-Reply-To: <1410568932-21823-1-git-send-email-jay.xu@rock-chips.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.49.225.226
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/5] ASoC: rockchip-i2s: fix registers' property of
 rockchip i2s controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xdAuejbAAr3yyIdQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 13, 2014 at 08:42:12AM +0800, Jianqun wrote:
> Reference rockchip I2S controller TRM, modify some registers' property
> I2S_FIFOLR: read / write, but not volatile, not precious
> I2S_INTSR: read / write
> I2S_CLR: volatile, register value will be cleared by read

Applied, again this is a bug fix (volatile and precious being wrong seem
like bugs) so should have been earlier in the series.

--xdAuejbAAr3yyIdQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUFHJ8AAoJECTWi3JdVIfQOOIH/1RYoC6gaC3D0a+Kshwm+JYZ
pZsZvJyMY6oysjfBiEUixjO7IdDjV4+lwkkQek4SGhufaZInl3jjXYp5+EyKf1Ex
bBufOUQVpzb42URFVTH7kKSlhj0Z6h1CzuUBYI5VQTEuraqk2VIqi2dt2tzCVQm2
uLisentGQ0lRfizGprfoI0GuqJGGCjkP9tfp5ivxP+tCaiGj/swTakFe3wuYDy2A
HLq9ToE3md7IyiQbLjueRq4vSmLjz14IYMmlTh+AXY3PeBGzGdIUcBJIbmC/KqWx
wwzCY6a7qzF2Gd0U4hIGIVwauaIp2t9vhhAYZSZJNyDKQf8z8vg9cYfwcwJrMrI=
=Ra7Z
-----END PGP SIGNATURE-----

--xdAuejbAAr3yyIdQ--
