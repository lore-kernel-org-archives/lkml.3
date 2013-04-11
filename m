Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935858Ab3DKQtH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:49:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38154 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934395Ab3DKQtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:49:03 -0400
Date: Thu, 11 Apr 2013 17:48:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH 22/30] ASoC: samsung/idma: export idma_reg_addr_init
Message-ID: <20130411164858.GN9243@opensource.wolfsonmicro.com>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
 <1365638712-1028578-23-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W+SeThb1UGlzpiPr"
Content-Disposition: inline
In-Reply-To: <1365638712-1028578-23-git-send-email-arnd@arndb.de>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W+SeThb1UGlzpiPr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 11, 2013 at 02:05:04AM +0200, Arnd Bergmann wrote:
> The idma_reg_addr_init function is used by the samsung i2s driver,
> which can be a loadable module, so we have to export this function.

Applied, thanks.

--W+SeThb1UGlzpiPr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRZul0AAoJELSic+t+oim93WMP/ArzPnZtmvzzMrMM+Wtn0Iqf
SdM51KeHfy93CtWgfSyEMA6OuFoTPb1jYQ/Huocxs/Z7AltJtkPseAgsH0cYq1Y1
DdlLBOYhB6ZgUc5BhKLAoJqtmY4HU3n3E0ek67R7x2qBnvE8iFrjyCrXRUlD0m3I
49t1HuNlaamkNyRYdHGgQvH2EQBNLPYVP/5Kr3nXHHOxBQNVNAd+aA6ILC4OTUF6
CywYPjGFcrzysHE4ne5yuFgvw7ZLkgfOG0cO+PT2Rd6cLdDNyhPYvWrNGndsaQax
wOyYDhYH7UUNy3g9JRWysesXi6MgQNLAxqNui6C+fIK5HkX/3+2WZUrx0LPk8FY7
413LRcfqS1Xen33cfe5UWSYu/cKXVuOVIWklP/XqEEiqRfcZyXGlOLTgtshKu+73
pt/oOzFtIQFq88PcM9jlayczojB9Ip9J8NfSU3DAzJyu1ZIq9aBGqLriMHlERAdi
TeB5ikXMqByouFGvkT7aoBvJ8Vmrj/TvotNr04dbDhZtL2xtZ9e5GGhYNnC+GyWS
EoxtpM5XimkYwjhlnmZQkeKgaxwQ+uHTm83F3bCSwKiDn2YH4K0VbpgbspXHBwYR
DfyR7p3fKErMcCt2WIxkVe7s4iLMZPjrQxqxDOFAU3/ZoQWwPNSfOcTCsx4C/cyO
pV6d/VMCEx8IrYXRzTIH
=HKet
-----END PGP SIGNATURE-----

--W+SeThb1UGlzpiPr--
