Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab3KUOGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:06:00 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60342 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab3KUOF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:05:59 -0500
Date: Thu, 21 Nov 2013 14:05:54 +0000
From: Mark Brown <broonie@kernel.org>
To: Courtney Cavin <courtney.cavin@sonymobile.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Message-ID: <20131121140554.GT2674@sirena.org.uk>
References: <1384990029-28182-1-git-send-email-courtney.cavin@sonymobile.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rli/F08USW5HCFIx"
Content-Disposition: inline
In-Reply-To: <1384990029-28182-1-git-send-email-courtney.cavin@sonymobile.com>
X-Cookie: Drive defensively.  Buy a tank.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: make sure we unlock on failure in
 regmap_bulk_write
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Rli/F08USW5HCFIx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 20, 2013 at 03:27:09PM -0800, Courtney Cavin wrote:
> Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>

Applied, thanks.

--Rli/F08USW5HCFIx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSjhM/AAoJELSic+t+oim9FhEP/RNZ4DFDCdnbyhqwPj6ZEIX3
e3d4h43sGdMbRUEGfg6817sOVr8GVWN6MIWk2qDPJCr7WsPxepqD6246+OouBwUz
eCUMLA8zvSaV7I4bH6Nn2EM2SyOB4IZzT6euZj7n/13SPp+o3g8gAX+Ca4pc3zlt
+my9uCceg2obERpdM4ytLPEPFiSEIT3K/l2HFbH34tEkZ5RDhzRWVrVo10xivKzl
WxSLiiaIIorgK35j/tueMB/SkFtInVc+iYICIEGGNXboHyanikxHfzLsm5JMnPRY
kK6gqNxTz3m9G86M9smE1ZIyqITOCjqCu9Bp6ZDxL9Xhs6gSQRG3Xa/sYwUqblNt
xzX55EoU3uTD7czpzj7PHhWwB7QxtWG2yqBxxslydNTo7By7u4e1ZeLrt66nYn3E
UlqUjghYdb+Splrw8e3XbqdzvH4am1uTbaF9VcawCObJ/njiWFPh0eK8zPAyFvLY
tTRf6Gbu3jRXjgM4qk6aiSRvSLsA4XODaULMXqa4A54WtOLd1WtpsXtsO+NjeKJy
Pzl9MQQRmtTzSpErZA4r9l3ej1zqMgK1MJi5p5D7eQ4+/V0ZSMx69lNY4a46gUY5
lGiqX9VlvtQ8lGNzft8btYWAEdrze6cUVgHDYNJcgB1bJheA7u9EhVATRaUkHnPi
+M7IJspNmeNg0FGCCFQp
=VvHG
-----END PGP SIGNATURE-----

--Rli/F08USW5HCFIx--
