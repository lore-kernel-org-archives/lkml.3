Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaCAE3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 23:29:16 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53918 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbaCAE3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 23:29:14 -0500
Date: Sat, 1 Mar 2014 13:29:10 +0900
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lars@metafoo.de, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140301042910.GQ29849@sirena.org.uk>
References: <1393578267-18255-1-git-send-email-Li.Xiubo@freescale.com>
 <1393578267-18255-3-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Tcb1KvpfnM4LxW2s"
Content-Disposition: inline
In-Reply-To: <1393578267-18255-3-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.126.181.238
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2 2/3] ASoC: io: New signature for
 snd_soc_codec_set_cache_io()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Tcb1KvpfnM4LxW2s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 28, 2014 at 05:04:26PM +0800, Xiubo Li wrote:
> Now that all users have been converted to regmap and the config.reg_bits
> and config.val_bits can be setted by each user through regmap core API.
> So these two params are redundant here.

This looks good.

--Tcb1KvpfnM4LxW2s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTEWITAAoJELSic+t+oim9gRwP/1Yi404O5ZBUVngd1k0fTn1f
DZEYDZxdF9ERDFKSqcmjQGAgzd4VzP7zSeTyl0vEu+Fh0KqzIfBuxjKiIK/6/yWH
zwWMwfQlnn0ajbyGC2srBCzCA2jpPAdkEj2JYCe0mEkNZZov82A/TKKJdfGMGXNu
71W0rpEyx+9SANAEccYO89ZFY0KVgQ5i3UZPDsPoYBk5Q8HmSQjMDxN5yFb4FI16
hon4WUjq0QFt9dtrKSZE0qHbKo6HZDaQ/JgbRe3D4rUlD2624xHs7DPKDGQWtTr3
w6oSMvF13UenamjyWAABOc9tTfNX7DpE1qBqINl1PWkN5l+kn3muLD/kRCeakU7Q
ey+dBYuPYajiTKLCOAeasKH/1yfBZSDIhRveTPO/KNX/7yIXPYDmQXsRbjBTpEYC
eXJ6c8h/NhPmKqYLHBSr0LZDdKZL1UIyPhi2sE1nZxzSE7Q515yebSOFO9y0PGhu
HmjKiVL99GZr65Ga9Tne4MY68X6H+Aar5zQ9PrZjoYDwWfleLbq6mKckt1Go3Lf8
M6Cw/X9zE3BwWBkP6cWFNSYtxi7KO8Laf5iafisS982cBIGsA1N2ws531pP2XdM+
JNywxWHB/CFt/7uXbITLRpjk8X4RTjAF9bf2qauKh+PkYFa7hmQLxtkTwp9cAZyE
WMY8caADLrvVarEImu7m
=EtCU
-----END PGP SIGNATURE-----

--Tcb1KvpfnM4LxW2s--
