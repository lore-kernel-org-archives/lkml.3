Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab3G3MDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:03:35 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51746 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab3G3MDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:03:33 -0400
Date: Tue, 30 Jul 2013 13:03:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Bo Shen <voice.shen@atmel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20130730120304.GU9858@sirena.org.uk>
References: <1375180329-4860-1-git-send-email-richard.genoud@gmail.com>
 <1375180329-4860-9-git-send-email-richard.genoud@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oSAuG1J5f1V/btCA"
Content-Disposition: inline
In-Reply-To: <1375180329-4860-9-git-send-email-richard.genoud@gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v6 8/8] ASoC: sam9x5: get codec MCLK via device tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oSAuG1J5f1V/btCA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 30, 2013 at 12:32:09PM +0200, Richard Genoud wrote:

> --- a/Documentation/devicetree/bindings/sound/atmel-sam9x5-wm8731-audio.txt
> +++ b/Documentation/devicetree/bindings/sound/atmel-sam9x5-wm8731-audio.txt
> @@ -8,6 +8,8 @@ Required properties:
>    - atmel,audio-routing: A list of the connections between audio components.
>      Each entry is a pair of strings, the first being the connection's sink,
>      the second being the connection's source.
> +  - clocks: Must contain an entry for the codec master clock.
> +  - clock-names : Must be "mclk" (clock that feeds the codec master clock)

This should be part of the CODEC binding, not part of the machine driver
binding.  The machine driver should currently have the code to fetch the
clock but since the clock physically goes to the CODEC it should be part
of the CODEC binding.

--oSAuG1J5f1V/btCA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR96t1AAoJELSic+t+oim9jKQP/0BEIr2d0D9nnjNVePmuKLCs
KUnmG8wJYIAb/At0vcoarXsuHcLbOHEW7SA+E6swMQADljW6RVK+MLZeCkvpOJAb
u3VztUNc47CRUgdKAf3xg/fTcfgv0HH3rVgQSSin4+b0QDL7x6mOrFEZKExceFCJ
4CAMJtu6BbahXvx5x3/uRdsYUuv8j+Cws38ISkwilykdRU7eY3qTh+ExL1Kc3O9q
v1ufoIzXK3mUlakk6BQSYQmDNxflIxpT4IeSnazSjzRbi1PNRkGeCc9VHfEpJ4CE
2xl+ly5NTVndXdyDjsKwSccwIeCxgoUnqs2G4m7gXzZ8Iz3umCU0Vp5E0dW+7pkf
VgETNa5W+TgvLy+ku+nkQ7q5ZggqD/QA2P/UEcY4qbxsj7UEee+XtbdLGBw8KDyt
WMoZUM30hotGE1DUhiBsQ4d73pTqUdHSeBS6GQjvS6Z+sbO61olyXJKy4/BJgjPW
tenOKH9bUdQHx1gjTvMV90yGh2RcwHJluYBA+1eSLJ91kHXahEx4WbS1WEGYCquR
NuravohT9hzto6e/UCi9EbpKWg2X3foZcym3lUEhNKgZoEgfF+4acp2CSbeo58LQ
FjeKL/7QDZ+6CmH+apcgbRozazGgdR+76jnuJV96+VY77uiglVv5/C/QMhZeNIke
vokAfMyUeIuMZKD0gC7W
=nqXN
-----END PGP SIGNATURE-----

--oSAuG1J5f1V/btCA--
