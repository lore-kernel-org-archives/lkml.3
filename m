Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab3FNKAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 06:00:49 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55552 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab3FNKAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 06:00:47 -0400
Date: Fri, 14 Jun 2013 11:00:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Emil Goode <emilgoode@gmail.com>
Cc: eric.y.miao@gmail.com, linux@arm.linux.org.uk, haojian.zhuang@gmail.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-ID: <20130614100020.GH1403@sirena.org.uk>
References: <1371203336-16972-1-git-send-email-emilgoode@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7/IUJOcl5c0tDlVH"
Content-Disposition: inline
In-Reply-To: <1371203336-16972-1-git-send-email-emilgoode@gmail.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: Fix double assignment of .owner in struct
 snd_soc_card
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7/IUJOcl5c0tDlVH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 14, 2013 at 11:48:56AM +0200, Emil Goode wrote:
> In struct snd_soc_card zylonite .owner is assigned THIS_MODULE
> twice, remove one of them.

Applied, thanks.

--7/IUJOcl5c0tDlVH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRuumxAAoJELSic+t+oim9q2kP/AnbRKoCuS/4EoZPVoSWxUZE
Sq4LX2eq/DSR86zhOTMpwqqklNM+Xl+FBrsFTMB7uEkhenY6+zTvKJcKSsdB7Rg2
vWVEflULvI9vNz+MeVFD+ICkou6v/V20iaemlp5F5seFoxCAUAugwFDCEourNK5b
8bc3i2CUWZ8fqJ1EAtvliljaT+b/w7zCh8j+Gc1IPQzWptuQPduNV5GGeOCSkWrZ
JIdcJMW9oBi3dpBaAOm3AtSceV+YYy6XxWTDUds8pU21VDiiXQW2DrijSJue2hxL
ep10ty884mT7ehNUU0o/lXXs81HvktrHtN1BqcEyvKPg1+YalB3JWqt+02QTK9X5
Dn8LFA4dsdZ7BVkhZKHu5lI14wVCbRW5m6XyV1HHCLPRvWJICUFOnvO7xq7ChMNS
3+nMgX3gYehYU1PxsFVquM9d5Or0ixwrlFPWrPMYyc+jKjZtOYX4YSmmysgbr1S1
B8RD/r2ugqpVHyNJvskBrXUpYxYdkOQ6ek/5bDmJ6kfNk3rxDhP5rvah2tQGKXge
KlhRQlOOZ1CePS5Vwv8IgVPanM6JtRDOyf4aDb0wn4m2xQ3Fl+t/JfLlLilQBlFN
asnB6cPw8Kp8DYIkytxkQXdKd5s0uiS7q6fcXjtJe26hT1aKt/n20UtssME92vNC
D0pZyRATL1RpNoDA4Tat
=M+me
-----END PGP SIGNATURE-----

--7/IUJOcl5c0tDlVH--
