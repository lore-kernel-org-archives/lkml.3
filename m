Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbaA0Tu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 14:50:57 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60205 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbaA0Tuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 14:50:55 -0500
Date: Mon, 27 Jan 2014 19:50:46 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, kuninori.morimoto.gx@renesas.com, rob@landley.net,
        perex@perex.cz, moinejf@free.fr, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Message-ID: <20140127195046.GW11841@sirena.org.uk>
References: <1390549386-4702-1-git-send-email-Li.Xiubo@freescale.com>
 <1390549386-4702-3-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GdlkuMH+DRYbUHkj"
Content-Disposition: inline
In-Reply-To: <1390549386-4702-3-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/7] ASoC: simple-card: simplify the daifmt code
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GdlkuMH+DRYbUHkj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 24, 2014 at 03:43:01PM +0800, Xiubo Li wrote:
> In the asoc_simple_card_parse_of() will parse the device node's CPU/CODEC
> DAI commone fmts, and then in asoc_simple_card_sub_parse_of() will parse
> the CPU/CODEC DAI's sub-node fmts, so we can combine the info->daifmt and
> info->set.fmt in asoc_simple_card_sub_parse_of() not while just before
> _set_fmt().

Applied, thanks.

--GdlkuMH+DRYbUHkj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5riSAAoJELSic+t+oim9RiQP/2Yer6UBGBm2QB+DoPtYmM2f
q2sKMAStrklSRBeAV6gfViRp9A8Lu7uC5Gpj9GXAbD9fUaS5p1+PwHokBlyNtja2
M8zZavu8G7Xof+kNK4/pKken+SRkbK3IA5Luk1CwVhpnvFQf4+DMUdUwh5F7i3oY
V0SGH7JnwpfVXeZA7wB9ZPysnJZ3vCwKcwd3J8CDGGIP2gZXfUW4EaLZQl/mtRab
OH4UVMyZqToHPrBtM6grJGvsnRtEDLwVdryMEhcVl1zRll7m3CrTzvdWmh8kLund
nwb7KLezQdqIYDLR26rQW6af7BXrp01/F20zHVXBthEGyFxgFeYymuXOV8fJfRuh
MDjDm1XXwCGnmczksmANufpZ2Kz6l37OLSRh/lhJTlJrecyuSmwKtTV0Bfgze7yi
3FY7xDQyWYH32OrP0C5WrwHnNdLmUOL8kMpcRTyfdqcyo643HJYyQETVaOikcWtu
j+j4KySCdF1mr/3QeRmLyw55v6CXg0PI3Zdusulb8/Hj253Tuoj34oFC9n24z8oO
Wu0e1BunUxhOHAdIE9Jtkx6y22Wm098BeyzRKiiN5dkp3T7Mx4lZckktBe+rzKVh
GmIgCUr4Y9LbU8alV7511UWpQ2hzflSVIDuso+GUN/F8x1rEMKmbR7pGX+HcCrpO
29pLxY2eDhg4JB5TlP1f
=AoO8
-----END PGP SIGNATURE-----

--GdlkuMH+DRYbUHkj--
