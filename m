Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbaHROzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:55:11 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46955 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaHROzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:55:09 -0400
Date: Mon, 18 Aug 2014 09:53:25 -0500
From: Mark Brown <broonie@kernel.org>
To: Shengjiu Wang <shengjiu.wang@freescale.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de, nicoleotsuka@gmail.com,
        Li.Xiubo@freescale.com, shc_work@mail.ru, fabio.estevam@freescale.com,
        xobs@kosagi.com, arnd@arndb.de, sfr@canb.auug.org.au, timur@tabi.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Message-ID: <20140818145325.GC14537@sirena.org.uk>
References: <cover.1408350626.git.shengjiu.wang@freescale.com>
 <b1711ff2c73f3b6acd6af000bc8294d930bbf16b.1408350626.git.shengjiu.wang@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j6zkAHxOZJkiczrA"
Content-Disposition: inline
In-Reply-To: <b1711ff2c73f3b6acd6af000bc8294d930bbf16b.1408350626.git.shengjiu.wang@freescale.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 216.80.64.155
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V1 2/3] ASoC: fsl-asoc-card: Fix build warning for
 maybe-uninitialized
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--j6zkAHxOZJkiczrA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 18, 2014 at 04:38:39PM +0800, Shengjiu Wang wrote:
> When build fsl-asoc-card as module, there is following error:

Applied, thanks.

--j6zkAHxOZJkiczrA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT8hNiAAoJELSic+t+oim9vtEP/066v1JvRkbibj+F5sRs0ldE
p/hv3zajZVFM24ZRpA3ougXhZ+BC+L9a8X/dt0joWHuEwwEL187RxuHGdEDaUddC
mMpu8SmfaIJ77GimPIKs0Xl2NQsMgm4ZblzN/jgNSTJt9Z1ZWy/b3YysujpDHPHR
jgemxvDRwE55C5WkKLDgZMqjGWB24xgy5v8n4wOqK9eJ1uxjjEjBwMlun5I/5bqS
RoM2XQXxY2N+SjAh83hVyd+EUg+T6TwvNAzKtp4YigRD0wgZmuuIyw8xN2cc7NDO
/M2QIye95ewb2OaNrItkf8FCP+CNVbXLxoXeNBVuxSREmRt6SNPCWySBOm8cjwRZ
1lpHYWUp3EnbA15xjRXBB4jVi7wzdrJO5WLzFa/s0INbUsKVeuF9slC5AjFG0rjs
Kz+c2i0iPxxDWJ1Cc2mEfuFKsAY2R9RoQe/FRqkvZqvvWJ9vGh2wEE/fo78+pO+p
lyK3T9DixQB1Tv2R8wYf74oF/sG/s1fcrbhaRFqap3UdMVLHtsyUeA/2mP6XgSYv
dIgXpIRXBYfXZbkzHewhT8avRadehuZpDQxHoOE7GYI/LOCzORjNeLmw4DY/pHIR
AQTfNxKbNAHq+kbe7HBs5KggpCIxtwneuD3ndIVEq4TxXwdUFktLG2ij/JFDGQ7b
vU4LUyGW+7dpC8ZUTGmE
=VtEb
-----END PGP SIGNATURE-----

--j6zkAHxOZJkiczrA--
