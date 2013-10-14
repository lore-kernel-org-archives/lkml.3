Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab3JNNSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 09:18:37 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53358 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084Ab3JNNSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:18:36 -0400
Date: Mon, 14 Oct 2013 14:17:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-arm-kernel@lists.infradead.org, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20131014131748.GU2443@sirena.org.uk>
References: <1381681071-6021-1-git-send-email-wsa@the-dreams.de>
 <1381681071-6021-5-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N4FnyIpcgIJc+tmW"
Content-Disposition: inline
In-Reply-To: <1381681071-6021-5-git-send-email-wsa@the-dreams.de>
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/4] sound/soc/atmel: don't use
 devm_pinctrl_get_select_default() in probe
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--N4FnyIpcgIJc+tmW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 13, 2013 at 06:17:50PM +0200, Wolfram Sang wrote:
> Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
> we can rely on device core for setting the default pins.

Applied, thanks.  Please use subject lines appropriate to the subsystem.

--N4FnyIpcgIJc+tmW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSW+75AAoJELSic+t+oim9TdcP/1UZSjKtrdUF8tH9xDZXwSdb
XK8bn1mrnmsyfBHLL9h1bzmyaGH/DsL4StbeomL7oRvCGqjCoaz3FdPtDSN3Biv2
CY3tpiX3Vebq8qRCcwmMrVB682yKnshm2VulyCNeUrhJz2Z1S6bvSp+yfs38LPmp
3yZFoDDSQgTfWM/igbeT2fRWfgzHMcXHyq6PdMUo50klJsddQmzjhy8LKHSttppY
luEJoMqkCeEa+Sg7ZwEV0fSBZwjCQZ7Bs/Jx3D5AKUCqGS3lvqbAVergJz1QmzfV
op9bAgMitCRqnlHiyHdKOvgqiLO9BWeUe21NLOS6OZAX3W7t7jzYWBZNVlPekg2A
S/xFgiScloQOwqalfZFr6yXflJ5iyeaOABWZPciqBZMJr5bhn2Fj5Wh82UZioOGt
1+VGp5Bf1U5PE+UBZ7/NrjDjrhaTWsyki6XcbbFEuzJTb877D5IJbS76lxKHTpNU
FALIHkIf6BQtUrYyIzPkNJDrkPfTUQUdwRNEAzUbmJnXbD6Ln6Sbd9WXnhINBZgl
isL7tlTsgJIITseVvsVBFdEZsfP6nWatwEXumM/yYnKaebUeSNnKQus6n93O9VJd
kHQb9GVaYX9vtNpBsNJ3JpXlon2d2Ln+J3e1+GXeTkV0PJIs1oCnm51UTbAldCZ2
Hcgrt3oxFsscIOJQvrJ2
=sHl6
-----END PGP SIGNATURE-----

--N4FnyIpcgIJc+tmW--
