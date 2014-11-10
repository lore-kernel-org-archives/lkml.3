Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbaKJT1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 14:27:10 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57769 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbaKJT1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 14:27:09 -0500
Date: Mon, 10 Nov 2014 19:25:39 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Lars-Peter Clausen <lars@metafoo.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141110192539.GK3815@sirena.org.uk>
References: <cover.1415562021.git.moinejf@free.fr>
 <d5d74f6993e9f2392008a27a2938c58d47dc8062.1415562021.git.moinejf@free.fr>
 <20141110190332.GG3815@sirena.org.uk>
 <20141110201254.65674552@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AMEHvcA7tHoZVye7"
Content-Disposition: inline
In-Reply-To: <20141110201254.65674552@armhf>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/2] ASoC: Remove 'const' from the device_node pointers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AMEHvcA7tHoZVye7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 10, 2014 at 08:12:54PM +0100, Jean-Francois Moine wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > Did Russell write this patch (in which case it's missing a signoff and
> > his e-mail address above) or are you trying to say "Russell King
> > said..."?

> Sorry, that was "Russell said ...".
> Do you want I resubmit the patch?

Let me look at the change, I didn't do that yet (what you wrote looks
awfully like the patch submission format for sending code someone else
wrote...).

--AMEHvcA7tHoZVye7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUYREyAAoJECTWi3JdVIfQOcIH/R4OtaBEhnS7rt7ToCgswYjA
yiStjkk3UyuUHKF6Ec2QAdSGF50lZAYSHMsQF+tIC1b7vVg+rWLQjCBFTJg91jKE
sWQau96W6FY5V/1Q6i6dzA0OgYWDunpq5YXiEp+6B/2afDcLb/SgCWBdturDj3fN
g+L1Km86kpYOJqk3hHd+G2LTgR/abrEotdpr9uo44L9LcCVB1ubjEwlXRqGar1Pw
C6Dgwi17Swkjl7qsXH7F8H9VI/rPQLfzFM2SrXRYyXOGxkn1SqoZw/0f49Zdu3NB
4pDiD8Hf8xcL5UvbS0iejphbGasqwrsUzZFqn9CW8F/FVLQbdWWaDWSM1nFTP8k=
=0aLE
-----END PGP SIGNATURE-----

--AMEHvcA7tHoZVye7--
