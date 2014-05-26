Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaEZPTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:19:04 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43304 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbaEZPTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:19:00 -0400
Date: Mon, 26 May 2014 16:18:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, tiwai@suse.de, perex@perex.cz,
        dianders@chromium.org, swarren@wwwdotorg.org
Message-ID: <20140526151838.GS22111@sirena.org.uk>
References: <1401092902-20525-1-git-send-email-tushar.behera@linaro.org>
 <1401092902-20525-2-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4sIpN43wh+0KCG0T"
Content-Disposition: inline
In-Reply-To: <1401092902-20525-2-git-send-email-tushar.behera@linaro.org>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.248.185
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2 1/2] ASoC: max98090: Add master clock handling
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4sIpN43wh+0KCG0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 26, 2014 at 01:58:21PM +0530, Tushar Behera wrote:
> If master clock is provided through device tree, then update
> the master clock frequency during set_sysclk.

Applied, thanks.

--4sIpN43wh+0KCG0T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTg1tKAAoJELSic+t+oim9eZ4P/iWyMAAkIymViwiAu1gI3VIn
OOYL3fmHoeuC0M3ELMtsMFWz/olftH5hkSrCmFWBu3AAzdeR3/F/cJ0oiYQYZ019
iYlp5Ml6nV+to0zF1hILF5BNa1uYH5dhprZ7zsQmgVjZJDzX2+9unJAZasJtY9Dj
XWLLu3CYH/b3jB9292euSSRjIY8HKPAQ2ikOkAn7I2ezWit0T4NYF5PPjXvTpY41
ngDJ7FmiujwlfXyIpjByJ4Qu/XPcnVaMNdaAWk7YDf+D8/9evt7Fe2Ki9Q68cg7v
rykHVnw42TbZzIxDDO32IQn1hT3BkP+aE3T0/VWygK8h67tLV7suaRgM8iiyLoRm
UoVooaDZvOUc71fztYlcrazbAM+x+rnoqWl/cuyq2uWTVZ8fMtEjFMKwr7ufCLHU
lVbjADn68tydwS9baw8LW5eL3v6pUngFyRSRAVdILzDDvsHSo8wqnFI4hvJCEOX3
pX62w3eFk/JJqH7OG0HQxvF551qKDAq+Vmt42tQo+x0vRFXyV/EZHFiR77H/aw89
/pDa7PvRwk8p5X8FPVMlb+S1ZcLGfRs+EaiZbpeP4msEO6rjuQB85qtS+FUpe/x5
nSHzzsoC2QO6+gsX6XhKDRWo4W85PUt5OsBkSE3IuSuNSNYftx8FdkLFP6nP7KRL
ceAAuWjEAdLOW74DiXsr
=WSA0
-----END PGP SIGNATURE-----

--4sIpN43wh+0KCG0T--
