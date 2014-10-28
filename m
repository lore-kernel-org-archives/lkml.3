Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaJ1QF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:05:58 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53417 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbaJ1QFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:05:39 -0400
Date: Tue, 28 Oct 2014 16:05:16 +0000
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <nicoleotsuka@gmail.com>
Cc: b02247@freescale.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, alsa-devel@alsa-project.org,
        timur@tabi.org, Li.Xiubo@freescale.com, lgirdwood@gmail.com
Message-ID: <20141028160516.GZ18557@sirena.org.uk>
References: <cover.1414193668.git.nicoleotsuka@gmail.com>
 <1414194502-14052-1-git-send-email-nicoleotsuka@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sC1KxrFoiW8MuHBc"
Content-Disposition: inline
In-Reply-To: <1414194502-14052-1-git-send-email-nicoleotsuka@gmail.com>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl-asoc-card: Don't bypass settings if cpu-dai is
 Master
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sC1KxrFoiW8MuHBc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 24, 2014 at 04:48:11PM -0700, Nicolin Chen wrote:
> When cpu-dai is the DAI Master (CBM_CFx), it may need some configurations,
> set_sysclk() call for eample, for cpu-dai side in the hw_params(), even if
> the set_bias_level() has already taken care of the codec-dai side.

Applied, thanks.

--sC1KxrFoiW8MuHBc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUT768AAoJECTWi3JdVIfQwmUH/3kHoarWO77yk17oVY3U4Aby
R/vlzUFosMqGZBNmEFamsfbBEd5jNq9P5I5eWvOCoP7bw+OL5RU9F3XU2blZVA+d
7Nt28CXcF7ankJs0Qa2h/3tpbbAbFnx3HW/NIS/xVktH8eYrNZMZ0uVILOePBc5B
P9HWZC+k9CqCIxpi3PWzoPt9e5ipjCknDDQhhdcINrIosnK8sG7vUfUASlSk7YrU
ayMFCqFjL6etw0bX5uoVixA0qmLsOG5UZ1wMZaM7IKy4FmaRsfELhAArX2IAASD9
H7TgQtvIiTufcFUqGVnp5XL5VJME9VoL5/P1haidTca/8HfKi8lTalcVkC9hMcg=
=xXnR
-----END PGP SIGNATURE-----

--sC1KxrFoiW8MuHBc--
