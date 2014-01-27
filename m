Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbaA0Uyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:54:55 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60388 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbaA0Uyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:54:53 -0500
Date: Mon, 27 Jan 2014 20:54:37 +0000
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jean-Francois Moine <moinejf@free.fr>, alsa-devel@alsa-project.org,
        Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>
Message-ID: <20140127205437.GC11841@sirena.org.uk>
References: <cover.1390813480.git.moinejf@free.fr>
 <d99e90932aad1a644fa32ff22fd2cb56b830341b.1390813481.git.moinejf@free.fr>
 <20140127204441.GZ11841@sirena.org.uk>
 <20140127204915.GC15937@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R4k76f8oNWH5pGim"
Content-Disposition: inline
In-Reply-To: <20140127204915.GC15937@n2100.arm.linux.org.uk>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/4] ASoC: tda998x: adjust the audio hw parameters from
 EDID
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R4k76f8oNWH5pGim
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 27, 2014 at 08:49:15PM +0000, Russell King - ARM Linux wrote:
> On Mon, Jan 27, 2014 at 08:44:41PM +0000, Mark Brown wrote:

> > Can this parsing code be factored out - it (or large parts of it) should
> > be usable by other HDMI devices shouldn't it?

> Yes, preferably as a generic ALSA helper rather than an ASoC helper -
> I don't see any need for this to be ASoC specific (I have a pure ALSA
> driver which has very similar code in it.)

Indeed, definitely ALSA generic - ideally we could factor a lot of the
integration with the video side out.

--R4k76f8oNWH5pGim
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5seKAAoJELSic+t+oim9C8IP/04prbC9qucCblOEYW5TSoX1
q+pRcO0hrA7XLuD3VoJH1XGnIGUC41G/ApPtYjIg6nfzOjQV6g3eetMHiaU7YpX3
fiTYTFxz0aOeDO+xOy56YqgXcKX1JduEd0eX/p8BJPkASIcb/Mr9WSK2zUKFLpXD
O5FgHKN+HNaTR9s61j42DhT4qntWotJVjq3hso59Mm3ykMA50M2eVO58zmc4nsse
MwlTCdW0Vu1SiXU7VU0OapStZ0AWgggWPDPECfpwJZfLU4uLtPaUWAK/3CNmbVOF
m/0PeH2SZnHbooHUM4whSKJhTo4es9PpIbwUbrYLGqp8aM5eE2DNB2bWQ0qCayCI
CVrhWtre6Abr+yye9i+EAxDlVybJus3IohRtLA0kfivgNkPD4bbj9+yRdCehcbVF
EYX60ViW/O+9FOK/GFvA7FnoYBGHJUdlttEHPXNQYQfyTy/TPv1LF/x3ZlREi7Wc
LYQmLj43RRozr4H5VpDTbogylgDZE09tt42o94U787F+pGdCqxam4JO7ZRibIO+i
R5b8WDcp2TQWvNXqrv977/Imk7kM1myKco677oi4PJFRlWpHQ74ggm3E4AwTIaqh
27S/oWhlD+wYwkVZDhp0dOpeks3B9xIAT4x3XittHmvHOxDMKPXRDSrdZWa0iszE
uHyqm/ojCOc/nRzf/v4+
=JGqi
-----END PGP SIGNATURE-----

--R4k76f8oNWH5pGim--
