Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab3ISNRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 09:17:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37051 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab3ISNRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 09:17:08 -0400
Date: Thu, 19 Sep 2013 14:16:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20130919131639.GP21013@sirena.org.uk>
References: <1379594395-3602-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a1taQt+5gib656GU"
Content-Disposition: inline
In-Reply-To: <1379594395-3602-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 86.153.71.95
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: wm8350: correct the max_uV of LDO
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a1taQt+5gib656GU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 19, 2013 at 06:09:55PM +0530, Laxman Dewangan wrote:
> As per datasheet, voltage range for LDOs are as follows:

Applied, thanks.

--a1taQt+5gib656GU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSOvkzAAoJELSic+t+oim9MM8QAJhIOSi9wekLSU0QTOpPotTe
rJltvu90zeOOzG+N4e5zrtM4ynBwOTNYZXTVufCsWk3KfXeXbbRmduTSVcVBbEck
UbxDdvTXGV+JOVQNoo0Kgid+BgW9aH2LNcmc1tVCRhFazwOEfMlsH/9sRGxHmuYB
GzHbXbbi7wdc/U8YTGxjIwUj7dM61SHxulHiHXTPIVujfrYowTNI/BPWdBi8wlWa
sBR7r+O8tK7fCuk5H71FeptJv4f6s+zgnSAWkbipI77Z8HVm46Jy1Nq9hh11Omfp
sxzkVKOjwdN/q+2ASgGf6rmdVlTou4n3QmHoMpXmI2SszUaaGld2FNW5sACx09Do
MsBWQjUl9i/ud6IAx3Jc80+fkrOevizDNGGyE4u4uNMmVPSoSrbB2w1H1RaC8nsB
qyIsrEaxHLv1dnaMjtwKrpaNzTAQq1jw5cDq9ke32l6xPOFYtGkTZVA47T03ypJa
mNCgG+4ZMjI/wIC87dJ2GlO76t7wjwJeNzqXjs8gGGoaT3Lxzz5iRV0W6FutQBLl
8Eia9gZOLmowwiMdIRhuLmwck5H+uYPVBQV18fBJuwogRUrz1sk+4c+WqCoT+Qb0
f+EZgT5VRELvhD/Sqe4nOWM3vPXQiukg1/LcE/rTJTTZeSg2BdN0OcLd966adTMn
B1K954gTjPaGJEJQVoVm
=kND7
-----END PGP SIGNATURE-----

--a1taQt+5gib656GU--
