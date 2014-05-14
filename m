Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbaENLfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 07:35:21 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44494 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaENLfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 07:35:19 -0400
Date: Wed, 14 May 2014 12:35:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-samsung-soc@vger.kernel.org
Message-ID: <20140514113505.GW12304@sirena.org.uk>
References: <1400037546-20395-1-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZLqRQ/WGGSOZ+L+d"
Content-Disposition: inline
In-Reply-To: <1400037546-20395-1-git-send-email-tushar.behera@linaro.org>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: samsung: Add missing pm ops for Snow sound card
 driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZLqRQ/WGGSOZ+L+d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 14, 2014 at 08:49:06AM +0530, Tushar Behera wrote:
> Adding missing pm ops so that audio playback works across
> suspend and resume cycle.

Applied, thanks.

--ZLqRQ/WGGSOZ+L+d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTc1TmAAoJELSic+t+oim9IEoP+QHHcJq/wdg01/gcPYskdWDK
w/ZIA1WEczjBxRGFoLfKdSsrSTZmAsQqcOYw0bUo7UXMinj/b1hQXy5+8nU2QsGd
c7Ncm7MF9DufQqmykmBqt7juvFUDSeyZj+dLcoVag5xChvTHg/6Jc+aIpnEkbUiu
jxAJqsJ9ZTF8n1M4Sp10IiN0U9WuwiM6+8tTJGYmDphdHhrem4LeNPSUJR+2M6UX
WApnpskzduDquMkdoXgxcs0rjgrJJXegpWLUSeyAVaD/TsG3UwVUkDfL32rRN8BC
+Rbyw07Kfv45uOyWNtQ53Jyoy/HsCV7GSpH9B6vxtIA2q1O9+4yQTtQdDE1xbekh
wwjSa/wMaGpscSl+MQmMCJVG7JeASviUxpvUi1sRLAzXjxWAxBj/pbuX4/1rg6Q4
mGg02LHxzxtnx0CLUp4J8QeIG6j014tQwEwoOlAHx0yFV1huqj3qfFLKn2IGNDac
sN16K5fv8jdv22L+OToi//HKzSENSsvxNuQenC7Pvjz6NMAT9J5pyoOJRggcaW1x
eQw+6Iio/ZsgZ0Em/b3Fz7jeZcgxAp8jQNaZFSQ4blWNiS3//0iW4Kh7q/OnELMv
a2+EelMtzbIncBNZn+huk2eooZnvfyD7p7kR9zWaO3OCKYaicAdQzwAu28KEiAgY
hKtGsBiBVKxQRrTMs0/B
=1/Uw
-----END PGP SIGNATURE-----

--ZLqRQ/WGGSOZ+L+d--
