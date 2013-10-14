Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab3JNMAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 08:00:31 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37546 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab3JNMAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 08:00:30 -0400
Date: Mon, 14 Oct 2013 12:59:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Felipe Pena <felipensp@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Markus Pargmann <mpa@pengutronix.de>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20131014115937.GR2443@sirena.org.uk>
References: <1381617306-18764-1-git-send-email-felipensp@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RyOXVFQXzAE23HDB"
Content-Disposition: inline
In-Reply-To: <1381617306-18764-1-git-send-email-felipensp@gmail.com>
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] sound: soc: fsl: Fix memory leak in imx-audmux.c
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RyOXVFQXzAE23HDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 12, 2013 at 07:35:06PM -0300, Felipe Pena wrote:
> When audmux_clk is used and clk_prepare_enable function succeed,
> the memory alloc'd to buf variable is leaked

Applied, thanks.  Please try to use subject lines appropriate for the
subsystem and keep your CC lists focused - you want to send to
maintainers and people working on the specific code but it's best to
avoid people working on tree wide cleanups like Bill so they don't get
too much spam.

--RyOXVFQXzAE23HDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSW9ymAAoJELSic+t+oim99S4P/izU/ZcUlt5MsAmtixWPMcT6
5Z8MqOFszP95RXGwxaMcqmfjMH0UyGwkUNuE5di2PQEQ5KST4QZQSsb/e2BbbI7m
ve3QFUmpMgekJo1SuTuu/EjvLlJLYQCX+MG8Xt2GMpv2qIsXJakgM3OHSokmQFaw
KhWKNSY2pAejFj4QXZaw7IXGt6lL8kFeYB4B1iWJJEUTG6fUlb6qmC08OZMZHUkp
JL+aRfs+wk8blwpMal+wZ1Ae0gWnOhwOd2rNI+JVWtNer9s/fWMy2z+a3njgcxed
ES/caP7B15WkQv3jktga0ncNpyRgUrQDLNrqhH/P2qBmhqezQw7g2lFu6ainhtIH
90YgmsMeWiinoDxs4aX8yfVSk+QGjT4zkJs13nxsSQl9TG1arE562W5kj30MwEIZ
f7DRlBfPH8YYudOHNZvTEjMg0vgoNgjC/IauYj3RziNorjcR0AXRwrfPejp+mGFx
mLrOuj9HdhmgvDGAf+acfINGijDKliWF3VsAUxvojfyGtL6lV2fuYfWgS3n25Zc7
QC/J8TDw6GaQleWigr3FBNnbaLK6hG/Q/ngCf7ZLnTXsSOTBlXiKXSzMC6FXyl+h
HotY8AVkYYX6kTK0OtX/zebbJB0AEd+1aVMsHafeQsjwe51gyEja18xK3VR1WAVK
zJGYBcotOi/4kF377sRS
=MuZE
-----END PGP SIGNATURE-----

--RyOXVFQXzAE23HDB--
