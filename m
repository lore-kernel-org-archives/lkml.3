Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966553Ab3DQONY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:13:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40401 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966321Ab3DQONX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:13:23 -0400
Date: Wed, 17 Apr 2013 15:13:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: alsa-devel@alsa-project.org, Russell King <linux@arm.linux.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] sound: ASoC: multiple DAIs/codecs on single audio stream
Message-ID: <20130417141321.GU13687@opensource.wolfsonmicro.com>
References: <516D8E24.9020308@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f6M9UaX53EEZorp0"
Content-Disposition: inline
In-Reply-To: <516D8E24.9020308@gmail.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f6M9UaX53EEZorp0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 16, 2013 at 07:45:08PM +0200, Sebastian Hesselbarth wrote:

> The controller has a dma controller for one playback buffer. It can
> play the stream to both I2S and SPDIF interfaces with independent mute.

> Now, for example, I have a board with i2s codec and spdif tx diode
> connected to the above controller:

> DMA (platform) -+-> I2S (dai) ----> I2S_Codec (codec)
>                 |
>                 +-> SPDIF (dai) --> SPDIF_TX (codec)

> Is there any way in the current ASoC API to have the above setup?

As discussed on IRC this is probably best represented using soc-pcm at
the minute.

--f6M9UaX53EEZorp0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRbq3zAAoJELSic+t+oim96qIP+wcXCDOs1QeWiJbjdobSnfqV
7yqyA4/jwi8lmu4Gn8HG5YWSi73sjmiN+QQDex4G+QnonmhPb6gmP6v66YDSRXLg
fofKBqGb+FcZ65yDjI8D2RvkO+q9URVjUGVhHiw5HLrOMz6OBBtdxuqd+E7euLzn
Biw/pmttYwrH5N1C5GGeVI9QeZDRrWo5DOF6jYOQI1IckStBYHiuaJRmiC8kWodv
4r6ETrjOIycm8B3NkqYk/QE5YVySVzxV9X3nL4utsRWlEm6l1n6oI/Usq1dAlfMq
z+D9uC8Zi6jgMZ58o2t5ll36CG/fWc5q6qZSyU9eUnyjwnW8suKQU2xObx0YedAq
9KKFjLEbmwDuHtREafexkG3zKotvLI1IvUNa62FOpwjZNUBonDbHF3yKJE7FaYpV
9HJtV9AY6w5RPLNHyD74mfsfgozB5HQtokwkc0vWtNbBuzzyiY31pjUeGa8rrKjP
OGaHqkhkc4I+sf1IaVm9IodHZs3n6vwDc5xn9lXTUztuBWfdMpDStLqfJENdxH7d
Cb7KBGZtHTpRVieaMt3LyCHgVhGieocZC8GnRTBV9cogtitpbs2DwBLyJkIe06my
5+S1mjnYG7g9MKl3RQFubli022YuYEBBX1cXdGb4HL2OJ6J0+bRF9EJaJkI4MS3E
mHCvdaire9Ps2iRkdexp
=pq34
-----END PGP SIGNATURE-----

--f6M9UaX53EEZorp0--
