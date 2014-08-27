Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaH0HGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 03:06:21 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35410 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaH0HGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 03:06:18 -0400
Date: Wed, 27 Aug 2014 08:05:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <nicoleotsuka@gmail.com>
Cc: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        Mark Rutland <mark.rutland@arm.com>, "timur@tabi.org" <timur@tabi.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140827070544.GO17528@sirena.org.uk>
References: <1408950961-19177-1-git-send-email-Li.Xiubo@freescale.com>
 <20140826090426.GA31558@leverpostej>
 <cf0e029ae99d4b48a432e5c1669ddc15@BY2PR0301MB0613.namprd03.prod.outlook.com>
 <CAGoOwPSTJaT0UA4yaYR0x49C8UHbmKAR8PzUfV9ZWVW5XBfV5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L7FzFY/QTOVRGZhn"
Content-Disposition: inline
In-Reply-To: <CAGoOwPSTJaT0UA4yaYR0x49C8UHbmKAR8PzUfV9ZWVW5XBfV5w@mail.gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl-sai: using 'lsb-first' property instead of
 'big-endian-data'.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L7FzFY/QTOVRGZhn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 26, 2014 at 11:53:56PM -0700, Nicolin Chen wrote:

> That's why I suggested previously: mention it in the commit comment.

> People will have no idea about what's the exact reason for this change.
> Any functional enhancement? Or a bug fix(more likely for this one).
> I'm not sure what I described in the previous mail is correct or not.
> But you probably should have added it into the commit comments.

Right, this is a good idea - make sure people can understand what the
goal of the change is.

> And Xiubo, this patch still hasn't fixed the issue of breaking the old DT,
> although system can pass during the probe() section.

Indeed.  Please do this.

--L7FzFY/QTOVRGZhn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/YNEAAoJELSic+t+oim95jEP+wS8FSfeBfcLvPykWPIxvmXZ
YnXCdbhejI3OsDwF2nsebHwEMrG05e7lTHn+peCpBw6HKwNgqWV+UGnsJPXV7mMV
FmMqco+xxBOpwgRoUHxmW3QOp+jBZ6h29cz2RaKCvcsW4OUvImpfAIzqKPXdfC/Q
0Gwax6pH9uJLHPyX6dMkexoInFaZIfYNTyiwwxwgcXtMNbibjsamIzN4ifArQMpX
lz4jGsOwJD/TUVbd1mlPRPuQgSqcJr9PQM3YeVP6nv4qURWzPNazYPEoPTwVwccf
JbNT9x6iirUF7cUzDhQjU7eJBRL0WzUDST7poEZ34ZRQzjb7RjLfcB1Tmu6Rr5qG
4dpx3dUH2ttdyeciEzHFeBo2ZaRQ16sSdzE/MYq3H6UtEJPQF6SntwCynaHv+SFf
fngRhOgK97E7qXngoTw1ungqS+a18w6l/XA4Ju2hg/puBwVJYDVmb9yAbnmQWcDF
DUtejwJcmaAjx6WLlO7zwfJK3j+oS7WXhcVPC4Ro/D70u7kJEm0LdmhY8mUlLm3J
vYV428zp3qHmqirlxrtPt4vSwU8rCormVOnQLLSUKikhuTvozXePigICOJLVWiXK
41EvSXtR2ZVcWcUu4VtgQyu5DD3W54CI3SPa06STwAF/TXF7PAAfXAisBJSZWYZz
DgV7PzGAyZoba/WwT9QX
=+g6M
-----END PGP SIGNATURE-----

--L7FzFY/QTOVRGZhn--
