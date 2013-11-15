Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab3KONm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 08:42:27 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54167 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab3KONmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 08:42:16 -0500
Date: Fri, 15 Nov 2013 13:42:10 +0000
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.org, lee.jones@linaro.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Message-ID: <20131115134210.GH26614@sirena.org.uk>
References: <1384521213-27141-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1384521213-27141-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="II8oT75hj15qngTC"
Content-Disposition: inline
In-Reply-To: <1384521213-27141-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 149.254.56.239
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regulator: arizona-micsupp: Correct wm5110 voltage
 selection
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--II8oT75hj15qngTC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 15, 2013 at 01:13:33PM +0000, Charles Keepax wrote:

>  drivers/mfd/wm5110-tables.c         |    2 +-

Send the MFD change separately, there's no code dependency.  Please also
remember to CC all the maintainers for subsystems.

--II8oT75hj15qngTC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJShiSvAAoJELSic+t+oim9bdYP/3g84JS4ZeTl9W/bPabKG9Oi
PdLxfFBbKamxNcWDtW9lk2vKSo5W9dsf9O7qwd5ikvRbhistoWVdBGtEqQ+qI8U+
X6WTPmtHHflbN/+Y13Vy2dO7voFdcUaGdm/O49o2jCyX0e7ifXGD9NlSXmSocvDC
6EjyJ+DqnBMENkHH6Cm9wvhhSbwEX3Nqha/fUWhSa1bJqFUpUpvKLlJFF/ZkmUp7
BZMxVcnj61uvE50CLJmdbF+dhSpBdR42E21xFzwmwtx60lI+GChdUnEfRW2fY/o0
r1eQGjTVqx1bj0nxDexGiYFjK8SejFyrRfGft7NLGfZqSKzL0eUr1EOBbUt+kQWt
3eGE/xt4flmYV6QOvRFFE9YaVqXDgulobgdxFZmfKr1EU/GbAqd+5p4kh7ADfqBT
aurJJXeoX4EJCjcd9z/i2mcqiQRrwdtLCwI7/sgLtCCiyKSkpUeoP+/SbVo1Q6be
c6ay0OJ0NawMMJkSFDQ9nvHm1zGC0BkaxNU9t/U7peL793aWshT8PrL+QvLEcgY0
XxE7LAa6A1xNwoODppQsckqSjInnGWN26YLoW5F3dKRPvClDa44zYi9quF5fotdw
xstpKKUaeEkmMoXdOD3zd3k10QMXS3uO6/2fq+HJYFW/FJqOpDtDnk7yQv/dCKya
eWsn2fyRGZ4YcMyxc1yP
=Ksby
-----END PGP SIGNATURE-----

--II8oT75hj15qngTC--
