Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbaBSH4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 02:56:45 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50022 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaBSH4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 02:56:44 -0500
Date: Wed, 19 Feb 2014 13:25:21 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140219042521.GT2669@sirena.org.uk>
References: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/tCzywT4ru0wuIhW"
Content-Disposition: inline
In-Reply-To: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.145.86
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 01/15] regulator: wm8350: Do not hardcode return value
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/tCzywT4ru0wuIhW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 04:10:57PM +0530, Sachin Kamat wrote:
> Propagate the error value returned by the function instead.

Applied, thanks.

--/tCzywT4ru0wuIhW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBDIuAAoJELSic+t+oim951wP/iLSZjzbGuQVLWHfUi7ELSpq
XeV4iKHXaC3UyRweHI2b1vHJU9GFlt7g/sgRNIMyU+WFFSLP5aKVeDJRcEucUxXS
utqhaXtFtPIzE2Y+F1scqWfMrLjQhOim4xedm6jvB/0FUiEj7lR9CALjP1ZCVJYO
NS4CROxw2obDoobkkUi8UHUQ5TeB9qRWDvoZRHt2VOM1aPxKKwhu4UveOFxbjaam
+V1ULhZEyYbdd55s/UgDribgeTqW1FlssOEUHnV0ZH8f76R9Q2jqXbsMzO2xeCPM
hsZMQGSoquGGrsw63mRHsdeAHYTRoDqVBQhwGLbfxwEUTDrH6rsL2FqmiVYIDhkh
UpwybxD66SDzv4NzUEP3WPSiJUbCX+StePtSEBdguONsqLIuCRqaV/izM1mnB7z4
qeN2gTybFKKinBN1UOJqc86dEYKS+3xpevRnyykD02rx81H4hxJhb4H9Iap2e87+
jDikWOuYt846F/Ej9ac27ezTKrX1S+LKRSXtIUgVR7W0nkIlolD8AxsEaJyWAnWM
V0j35bKymyRp6vZKpTu6NyhvKZnijfbH+u/uL7nhgRayB72gIft4wRVet8S4fY6E
Qrf9hzcK9jWO7BGMQYAax47VSXAfmesUA3TQQo01fk/RKe9+0qgV2Lvnm3qjXGve
LTGPg1OUeI9KjJ5TLwWe
=sfIw
-----END PGP SIGNATURE-----

--/tCzywT4ru0wuIhW--
