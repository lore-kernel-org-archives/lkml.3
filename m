Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab3DLMNk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 08:13:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35232 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752878Ab3DLMNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 08:13:38 -0400
Date: Fri, 12 Apr 2013 13:13:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH] ASoC: samsung: fix neo1973-wm8753 compilation
Message-ID: <20130412121320.GX9243@opensource.wolfsonmicro.com>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
 <201304111908.42532.arnd@arndb.de>
 <20130411171938.GS9243@opensource.wolfsonmicro.com>
 <201304112102.43896.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zAIN9dnKNiFxaW1E"
Content-Disposition: inline
In-Reply-To: <201304112102.43896.heiko@sntech.de>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zAIN9dnKNiFxaW1E
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 11, 2013 at 09:02:43PM +0200, Heiko St=FCbner wrote:
> Commit b2ca78717cea (ARM: S3C24XX: make gta02.h local) already replaced
> the GTA02_GPIO_* constants in neo1973-wm8753.c but forgot to remove the
> inclusion of mach/gta02.h before moving the file out of mach/.

Applied, thanks.

--zAIN9dnKNiFxaW1E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRZ/poAAoJELSic+t+oim9e0AP/R3Lu5s4gScu+xJ0G8nvLVAl
YLNjq7WzVqz5m0gOzj9gYxCTxEnixXm2RvDyjkhif1QbTn68TGtWaxaiADOzwtEu
c8BVVUGs/77WZhIBZj0rYLeQCO0W+46LmImbQXf5buToGxJzF/wEvdWiYR9HYOjU
8assej7avGF4oDD2CjmmVxH+v35ygZmvKTb8nvx2aBiAHVuELnHfN0sM8lOYDQY6
jynA+FkNjWUpK0u9agcblyflFHxOEcNpHdgEJk1ANV88FFYyLTjy3VR1hECE6Ha7
jY7I6S2FAhs47a/C4nxmSGCU5Wjpf4Ucrcsygti5Dc01zui5EUTQZjp0sUkG1kcp
OCBqwbV4K39ej0s5rDv0u5LZQEC+HOek1vg5SIwMuLP6wu3ss+W9H7mD5o/BVv2k
7XNEe/myhvIsnNGjxSql1DLlUEDNQjXG6fPezbqgoNkRtWGg5D3FedGuRfmpGQnC
pOuMg2T3bXwXmUrzKVov09fV/sVOR3v5Nxe46ej5YKr0MMDCnYjIq0H4dIz5gg2I
4fCMJMPZzYHgclJN9osnWTqaR6hviGC402mLaP/3rsYVc8DIrSd53thnap/qhPFp
lKxfQAXJIsCm0c2zBV3rUeKqaLwm4Ysj9OKhkiUP0Wp5CHwswwGQ12oqy66Dd8bh
cLOtL0lrcYb3ccHLEDMJ
=bWTJ
-----END PGP SIGNATURE-----

--zAIN9dnKNiFxaW1E--
