Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbaLVNsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 08:48:52 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43920 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbaLVNsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 08:48:51 -0500
Date: Mon, 22 Dec 2014 13:48:23 +0000
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
Message-ID: <20141222134823.GP17800@sirena.org.uk>
References: <1417914095-26553-1-git-send-email-jcmvbkbc@gmail.com>
 <CAMo8BfJCPU_ZM0w2Ry9kjU3O+HcWEmp_wgZ44oC7gBLW8DV5jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5/6IVfYouxg+lu1D"
Content-Disposition: inline
In-Reply-To: <CAMo8BfJCPU_ZM0w2Ry9kjU3O+HcWEmp_wgZ44oC7gBLW8DV5jw@mail.gmail.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 31.51.36.65
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] ASoC: add xtensa xtfpga I2S interface and platform
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5/6IVfYouxg+lu1D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 22, 2014 at 11:39:40AM +0300, Max Filippov wrote:
> On Sun, Dec 7, 2014 at 4:01 AM, Max Filippov <jcmvbkbc@gmail.com> wrote:
> > XTFPGA boards provides an audio subsystem that consists of TI CDCE706
> > clock synthesizer, I2S transmitter and TLV320AIC23 audio codec.

> > I2S transmitter has MMIO-based interface that resembles that of the
> > OpenCores I2S transmitter. I2S transmitter is always a master on I2S
> > bus. There's no specialized audio DMA, sample data are transferred to
> > I2S transmitter FIFO by CPU through memory-mapped queue interface.

> Ping?

Don't send contentless quoted pings; they only add noise - if the patch
has been lost they can't be applied, if it's waiting for review then
a nag is just yet more e-mail to read.

--5/6IVfYouxg+lu1D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmCEmAAoJECTWi3JdVIfQ4lEH/1VozZEL0nqvPHrMlH4eDs82
hYxbairXMdVhdcUY0uKrCyve6XVWYhCKwSODlWoDKTUaaPmzSTNLj8wHC6vh1xEL
ta2GJdKcE8JBW1dTlGNi3qjE6I+apvfleg36bDLfGZOm3Gy4G51OHoO3gbxGsMtb
hpFZJc/yvLTiawJ/rXlpHPTIg1o7zW2d8bd6Jip9XkGTKSD4kMWS4yW9hSYxDT+N
TLF7kJBnEprf3Xycv3EyK7xRm6Y/f59xtb7thhCwdLH/6dqax0TRjkbp/d7bl0H7
KIgOnlJxSmX8sm0Ha8aB1F/VjVWaGgjlpneCxnMRgFAqEjZsgzQWZRDjgT0+A74=
=Nabw
-----END PGP SIGNATURE-----

--5/6IVfYouxg+lu1D--
