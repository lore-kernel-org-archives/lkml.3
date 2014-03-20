Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029AbaCTLsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:48:52 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56937 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757912AbaCTLsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:48:50 -0400
Date: Thu, 20 Mar 2014 11:48:29 +0000
From: Mark Brown <broonie@kernel.org>
To: Arun Shamanna Lakshmi <aruns@nvidia.com>
Cc: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Songhee Baek <sbaek@nvidia.com>, srwarren@wwwdotorg.org
Message-ID: <20140320114829.GC11706@sirena.org.uk>
References: <1395186692-11735-1-git-send-email-aruns@nvidia.com>
 <20140318235941.GT11706@sirena.org.uk>
 <781A12BB53C15A4BB37291FDE08C03F3A05CB21E46@HQMAIL02.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tHoXcMLEIE7biFzN"
Content-Disposition: inline
In-Reply-To: <781A12BB53C15A4BB37291FDE08C03F3A05CB21E46@HQMAIL02.nvidia.com>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: Add support for multi register mux
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tHoXcMLEIE7biFzN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 19, 2014 at 04:44:00PM -0700, Arun Shamanna Lakshmi wrote:

Don't top post and fix your mailer to word wrap within paragraphs, your
mail is very hard to read.

> If each bit of a 32 bit register maps to an input of a mux, then with
> the current 'soc_enum' structure we cannot have more than 64 inputs
> for the mux (because of reg and reg2 only).

What makes you say that?  We currently have devices in mainline which
have well over 32 inputs to muxes.

> For instance, the audio xbar (AXBAR) module acts as a mux selecting
> various inputs (reference: Tegra K1 manual).

I don't have access to non-public nVidia documents...

> The number of such inputs increases with future Tegra chips and so
> will be the need to control multiple registers per mux in DAPM.  We
> have 2 options to achieve that.

Like I said in my previous reply I would expect to see some users along
with the code, extending the standard helpers to support this would be a
much better idea than doing something driver custom.

--tHoXcMLEIE7biFzN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKtWKAAoJELSic+t+oim9fR4P/RlVhbBfCdEcVzStyG0k7QHP
B6kPoG2PvUSiJxtmpUguV0ocWt292Gnn0IJwKSv5bZedxG0RL5zLDd2zyN1UEngd
qcGUbMyrYb79bx/Yq86mK7jlikLSfXClqbkauPb0CzHnixA5xnf+1ZVPJnaUFPP6
xUqOJcOpWr75AOX3tzCktD34CQRshQ4GJIyl3AzyIt5bqVjZlBmwLh4YKVfPphOe
3UTua36Kv36oZvBbaiPIRKUWu5K7wcAmAIFAMjiRYW8QFrlzJhXTNL/YsKbPR28e
zU27QZWTIpvagWUW/rqSY+9O76pDJc6az+SwbgFaFLpkBwZfKjmi56pjEDW5UIYE
uWBLCglzDCZNm8SN9vtqflKnlf3Cf+VV6MwzkNU2lipP5pKEvLkhZx0PiDEKq0lU
WJfmM1b6+24YYnWSt+6gCF99KAdfUGahnEN6iDcBWbKX8H8iI8+340wtVj7TXywG
K89QskWUDANHfm2giX/EDeIGzLdaMs9/dc6BA4A7v65jkzyjA8F5V9/mLPwDDbkE
en+B2AvJGwc/4aAxE0fDGz8MPVg32le4AZRvrOOintK7mz5yW9ZNrKT7vwP0iJEt
6xPLttf+pIKsAiud+6+3XUZBRjUg6hGkQsoFhStdZkLO77iUijbMCgoJrdr81Fbi
CsmUbDfrzQk27jtSF5aL
=/EgB
-----END PGP SIGNATURE-----

--tHoXcMLEIE7biFzN--
