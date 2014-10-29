Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbaJ2VDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 17:03:24 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55907 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbaJ2VDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 17:03:23 -0400
Date: Wed, 29 Oct 2014 21:02:50 +0000
From: Mark Brown <broonie@kernel.org>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: alsa-devel@alsa-project.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>
Message-ID: <20141029210250.GM18557@sirena.org.uk>
References: <1414436825-19416-1-git-send-email-jcmvbkbc@gmail.com>
 <20141027193229.GE18557@sirena.org.uk>
 <CAMo8Bf+Z9V8mkiC3JOupPQmi1EJUDKrb1qcNncDbsEbhjigbww@mail.gmail.com>
 <20141028154224.GX18557@sirena.org.uk>
 <CAMo8BfLpJ0bdmaFt9+gLQ_kEjB68XdjAJUw8f8s=Owv46h_yDQ@mail.gmail.com>
 <20141028173853.GD18557@sirena.org.uk>
 <CAMo8BfJfRTo7puxeafyBnaGWhY38o6ktsSBugcSmSaMYUArcyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iPQdpvQZPHatbiDE"
Content-Disposition: inline
In-Reply-To: <CAMo8BfJfRTo7puxeafyBnaGWhY38o6ktsSBugcSmSaMYUArcyw@mail.gmail.com>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: add xtensa xtfpga I2S interface and platform
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iPQdpvQZPHatbiDE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 29, 2014 at 05:23:15PM +0300, Max Filippov wrote:
> On Tue, Oct 28, 2014 at 8:38 PM, Mark Brown <broonie@kernel.org> wrote:
> > On Tue, Oct 28, 2014 at 08:00:45PM +0300, Max Filippov wrote:

> >> > It's also about ensuring that the code is cleanly split up so that
> >> > someone can actually go in and add the required support later (and TBH

> >> Can you point me to an example of such split, so that I don't write it in
> >> an unusual way?

> > Essentially all drivers are split this way...

> But all of them have DMA registers and I2S registers completely separated,
> right? How do I share registers between pcm and i2s parts?

Just keep the code physically separate so the DMA bits are hanging off
the DMA operations and the interface setup bits are hanging off the DAI
operations rather than all mixed in together.

--iPQdpvQZPHatbiDE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUUVX6AAoJECTWi3JdVIfQ4bwH/0MQQwX7Kv9+t3mTxgRnzRRJ
H1NR2eZzlsVxnT/KuwsL+hs+R/RurgoSLaRTKgdJ2i3iV1+adwLQVuA21C7/bVAp
jhbzz22dvuwe+rk0mUs4afZ+6gFt4/M5P/0gJuQpUVbRiqDXssNRcvdw43CJR8CF
kSmyWAFx0jweudpotKLwwn2uF3eyEfqoQry3Ot6QuZM30xtW+b2F2d2oSq0/QWEE
HjrmCgCgYEZKlB7smOT0djbKYjCFRXWAjVTaDw+I815zqlDUowmtFucsM7eZVGaU
MrKWmnlCXYnwFrMYuqE0lVsKtDIjrNrKb0Suo6wqZP4vo0m8MDCCiDg7D1KqJvs=
=JS29
-----END PGP SIGNATURE-----

--iPQdpvQZPHatbiDE--
