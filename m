Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161112Ab3BGSqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 13:46:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44724 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759263Ab3BGSqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 13:46:16 -0500
Date: Thu, 7 Feb 2013 18:45:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org
Subject: Re: [PATCH 01/49] regulator: ab8500: Further populate initialisation
 registers
Message-ID: <20130207184549.GA8879@opensource.wolfsonmicro.com>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
 <1360148051-7560-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <1360148051-7560-2-git-send-email-lee.jones@linaro.org>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 06, 2013 at 10:53:23AM +0000, Lee Jones wrote:
> This patch supplies access to some extra settings provided by the
> AB8500 regulator device. We also update some of the existing
> initialisation values in accordance with internal ST-Ericsson code
> submissions. This single patch was originally a collection of updates
> which have been squashed together to aid with clarity.

I tried to apply this but got conflicts - can you please check what's
going on with this vs my topic/ab8500 branch?

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRE/ZVAAoJELSic+t+oim9z/kP/iZ7KKMjLXDRaFyzsMbPUPjq
Bv3eZG5woq5HLx/78sEhahWZa9qoiwtcBw+ZRqLO+8t9YW8XiuXxd4tV5cFQFzeK
2VYSisJcARxM14r1PivYd3lqJ73SxotWkvCKLZmwMFIFn+32wMPgEdekpzMe+Z6T
LCH4paoKrPKvNoDWGz4IX0Ilbvs7W7wDRvTCYDY47kgrJ8TO82z+pRkjlpHQ7gqO
hxN/SFk4ksyOR7UcvOK5qUpFWbBKcG7xehxSVDF4VS00y1vwS9LxfGrcT+XtgzGC
rEBbTWTJcgbsDSOgeAOvrIy4MR31SLRitbqAifRsOukIdmI7dvSC6BFTsUSZ1GYa
TDPcnX44IAPUgJnrBMwbpzMA7BBXNJ8DJLOoZZ90L+bKU6PZf7y+OnFiEHiV340T
DDnC510Pd47YY5UET+ByvvylTvKD2y45n8rvR76o2X/JBA0l8NMoSaGAbvinXDJD
3XMtMpCI8mx++K8wOQwvfWvHg/rMhZUacILecIhqCm4k0ByqJR49Fd933YlE1CSU
Id8fVY340RMnoOVLMZvkp0lbdWg2YoNWfm/tSP9retzHC+vkbFMM8WZhnKFzYxU3
ACHjgNpkodkoWp3JUahqcsahS+lHeA2GRhm+K2we32mKBwL0hUyO+2ggiswrDmnI
/mSYcAOl7w3RVW9VyLlR
=guVU
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
