Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326AbbAFRph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 12:45:37 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38931 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbbAFRpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 12:45:35 -0500
Date: Tue, 6 Jan 2015 17:45:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Bo Shen <voice.shen@atmel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Message-ID: <20150106174521.GM2634@sirena.org.uk>
References: <1420542872-10015-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5KObZtj3Gjpm0OUY"
Content-Disposition: inline
In-Reply-To: <1420542872-10015-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: sam9g20_wm8731: drop machine_is_xxx
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5KObZtj3Gjpm0OUY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 06, 2015 at 12:14:32PM +0100, Alexandre Belloni wrote:
> Atmel based boards can now only be used with device tree. Drop non DT
> initialization.

Applied, thanks.

--5KObZtj3Gjpm0OUY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUrB8xAAoJECTWi3JdVIfQZ0QH/RN2Xsaj280q6aDYrogvgv2g
eKYvDKQISUetCM0F0yXokFD4xwgNQRFmveukB+ZAitdbnJ1bjJr18Wt/bdcosXiY
GmGyt7FR+2tLfw3z0XKSfLFShCTKF7xKY57mCYRNZACCt0PMjkC+ffuCpLiyLcBJ
r6rxZg/WmaFv+4y3J38csxn/i5p3paFtbD6v6OW2xTGc4l1frsD7EHZlQwrT2nyS
3rr0hf2jGqDvQa5/cqshgt36bKtc+D+0E0yx9SwpU7c4Opra5wYFYPcVxRb0YBxe
kLz7ZqeNqnvBdYeuVCX0h50jWnSrX7NtnXdl3MUEistFMHemrPaN4FSJ3msjta0=
=Ww95
-----END PGP SIGNATURE-----

--5KObZtj3Gjpm0OUY--
