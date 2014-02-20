Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaBTLUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:20:18 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47222 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaBTLUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:20:16 -0500
Date: Thu, 20 Feb 2014 20:20:01 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        Sundar Iyer <sundar.iyer@stericsson.com>
Message-ID: <20140220112001.GV2669@sirena.org.uk>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
 <1392886403-10640-3-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZY1LSEo7RTyfcgGM"
Content-Disposition: inline
In-Reply-To: <1392886403-10640-3-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 03/23] regulator: dbx500: Remove redundant error message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZY1LSEo7RTyfcgGM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 02:23:03PM +0530, Sachin Kamat wrote:
> kzalloc prints its own OOM message upon failure.

Applied, thanks.

--ZY1LSEo7RTyfcgGM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBeTdAAoJELSic+t+oim9J4EP/2GIdDWwwtHlsAxNaPzz/l0x
UNhurxV8qG0FCOiXZ4isroxTKi8KlKjXb6czdlLU1o56DkEzsEFYhv860H4gnBTH
JEFZX6h8YssdUv7JcdESfIe7EAoGtxg3HNRhLg4gW7dHHRvLdntmhZDxXHfImxyL
U61xGh5mmSjW0UAijKHIcCQeovWx3r2iPxwlM3/4CyIbsocZPMOQ+dpsr5vDTgoj
tDr4S/HwYrePeKaGtFf+wwQn32Y5fDA8CwMlaE9MMFN6sALzPxnBCGg3ayTzHrau
SY2IFQiZJStQAjqkJuK+K4SIRc7WykS3b//Pz1VaXSM0PtvBu79wkPM33Q9q9y3E
TkjAyxoTl34FPdiKPww6xG+MUzUCGukEMJBEJ6RMWFQHXAsK6LDCHnKWBUw3xIbP
Nh4GukhVfupoMimUC28F5KMuKbCXXvvVZ/7qxV3LOVcvw8tXiu4kNiHqiFkahAmv
CpxbQ7wwlObrkLltg7FbpiErZ2cf+y3feJFEfQJg5INbamXnbwbpyIX7wkKNAiGE
PjnHVwWtgnSROVuDHB0F4wepOWuRHVV2ON28zgK1q9U74kUzQZL7Ct10BwldvK+i
Kh9hdKoc/ichSHHKuNcQeGJuM32ATKFzBrXai36zvg1/WGPNHZIvkU/sDZi9hGcb
V46Bz/CKFy8KYV4i5I+1
=bbGI
-----END PGP SIGNATURE-----

--ZY1LSEo7RTyfcgGM--
