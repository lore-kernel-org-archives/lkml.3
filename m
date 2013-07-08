Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab3GHQ2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 12:28:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46197 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab3GHQ2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:28:45 -0400
Date: Mon, 8 Jul 2013 16:07:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Bo Shen <voice.shen@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree-discuss@lists.ozlabs.org
Message-ID: <20130708150756.GL27646@sirena.org.uk>
References: <1373290193-25300-1-git-send-email-richard.genoud@gmail.com>
 <1373290193-25300-3-git-send-email-richard.genoud@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uClWv9hlWZX1oA/f"
Content-Disposition: inline
In-Reply-To: <1373290193-25300-3-git-send-email-richard.genoud@gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/5] ARM: AT91: DTS: sam9x5: add SSC DMA parameters
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uClWv9hlWZX1oA/f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 08, 2013 at 03:29:50PM +0200, Richard Genoud wrote:
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> ---
>  arch/arm/boot/dts/at91sam9x5.dtsi |    3 +++

There was no binding document in your first patch - there should be one
for any new DT bindings.

--uClWv9hlWZX1oA/f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR2tXJAAoJELSic+t+oim9M7cP/1GJNEMcuAE/0i1QMJWMO2CY
XJlR34Ulmtf3TSloASrlAoHUshxBlpklVsAnRU1ZeLz+t9EzY9tXkp1m5b6A/dey
pEFS7Pvi4f+FAbXqQ0u7BoeWSUhOcnb68CQnyOXTl3mQwX+1xCEgTvVqVMGjbgdS
GAdsHsx4R6XnNET14Tmow1iz378CJk80iBXiXmTlzPHk7F7BHfqQUury4bsOhJ2W
5qBA45Bne40HO4SEGOVSlJQpTZvz3DRkVzZaqtIzzoxbhrGwjIlmilIG33NgxiVq
/QYvImSrzxEyMcnwnyqsV4Vbh9zTU605wZokU//HVgQA6PySMgwHHKU5itRIy5Ag
+tGpa6FfkjXBud6okSPE5txdtRYImXaWwPCeLqwPq2GQ8DyDD2IuM5ODN6I6mLsH
SSqR+N4E20+z1VE0aQazyoQXJJ+JcFwa0q3S1EhduoofOXfvLDWkevEIB4o/dXmB
hNJHgnoa8MHEO3y5AcX1u4gf+ebTwnsxP0XtdnIT0DqmWselxZfq/lDuPn28ebwX
mlXmE8pYvopJn7RpAonhMId2bA+b9KrsscTC1dvZoAZ9WkngidzaIM+gqqpdWdDp
lTHpZsBVETBK8JKDMCEi2lhkiUNDl+Pgvi7/YVWlD2zd50sHHxU8WNwLKoH14U0Q
PloqMvKlW+zZ4lSDoFkF
=Zvvp
-----END PGP SIGNATURE-----

--uClWv9hlWZX1oA/f--
