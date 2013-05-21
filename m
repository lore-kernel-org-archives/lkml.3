Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab3EUR1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 13:27:25 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45892 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab3EUR1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 13:27:23 -0400
Date: Tue, 21 May 2013 11:43:33 -0500
From: Mark Brown <broonie@kernel.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Message-ID: <20130521164333.GD1627@sirena.org.uk>
References: <1369130649-15179-1-git-send-email-fabio.baltieri@linaro.org>
 <1369130649-15179-3-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h4FfhoHh9AMwLYAn"
Content-Disposition: inline
In-Reply-To: <1369130649-15179-3-git-send-email-fabio.baltieri@linaro.org>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] ASoC: ab8500-codec: Set rx dai slots from rx_mask
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h4FfhoHh9AMwLYAn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 21, 2013 at 12:04:09PM +0200, Fabio Baltieri wrote:
> Replace hard coded rx slot numbers from ab8500_codec_set_dai_tdm_slot
> using the ones requested by the machine driver in rx_mask instead.

Applied, thanks.

--h4FfhoHh9AMwLYAn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRm6QyAAoJELSic+t+oim9i90QAJKYEKR38Te/JkwUAZcF3J7O
z4wtwEvQQlVc3CYtaj3h8KLkz8bJ1N0aGLUGml9F3B2JQfw1W5Zwg7RJOzZ6+xZE
bNZ8Jg0ZNboNixXXVPQWdEaNGKM61iU2yRJ3w708cYhCpLI4yqnnVRveGO0wPv45
NqCc4Bz8RX8CSMKYMF721tAB1p30TTJ6x7YkQXds9TP8VMJCuaXCxlb+WhS/5VlR
/VsOfqltINb97ou1lupEIBfK1L5Xv4bQwtD6YWQeVy/4Ar/wdkqN9C4LbKG9eawY
wPyoRlmk9rK0ovM6ZKaADkRwnOBi1v5rfDa3AL3aaBkYw86sHhB6pVSo+R6nzUOi
etkQ+jHsQ8m96bEnzDQpDpPG2O2E+uc2XM8YrrkewQPmBeVpBCWP49sVIClNg5c7
17NFejxR8SItSrkLDlVkrXOiKQckJ30Ws0LkLgC9fSSu1WRqi2n6PHnj3+AHQuh0
05FJEZDSm4Vq+SNjWJwwF3XxLTq94RpPqJsgq3wZO0QzffTUToKvcJOSJupnMFAV
WPztsIDiFsSEBZp4huVuL7GZEC6EgIoYaBr4URPDvdS/IVvWI5Jja5SZJo/voB1s
FCtIERiI0+cGu1ucXv9cTxDJF+wAid6aew7rvCbP+qRvIKv5V2vED669Q+sDL0bH
djORpOlQPHhzpBs7G0iS
=64Yd
-----END PGP SIGNATURE-----

--h4FfhoHh9AMwLYAn--
