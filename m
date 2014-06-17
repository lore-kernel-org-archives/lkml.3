Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086AbaFQOlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:41:20 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45981 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932873AbaFQOlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:41:18 -0400
Date: Tue, 17 Jun 2014 15:40:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Xiubo Li <Li.Xiubo@freescale.com>, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140617144047.GT5099@sirena.org.uk>
References: <1402679968-5925-1-git-send-email-cengelma@gmx.at>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Mcvs3sMuhDlWUu+I"
Content-Disposition: inline
In-Reply-To: <1402679968-5925-1-git-send-email-cengelma@gmx.at>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: wm8985: Remove unused pointer in wm8985_remove()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Mcvs3sMuhDlWUu+I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 13, 2014 at 07:19:28PM +0200, Christian Engelmayer wrote:
> Commit a0b148b4 (ASoC: wm8985: Use devm_regulator_bulk_get()) removed the last
> user of pointer wm8985 to struct wm8985_priv. Thus remove it. Detected by
> Coverity CID 1222150.

Applied, thanks.

--Mcvs3sMuhDlWUu+I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJToFNsAAoJELSic+t+oim9spoP/3IrTBbUxknKlWLP2x5kxTr9
fnfqHBIM5zr0NHiXCPYAJPO6D1p2eMRTjNoinkimMNn73Yp/EKVX7zNWLrVbZba6
koEnty9O/4t1BkW6ILLLmeN8Lj5Xk7UJXoNJbda9jna+dl8pqKVIasE2PVY9OOx1
bxAkmCUuGD197wJ9+MdSm/xgHffZ4WkfFRcA93ZddomCu83C6BAEC2Hcs3/dCdnD
7emFpPHMeKzn+hu7pMjp1HCvLUmH48EdPpGMJ8/slZ6Z9gBy4Sig/Ebi1d4IuZu9
jAJ8XPMJtfiD85w4gIUFGmuy2K1e80eHfMJmejGQ2jHzSIYN3y5PWFXjs1/zsW1S
jChs/tYelSsVN9Fu2S+YXRLgpT7crsMR940Z9jQshmjEySmxIB1/raxsBW21uGYj
yJUf6HRQ2UinxtqI15eAJj7CT852MmzXjBvo+lUIcgrR4X8b+YyaaS8Iy67VPKkb
G5E9B0+HLbN/IvIT2sExrHDmAsPEvBK/b7AbCLkr6zhwuNCmm1VcjQTc26el58ZF
bqEg8HTsArbGD3bzT0D1cXAvtOS1S67gioEuckJWHnlLkVPUbY/dW8G5Pn+YeTyi
6VtqzUXcrtGO489ttWXcMAMAU6sJie1UZMHphAE8sfydX9OOktLQlCQ4yHpf3D3X
8HnWADE5kWV5VOdB9mhq
=gN7M
-----END PGP SIGNATURE-----

--Mcvs3sMuhDlWUu+I--
