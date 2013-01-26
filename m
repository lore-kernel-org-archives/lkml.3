Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597Ab3AZEml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 23:42:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59280 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751129Ab3AZEmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 23:42:39 -0500
Date: Sat, 26 Jan 2013 12:42:27 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@list.infradead.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 11/19] regmap: avoid undefined return from
 regmap_read_debugfs
Message-ID: <20130126044219.GA10580@opensource.wolfsonmicro.com>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359123276-15833-12-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <1359123276-15833-12-git-send-email-arnd@arndb.de>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 25, 2013 at 02:14:28PM +0000, Arnd Bergmann wrote:
> Gcc warns about the case where regmap_read_debugfs tries

Are you sure about that function name?

> to walk an empty map->debugfs_off_cache list, which results
> in uninitialized variable getting returned.

> Setting this variable to 0 first avoids the warning and
> the potentially undefined value.

This probably won't apply against current code as there's already a
better fix there, in general just picking a value to initialise masks
errors.

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRA16jAAoJELSic+t+oim9zZUQAIUjJ/PGWDI3K6bpXcXPwe7V
1HK/WkHUi8nSdOSzVGBvDK5Hek8SIB7Dr/Tl26uCNqXZvKowVU9191QXwXJ32TvI
JWITFXqObFxNSlcKb6GLiroi3n6bgNcR01wuA26VpTsEgpUoWP98hOqvDHz9zusH
GHXyn0uqipnC8jdmnWQyJpFll6W5pMYreZ1exnVnHW75oAue9qeAuRWqKNcF5vxI
Aez2o8L71r8yVjr1sShWWbOmMjcvsCudPrSpm5hKNnOe0wyaw0DWzNiK3g5x6v9O
MZfw7455wxJHmsMzRIVBleluUfgOfrPymURXgZGskYRcMJTy/gubHMKzhoDh7MzL
y/Pum5F2s7jyS0gpoM/8iAvrXerR5Efh6f2qPpe/QBqQEJMSUMUMpfWqGa1z+r6q
6O0UdSHcr7q38jm2HjtxjDmrTQC8KV0trOXCsTxhMuzsWNmawX1ZtS0q9RNg+EIH
EbOjQupdl8S66CFbor6w27PiuhsWH0jqxyowRkOCdukrA7ZRUtFDcgh1mm/tdWli
ORT7PTdyS1bjrHRojbK0dEV2FcLr7YCndgVrcxIvu8W5bnfZxVYIvVA/sXRu+Qpf
ee6wnJMdbmcNDQNbNAHLveaT5a6dTAFWAu6yaysWrbnfxboxSFTVW6xma35VXWWt
l2FULEGtk2cLw7HYutR7
=aD7h
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
