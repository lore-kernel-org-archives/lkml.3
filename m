Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761255Ab3D3ScI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 14:32:08 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45276 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760851Ab3D3ScG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 14:32:06 -0400
Date: Tue, 30 Apr 2013 19:31:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Message-ID: <20130430183143.GD26160@sirena.org.uk>
References: <1367330994-7259-1-git-send-email-fabio.baltieri@linaro.org>
 <1367330994-7259-2-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4zI0WCX1RcnW9Hbu"
Content-Disposition: inline
In-Reply-To: <1367330994-7259-2-git-send-email-fabio.baltieri@linaro.org>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] ASoC: dapm: use clk_prepare_enable and
 clk_disable_unprepare
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4zI0WCX1RcnW9Hbu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 30, 2013 at 04:09:52PM +0200, Fabio Baltieri wrote:
> Update dapm_clock_event to use clk_prepare_enable and
> clk_disable_unprepare.

Applied, thanks.

--4zI0WCX1RcnW9Hbu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRgA4MAAoJELSic+t+oim93QEP/1IfIwBI0We9zslG2fywezxl
Iv+4ZAGFvcWflNjSg/stsbcTjXrofApmb/u4E1MVEnFYliHKlx/5xAwJfxbMTinW
/EAl8yWNDKijhh5LWK5QiTZSg5MX987VbWCdyRWzt+boXqJ4QCCfb6HiicKmqt0r
3r7ptwx/KoHeF/7ZI2ZuvAdEgMzo6n7e+fil6rTDhRI4kYN0W4v3DZsOwLLsvcS3
V+bAvW5Sk7WMEULflnQUDq8d3u5WBZDNAmicFkPErf+YryS1aBsvDukLJQ74JTFY
3/jV79IAmhvCqYTW6NQeEmpCmScAGDosIj2sX03Fdses6HGrE7x7qdCbVeE6h8H/
rP7htwK/uTsiLEbDo+HNuICLn01Y+jKzDpyw5uX/DYPNvUuMfwkyqFq148XGbLmv
lT67sIXYwkJ5tI4Uy33AYgjPFBOgN+bIg2YgReWH/J1huptREOKe2AyXoWMj/twK
Nk6TETk1Uh2v32Trpj4yOVQ4hhXrHpCIymujBjaZE7WqfrzMpjkbyfQJP+q/tunj
kswy/xp2xZwUn1950jg9rl69YoJqjHgyJHQRaPCv8hDVzc6WcBYpTvDSM1oP+hSJ
OORbwjVRmJSKrPRcblz+dn2mXniMjpZ8dmgxvWuCFXWzopbCsShnIuBIY034bfWF
38AJtTjT8cMjOPFK+qnd
=wnn8
-----END PGP SIGNATURE-----

--4zI0WCX1RcnW9Hbu--
