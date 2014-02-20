Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbaBTLvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:51:39 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47286 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbaBTLvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:51:38 -0500
Date: Thu, 20 Feb 2014 20:51:19 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        Laxman Dewangan <ldewangan@nvidia.com>
Message-ID: <20140220115119.GG2669@sirena.org.uk>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
 <1392886403-10640-13-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hMz8dcL0TnoUsWwg"
Content-Disposition: inline
In-Reply-To: <1392886403-10640-13-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 13/23] regulator: tps62360: Remove redundant error message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hMz8dcL0TnoUsWwg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 02:23:13PM +0530, Sachin Kamat wrote:
> kzalloc prints its own OOM message upon failure.

Applied, thanks.

--hMz8dcL0TnoUsWwg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBew0AAoJELSic+t+oim9xbAP/06ovectIvPu5sMhOmxxhgdb
iV7Tp5oUVWJY/7rcyuJFfOuw8Bj3/3CTk3sRXqXpjbrOYAZW99Oer2Fm6zG5XQun
rIciuZDVmZaPTyahCIuztiF9KU2McsuyTydYpSXQ1kvUNxpiBbVQVb64/F10l0OH
v/eTa8/4+R3Od9zg45dl142BKoBg9M5qjGkKJgB6tVjTSGzjkHDY4A4vX03FBUgi
4h6XKeLHHCG0T84/XJmQIftK1V8DPZ/Vqlqz8m3O0m3UzDwPfRvINBP8GhGcqjCi
z7QF+oYPEzSB4B08U2T3pM9XmZZAqUld9aJQblAFzPrP5buWFlB2VpXpg0PHHt9K
lrtwtZQayLLuHjr8NO/Yb5d7rLvYmsoGkiANuvPC/jozN8Tjn1WaoemqWxrqGvV6
J5iirLfIARACfqiye+V4VJP/VyuwXTG4MEmV6/qAPE6a03lWClOFo4tglzi/GMOO
peW5jP0XexbhFIdMm1TfXBVhJGz3RmWPGGUOtfK0lWFPlF7vxNB0h56G+qfWSvFn
LW7RVEb8//lMAVJQGqGcBvBusZlrofMRzEXrDIbLPCfZurUSugee6PeCjLZ/zHye
9FuIE/bcrXILPJ1PEendP8SLgwIR9Jy/SRtk+PFxo/qK74hCHupZqJG29QFLxX3l
3mc9zCpeRKYPBL/xP2dH
=BJVY
-----END PGP SIGNATURE-----

--hMz8dcL0TnoUsWwg--
