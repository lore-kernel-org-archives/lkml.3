Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbaIPXT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 19:19:27 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46380 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbaIPXTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 19:19:25 -0400
Date: Tue, 16 Sep 2014 16:10:12 -0700
From: Mark Brown <broonie@kernel.org>
To: Heiko Stuebner <heiko@sntech.de>
Cc: linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org
Message-ID: <20140916231012.GE7960@sirena.org.uk>
References: <1410895374-18367-1-git-send-email-heiko@sntech.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tJbPEdXFtLQcWY9B"
Content-Disposition: inline
In-Reply-To: <1410895374-18367-1-git-send-email-heiko@sntech.de>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 0/3] regulator: add support for syr82x to fan53555
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tJbPEdXFtLQcWY9B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 16, 2014 at 09:22:51PM +0200, Heiko Stuebner wrote:
> Silergy SYR827 and SYR828 regulators use the completely same i2c interface
> as the fan53555 regulators - only with different voltage ranges.
> They are used in a some Rockchip rk3288 board designs around an act8846.

Applied all, please use appropriate subject lines for the subsystem.

--tJbPEdXFtLQcWY9B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUGMNQAAoJECTWi3JdVIfQWjsH/1FtHPyRoZPpYBXrQs0tgAWY
AKAuuqDMSIJU6d4Ko8kkvwoJP6MYK/4vy9y/YlTyyidqZN/WyJIE8EsoEaFz7CPt
gsOc0t73OrvhZij/UnAYyAmZwLiE5ZQQc0IFnkl8XMmdiLktkCaj3lYICq0K6LgL
o5p+HYIoAa87hzumQGUs2uz40PApKNCo9YFstxJZEpDotPLLCy/BpY0gtwC+QQxB
AM22haInBv4JuEz1HwY8EQnHdvfj5qG+0K/jPmCbslwsbewT3lQzWV+o4RiKmtFj
EhI8D2QBgWFQHEa7Dc2msd7/c50/WlxJ+LLtyDd7cfJKaTOqoXprLku3qDJGfCY=
=Es1U
-----END PGP SIGNATURE-----

--tJbPEdXFtLQcWY9B--
