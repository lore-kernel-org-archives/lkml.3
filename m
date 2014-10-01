Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbaJALqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 07:46:16 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56414 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaJALqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 07:46:15 -0400
Date: Wed, 1 Oct 2014 12:45:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-gpio@vger.kernel.org
Message-ID: <20141001114555.GV4273@sirena.org.uk>
References: <1412142466-14932-1-git-send-email-pramod.gurav@smartplayin.com>
 <20141001113809.GT4273@sirena.org.uk>
 <542BE9E0.3080007@smartplayin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kM/PxlMMHsUUNZZW"
Content-Disposition: inline
In-Reply-To: <542BE9E0.3080007@smartplayin.com>
X-Cookie: So you're back... about time...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: remove use of gpiochip_remove() retval
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kM/PxlMMHsUUNZZW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 01, 2014 at 05:17:44PM +0530, Pramod Gurav wrote:
> On Wednesday 01 October 2014 05:08 PM, Mark Brown wrote:

> > Applied, I'm assuming that the API change is going to be introduced in a
> > future kernel version since obviously it'll break the build otherwise.

> Mark please revert the changes as these are already present in
> linux-next master. I realized it late. Sorry for trouble.

Done.

--kM/PxlMMHsUUNZZW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUK+lzAAoJECTWi3JdVIfQCtUIAIONApW90+eh2RzVUdgpQufr
/KZOAzqcY6qItvrvARtwS2wzr5fS4Jm6kpAGyFdcpCbtrKtu0/fICBm7Zby1lNRO
6fGdBXzsLbOGW1e68s3hCHSXD3OApcSIYIyrKHRK3Wm3smMfFeHn8EN2xRhsnWRC
7+ak43OXNTkBmQiQ6Yvl3+ujeyMTYDwdKL1q6quut/RtPeg24grvcscaXxrFzNBL
4+IQo07DofqEZI65i0ydw4mGVGrMhGCVDaeOH4g8hvFduBbkTRVV/WSIi7Q5yHEU
XFbQH35CvNhLBEqeWXe9qgCLdE5/wyOs8Emthh/bc0chgeUfImlTSpT+Mmwo6c8=
=/vwW
-----END PGP SIGNATURE-----

--kM/PxlMMHsUUNZZW--
