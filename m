Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965012Ab3DKQzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:55:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40694 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964928Ab3DKQzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:55:38 -0400
Date: Thu, 11 Apr 2013 17:55:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net,
        Grant Likely <grant.likely@secretlab.ca>,
        Padma Venkat <padma.kvr@gmail.com>
Subject: Re: [PATCH 29/30] spi: s3c64xx: move to generic dmaengine API
Message-ID: <20130411165536.GO9243@opensource.wolfsonmicro.com>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
 <1365638712-1028578-30-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T464TalWMPmNXQHI"
Content-Disposition: inline
In-Reply-To: <1365638712-1028578-30-git-send-email-arnd@arndb.de>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T464TalWMPmNXQHI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 11, 2013 at 02:05:11AM +0200, Arnd Bergmann wrote:
> The spi-s3c64xx uses a Samsung proprietary interface for
> talking to the DMA engine, which does not work with
> multiplatform kernels.

This doesn't apply against my spi-next, can you please check and resend?

--T464TalWMPmNXQHI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRZur/AAoJELSic+t+oim9X28P/3g232mvzL6jx5W2B4mz6950
XBVwyvs45ESwK4iHbAve/aeeFvMUifUQCjcI0a/llEOm5eH4GYoyPoo9YXg/wJue
GtjgeY4wigEb2i5D8QKiBFiNBfogdRdaw5j8mvJA5rnJXp5f2cqvseVBQ5MEVrDA
/2JowfP286FQWygFRiiypkFnlfPRbO/3qwLZXSImsFE44zTDBk+pbx09bvmdEyTL
UWIf6dp/COzdTs/9g1LoNXNFOQTq7Te0hWlchQwm5iQbEbdwMb5f5g7EykVPUNKs
L60xy7yvzsiOi+V1LvayBk0ZnPuDiZa6PZFMS43d1qE+NPYEKX4gMTdYiRsCPJDO
AJyeX9ZB30EsjWDWF3ElayF8UkPv702WhJY2HtQbceGYVjQebljnoejbYSZyLVtm
8V9ghDve2Q1LaVsr2z046jTn3hf7SeFhwhbCYH4Uv33KEgRn5e7DaWUROIf3iTi4
y0JysqeOUNefxC4tyH1CDWNxGdoFcrlKYqpBQiK1xeJ4SyPXd9p1uxIX3Zr3eKyP
TLERbeKzyL4EsMLwXgqqUd8Tvv6ZnOlzdGqdbGddAEaU8nU6ICH2I5PM1rbyWn4z
YkhS6a5pdd9TzYqkwddFLNVa9J/2b6qCcLVcHVmG4dUbkptaeBV8JEQn/+ucnWLy
/HKKJx42m1iFHWRxDQfl
=c1k2
-----END PGP SIGNATURE-----

--T464TalWMPmNXQHI--
