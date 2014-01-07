Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbaAGPjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:39:16 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48376 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbaAGPiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:38:51 -0500
Date: Tue, 7 Jan 2014 15:38:46 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, alsa-devel@alsa-project.org
Message-ID: <20140107153846.GQ31886@sirena.org.uk>
References: <1387468508-12286-1-git-send-email-lee.jones@linaro.org>
 <1387468508-12286-9-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kpK0GMZn0PGAhZX2"
Content-Disposition: inline
In-Reply-To: <1387468508-12286-9-git-send-email-lee.jones@linaro.org>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 08/11] ASoC: ux500: Store DMA data in the DAI differently
 in the pdata and DT case
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kpK0GMZn0PGAhZX2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 19, 2013 at 03:55:05PM +0000, Lee Jones wrote:
> In this patch we do two things. Firstly, instead of open coding the
> store of DMA data in to the DAI for later use, we use the API provided.
> Secondly we create and store similar DMA data for the DT case, only
> this time we use 'struct snd_dmaengine_dai_dma_data' which is provided
> by the core for this very reason.

Applied, thanks.

--kpK0GMZn0PGAhZX2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzB+DAAoJELSic+t+oim9uD4P/i4nlCRl0R/PxtnZiudmDoaW
bRFrjZPgUJhG9HG+zmIbKp9OjqRZPKbkldSWlCq8h2icSgreiqgL77V0DMs4CFip
MltSSDpwiPPZ8Im3ZP1eXXhyfWTGd5vfBVSqFf4fOsvOHg1rMEwnaR2NJUUE80z0
MQI3fnzjQWzxYY9SRTsXhz+4cbHUbRa/yg7sV+bk+Ukc2A/8C59aq3T5TKxbouF8
6EbxdHZb1frPE2VMa/h8iJL65KEHUfywj1Po8Ap2BMRKVZuAWVX/Cx9qiBpudB4O
JQaR5rCPsF3fns/kRJoGBTETuunJEUcW3/JYSMnU74BNE1LW/ZCdaXAqkpbZ9TxA
Drkv6VpBfmctR3CDTZdBYKvxpuEqLl2sOUD2xcXUZweqMjjcpBdeng9Ut7/DVsWw
RcBB5KslYa7dceFi7SXDu1il5cVNE2E0RrNlGmxpUSqMTmwRi6mBwS9byOzWNm5N
Eh+ZJPAKxqhrG/rBN9YSBmUR4zaDV31n1qaHcVkehZFEoBHlRwoGzjCSlO9/d5oO
MVcTI2ZlHT8RtaiEvSkRZb735zt0PiWhm+mtg94SFH5QrX+eWm1HdOLIoli6WVdN
D6/xHeit+675WBSkLoKDnUTRe/HvQ494OeFql3dnF/umDbZjlWqAhSk5w/62hMWH
hlhZMxo1dQwlI7YnCZ1v
=gxnr
-----END PGP SIGNATURE-----

--kpK0GMZn0PGAhZX2--
