Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbbAORKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 12:10:38 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34420 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbbAORKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 12:10:36 -0500
Date: Thu, 15 Jan 2015 17:09:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Dylan Reid <dgreid@chromium.org>, Simon Glass <sjg@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Wolfram Sang <wsa@the-dreams.de>,
        alsa-devel@alsa-project.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20150115170957.GD3043@sirena.org.uk>
References: <1421338359-27467-1-git-send-email-tomeu.vizoso@collabora.com>
 <1421338359-27467-11-git-send-email-tomeu.vizoso@collabora.com>
 <20150115162057.GC3043@sirena.org.uk>
 <CAAObsKBKZsvLo9OjzcHiPEPq1iUeog0Bm-jzvxLrkt2X=N5djw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="+Xnt6BZa+I2KmHWw"
Content-Disposition: inline
In-Reply-To: <CAAObsKBKZsvLo9OjzcHiPEPq1iUeog0Bm-jzvxLrkt2X=N5djw@mail.gmail.com>
X-Cookie: To program is to be.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 10/11] ASoC: tegra: Add a control for the headphone
 switch
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+Xnt6BZa+I2KmHWw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 15, 2015 at 06:02:51PM +0100, Tomeu Vizoso wrote:
> On 15 January 2015 at 17:20, Mark Brown <broonie@kernel.org> wrote:
> > On Thu, Jan 15, 2015 at 05:12:22PM +0100, Tomeu Vizoso wrote:
> >> To be used by userspace when the headphones jack is plugged in.

> > I'm missing patches 1-9 of this series, what's going on there?

> Sorry, no idea. They have reached lkml though:

> https://lkml.org/lkml/2015/1/15/473

What's going wrong there is that you didn't CC me on either them or the
cover letter - you should always make sure that everyone is at least
getting the cover letter so they know what's going on.  Never assume
anyone is going to see anything on the list.

--+Xnt6BZa+I2KmHWw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUt/RkAAoJECTWi3JdVIfQA+gH/1KOociYTanGd0y/0grS2qKZ
tROqSwXDCqvvENcy0pL+/XTGGucMNr0KRE3KHHtY5yXsouUq54heZsnM/moaiDf/
fJVuleDfo6xWqTuzQj3ScwQF9aNr1FkN/V/Osqc4vTzi83BLOXCr031SUou0tW01
EGI0691qY+AtOW7o9NVZqd/OLGbQHuQ0dqIFeXhjzYymd+aWUv33sf7Z97BR/GJX
SFEfSa7FaS3eEsgxgsbFroV3nbXrk6rhE07PiYdGvu23VwsvqIPZ1s1wz1IjEhdP
g7JyIzIqfdjDAnC0NMr3Y3xtzbs5Qv2Xe1euDrglbe4ovrOPpA663GGxClCnwKQ=
=f8dJ
-----END PGP SIGNATURE-----

--+Xnt6BZa+I2KmHWw--
