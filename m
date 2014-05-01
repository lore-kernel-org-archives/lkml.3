Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbaEASpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:45:07 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54265 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaEASpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:45:01 -0400
Date: Thu, 1 May 2014 10:54:50 -0700
From: Mark Brown <broonie@kernel.org>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sebastian Reichel <sre@ring0.de>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org
Message-ID: <20140501175450.GF3245@sirena.org.uk>
References: <1398694047-28596-1-git-send-email-sre@kernel.org>
 <1398694047-28596-6-git-send-email-sre@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3y/CVJp2vtgPOhvS"
Content-Disposition: inline
In-Reply-To: <1398694047-28596-6-git-send-email-sre@kernel.org>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.133.115.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2 5/9] ASoC: omap: rx51: omap_mcbsp_st_add_controls: add
 id parameter
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3y/CVJp2vtgPOhvS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 28, 2014 at 04:07:23PM +0200, Sebastian Reichel wrote:
> This is a preparation for DT based booting where the McBSP id
> is set to -1 for all McBSP instances.

Applied, thanks.

--3y/CVJp2vtgPOhvS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYopnAAoJELSic+t+oim9Pp8P/0W4IGyCpGGVPDGgzt9/ELiJ
EY7qhIAnH9boqlLe/k0Js23zNILPFlLf5P+lB5LOd9dRzWjudtRTvsVF4dM+DVBW
SDkXkhMD2dhwGklx0BTVhBGS6vkWdyDdwJP6Cdg6+yyzF+sTjB74e9SMH7YVZwiY
QcRLEttQRHGJlrzjj+K0ig2YqUhg04X27lKFcZF9Kw/FZUzWnxjzvL3EsXPLmwTz
CdZ3zm2oq8ooXrxUG4JGsMsfNZETehZOmKz2lvSrZchAsk/CUORkkFTB9Ll/XC21
hVtGbFTOXWKEPJDUEkLpVluOF86WYfKiShlR92gp3q8uQU8WmT/9E1HFFpVjJDrn
36ICE8UoXHjOLUZtxbcgaCaSSwRX/f3hh/EHiWiwKTWyBGvmmOrQLxS38WgYnoZI
Lhz2l9icLXrzKLKoQ6PV25pMcNZZdr2VqfZIuCQmbZ0pn6Oi8CLDwEjXRJ0bg8zB
cZSIiaraLuR1d8WHLlXGZovzVG/I5VMKZj1rsfAitLz1xodxJpGbLN85tyQ28aBv
sWNIWmx5UbNZzVGMqoo+d06io7srXlzIlhiNMzRCxXMKjjjzCnaQyAgIN89Z9b75
ALw/H5Debc+raHQeBZzulXqR5AymeiCT4ckvBYn0qhR8EAb1OoHWRVMTX3Rg8NsH
UHyuvm43/7Iu9k6RtQGR
=w12b
-----END PGP SIGNATURE-----

--3y/CVJp2vtgPOhvS--
