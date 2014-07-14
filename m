Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbaGNTRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:17:44 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37448 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010AbaGNTR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:17:29 -0400
Date: Mon, 14 Jul 2014 20:17:11 +0100
From: Mark Brown <broonie@kernel.org>
To: "Murphy, Dan" <dmurphy@ti.com>
Cc: "linux-sound@vger.kernel.org" <linux-sound@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Message-ID: <20140714191711.GI6800@sirena.org.uk>
References: <1405093489-11897-1-git-send-email-dmurphy@ti.com>
 <20140714184321.GW6800@sirena.org.uk>
 <00FC9A978A94B7418C33AFAE8A35ED49D80B10@DFLE09.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aJFFgG5QZHt5jcrP"
Content-Disposition: inline
In-Reply-To: <00FC9A978A94B7418C33AFAE8A35ED49D80B10@DFLE09.ent.ti.com>
X-Cookie: Above all else -- sky.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v6] ASoC: tas2552: Support TI TAS2552 Amplifier
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aJFFgG5QZHt5jcrP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 14, 2014 at 07:07:06PM +0000, Murphy, Dan wrote:
> On 07/14/2014 01:43 PM, Mark Brown wrote:

> >> +config SND_SOC_TAS2552
> >> +	tristate "Texas Instruments TAS2552 Mono Audio amplifier"
> >> +	depends on I2C
> >> +
> >>  endmenu

> > Keep this and Makefile sorted - since this is a proper CODEC driver it
> > should be in with the CODECs and also sorted in alphabetical order.

> OK.  I was trying to stay away from a conflict by adding to the
> bottom of the file.

The whole point is to avoid conflicts - if everyone adds at the bottom
of the file any two adds are pretty much guaranteed to conflict either
on application or on merge.  Sorting avoids most of these and makes any
that do occur much clearer.

--aJFFgG5QZHt5jcrP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxCy0AAoJELSic+t+oim9ZC0P/0xXUNawujyd33X24/UV5qSp
aloiKAIzyiIrQyCudGVQT541+Kida3csZi8U+xGD5AGrxohCR44sFdcZKfmSeIWH
C1rJcmMdTrfv3GaPgUYJ5Vlq7UK25C76JjZ0x0VIuG2Tnaz7tbIPawdbV4ResHEq
YWi1GKgqY59tGI8KQGM2vpg8LPa7n+MUQEA6XkBMTmqX6u631XWpHzo1h0UpcZvH
ro48VsVg1wrUXixlQozPw8wyfJDvs72L/avOqx8XmeSVuIGNAHQNisBaCE1yPzhH
reaYLPafKra3Eb/8gBuCUqSsqgOwKElfCsZVU8qoCU+yX4rsPBo1f+idgWdp+ASZ
biy2NyNhnTqP8hLa+iNjArxHR+axUSPQvlXMpJz6GHBDK3+SIRkrcSTLzGo4EQ5w
5OLGfxllX1u51YnjGhf5yVoXeXee4oNftPWVxrsslWSfOehAdZ5yj9W/nskweiA+
xWz6EGMmq3tbHXExh7ZXjeAVlfoJmCRkOBEt8/EhQUtCbH2JEICQeXFtVROOwP1r
/rDNp/nfsl4mERZjQu0/kmAXA5VoL9K+3fBRpSybSAii3B8fpy3DinwVcIc2v0nc
+4m7TNfzfcFJ/tqLr5DKK5iPNaqNqUAY/cJcCG2UvG3ZD7r3wvJR8GO641or3KKB
i3XvoKw4thb1TRR2GB3F
=g9z5
-----END PGP SIGNATURE-----

--aJFFgG5QZHt5jcrP--
