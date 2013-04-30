Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803Ab3D3SpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 14:45:08 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59183 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932751Ab3D3SpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 14:45:04 -0400
Date: Tue, 30 Apr 2013 19:44:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Marek Belisko <marek.belisko@gmail.com>
Cc: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        zonque@gmail.com, linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        Marek Belisko <marek.belisko@streamunlimited.com>
Message-ID: <20130430184441.GI26160@sirena.org.uk>
References: <1366979891-15434-1-git-send-email-marek.belisko@streamunlimited.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3U8TY7m7wOx7RL1F"
Content-Disposition: inline
In-Reply-To: <1366979891-15434-1-git-send-email-marek.belisko@streamunlimited.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: McASP: Add pins output direction for rx clocks
 when configured in CBS_CFS format.
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3U8TY7m7wOx7RL1F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 26, 2013 at 02:38:11PM +0200, Marek Belisko wrote:
> When McASP is bit clock and frame clock master enable pin output for rx clocks.

Applied, thanks.

--3U8TY7m7wOx7RL1F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRgBEWAAoJELSic+t+oim9x6kP/is8QrT82Z0zoZdWTzP48Dx3
os2iBd9w3VGyRN7D83vR+wD9sFrJheRcklFmtnj2HMu87WFxpKWxXDTgSb94ROFI
7R2s16BTqj5HpIY+HkuwEpzRJdufPOfNos1zogrIy5bjeQLYFtL2G+ZMnUvA0jH7
+nIAHenGlz2pyDrYXOfHm5yoOBWiO2InKq9tnLYowWNIxn73Y33Qs5B+i4c5tBmu
cVEAsk/82SoRV/SSaxggCihWpc03qGyI9VnYBl8LQexZyiFCEgMrkPmOdYoKNb13
iUo6xV3fcl52Z5BvUe6WRJBnYXkvlC9rjRq5s6oaPJZ69fDlxd5az/nt1wLB0mQ/
tiVYa1Hp+jJJXRuEXSLrPd2YN5MPgl4mDfKHuiGNhlS7BAtQ1HBM7aWHEOl5Fmf3
r4opm0iZKWKGXa1XIYAtXZ1U7qV5eoTqfnNEuzVEeU73PcwgVei9HW/hLzZcCatx
wvwYcJ2b/YRJ0pddbJ/sEndjGZenKf9GcLW7vrvupIccyfZLBLpPQ4lVREBIQgZs
1C8IkLDo8Eu1y79No0TZyiW9hr928GXFisgaFM3MzLnI0xTN/UDw26vckqSPtcma
ni5hu58rTdT1ZciMNmG3UajpvLaO912gLgONLHNbUCJ+7yQy0RYYJaahj4RDtUxg
qS+M+DxHlS6OK9UnJpRj
=aTpY
-----END PGP SIGNATURE-----

--3U8TY7m7wOx7RL1F--
