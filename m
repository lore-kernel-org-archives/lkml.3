Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbaJHLaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 07:30:21 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40441 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbaJHLaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 07:30:20 -0400
Date: Wed, 8 Oct 2014 12:29:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: linux-kernel@vger.kernel.org, dianders@chromium.org,
        Jianqun <jay.xu@rock-chips.com>, Heiko Stuebner <heiko@sntech.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-rockchip@lists.infradead.org,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20141008112947.GV4609@sirena.org.uk>
References: <1412755131-27542-1-git-send-email-sonnyrao@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1nWzwthe/g5xaf/W"
Content-Disposition: inline
In-Reply-To: <1412755131-27542-1-git-send-email-sonnyrao@chromium.org>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: rockchip-i2s: fix infinite loop in
 rockchip_snd_txctrl
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1nWzwthe/g5xaf/W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 08, 2014 at 12:58:51AM -0700, Sonny Rao wrote:
> We can get into an infinite loop if the I2S_CLR register fails to
> clear due to a missing break statement, so add that.

Applied, thanks.

--1nWzwthe/g5xaf/W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUNSArAAoJECTWi3JdVIfQjGwH/iVgLdwxh86ob6hhMvimR5GW
GWwrIpyU+ShjnOoUZcNkkMt/g7nCaSS6UiQFtK4AjtvHVduxyLcu0Mj8v8L+PSiN
gS45pI8ItBVIexCUMlqm/OASnwtJwJoNpHnSQMbeB98hnWdD7ZgnTtwNao6y6uGn
35fYw5o4Gp9KSrxqVoa1hSDIrEHbtmFCwnK6pgsgc0lcfLZoTBCF+506YlSdgPxI
8+21yqPPfXh3vSTKlTMaPEnsMFVc9LzMPXn/SE8E1lEXlPQlP3jNoELEfu0v67OI
nuzdq23NC6jEpKkS3yFuIy7DLGB3ELv8YTcbUO6JsK10ot2loVvNYFKzUdZxYTk=
=WAn/
-----END PGP SIGNATURE-----

--1nWzwthe/g5xaf/W--
