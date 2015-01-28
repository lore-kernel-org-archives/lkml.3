Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764662AbbA2DrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:47:18 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38390 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbbA2BZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:25:22 -0500
Date: Wed, 28 Jan 2015 18:24:02 +0000
From: Mark Brown <broonie@kernel.org>
To: Dylan Reid <dgreid@chromium.org>
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Andrew Bresticker <abrestic@chromium.org>,
        Simon Glass <sjg@chromium.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Wolfram Sang <wsa@the-dreams.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Message-ID: <20150128182402.GD21293@sirena.org.uk>
References: <1422442278-10405-1-git-send-email-tomeu.vizoso@collabora.com>
 <1422442278-10405-7-git-send-email-tomeu.vizoso@collabora.com>
 <20150128110230.GQ21293@sirena.org.uk>
 <CAEUnVG6tKmdTt455w8g9C2_+XXpKz5=TR7=V8Lo3uJ3DKrOvag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="CAghj3nbcHapFenH"
Content-Disposition: inline
In-Reply-To: <CAEUnVG6tKmdTt455w8g9C2_+XXpKz5=TR7=V8Lo3uJ3DKrOvag@mail.gmail.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 06/10] ASoC: tegra: Add a control for the headphone
 switch
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CAghj3nbcHapFenH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 28, 2015 at 09:46:27AM -0800, Dylan Reid wrote:
> On Wed, Jan 28, 2015 at 3:02 AM, Mark Brown <broonie@kernel.org> wrote:

> > Why is userspace doing this?  If this is supposed to be associated with
> > the jack detection I'd expect us to be doing this in kernel.

> This is only related to jack detection in that seeing a jack insert or
> removal can cause userspace to set or unset it depending on the
> current policy.

OK, better changelog please then.  Also, to repeat the advice I think I
gave last time: please don't post large sets of unrelated changes as a
single series, send logically separate bits separately.

--CAghj3nbcHapFenH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUySlBAAoJECTWi3JdVIfQve8H/jKFLa4LlHC8P8Wi5zAQHGGN
YgSJwZeknu9+gDqghkvHfMrY6xt3dOWFFjKQsanqqgYGGRqzxDINurbzSd5Sk/IW
/j2YRfK75rwErqfR/RlgY+2p/TaSzOlvm9/ddNJYwAW5AjE85rHOiYOU8mDPwUyF
+Xz5hCpdifOE7WRxZ3IOuStQWi0cPZa46OlIV22ZN549FKltsYinBZDYe9J6U0O8
IKUMXB2znDihV6U1jKj12ZoazT+O/pol3ot55Nk7X67AdiwGRBR1/az9mjAO8h42
8HSqs/pOnZAA363lSusGm4zmQLUKaIe1xsPxGFhslGdJykZS+Y6l5viJyI08/5A=
=4Mn4
-----END PGP SIGNATURE-----

--CAghj3nbcHapFenH--
