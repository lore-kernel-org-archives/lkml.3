Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbaGIIKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:10:43 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54342 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010AbaGIIKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:10:40 -0400
Date: Wed, 9 Jul 2014 10:07:01 +0200
From: Mark Brown <broonie@kernel.org>
To: Tushar Behera <tushar.b@samsung.com>
Cc: alsa-devel@alsa-project.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        dianders@chromium.org, tiwai@suse.de, perex@perex.cz,
        lgirdwood@gmail.com, galak@codeaurora.org, kgene.kim@samsung.com,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, trblinux@gmail.com
Message-ID: <20140709080700.GF30458@sirena.org.uk>
References: <1404463980-25027-1-git-send-email-tushar.b@samsung.com>
 <1404463980-25027-2-git-send-email-tushar.b@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HjNkcEWJ4DMx36DP"
Content-Disposition: inline
In-Reply-To: <1404463980-25027-2-git-send-email-tushar.b@samsung.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.127.83.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] ASoC: core: Fix possible NULL pointer dereference
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HjNkcEWJ4DMx36DP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 04, 2014 at 02:23:00PM +0530, Tushar Behera wrote:
> snd_soc_of_parse_card_name() may be called before card->dev has been
> set, which results in a kernel panic.

Applied, thanks.

--HjNkcEWJ4DMx36DP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTvPghAAoJELSic+t+oim9L0gP/10MJ1Ugu7EX5SGw1JsVXRgH
TD873eaNdAtN8/8/0OzDAgRxwoERcd84QqzXbx4wliaT1OFTLAW6eLwReb3wNYF1
8tu83PQJW5bVvYVjfx4ZwoZ/F+I0KnoPZi48VV/Jhsq1wuHMWrmoN8jCR4VES/Rh
S8NTTtW9Uq1FFGM56zcAV8cCJKvyKOtMywEjm+vDV6p0bdMQH+AEgQS2lUiB/iKU
aipO6g4KhbOspq9eWnJFRClq4Xo5ZVm2pCHABRAgODBXWFsh9iOK1SuZ48GBZ681
VjfVMxgY3DoOloQnGhzPve5cE3ni3+i/BenWPWM8aXZY2JS25TJ/tRYRTXATwv+q
DbsS8ZGxQ3AXQaWn1nhfotYs1PqDAp6ooc/XoS0VO/wvyuHnVHHhIOkfjViGKV1s
UCbV3DRf7QTeIM5FtKV0OGrivm11qEpjyzzb24cD7BP/hEMLD94xrhimzaTnKatf
SmuNivvopypHuzLZpV8rZEGGa+IcepxP0LkGkGvcgMSGFjLxIw6f7O7bdEewWWWU
zU/9uzGjQLD/SZsmWMVDUczf7deF1xZFWpNyIkKFk1SnrJvMPdDtNYbZeGXbgQI0
qbDxnpqv1bPLLRL421EERkqUPO4dolPiXWhej8XeBp+qCrlChHnJR7VecoZorDV1
DIbed7iFLN4pFZi5idtE
=7iFk
-----END PGP SIGNATURE-----

--HjNkcEWJ4DMx36DP--
