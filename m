Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbbAFMBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 07:01:08 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38028 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbbAFMBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 07:01:06 -0500
Date: Tue, 6 Jan 2015 12:00:49 +0000
From: Mark Brown <broonie@kernel.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Bo Shen <voice.shen@atmel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Message-ID: <20150106120049.GX2634@sirena.org.uk>
References: <1420542872-10015-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TXv8ADjWKuT9E31y"
Content-Disposition: inline
In-Reply-To: <1420542872-10015-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: sam9g20_wm8731: drop machine_is_xxx
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TXv8ADjWKuT9E31y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 06, 2015 at 12:14:32PM +0100, Alexandre Belloni wrote:
> Atmel based boards can now only be used with device tree. Drop non DT
> initialization.

This doesn't apply against current code, please check and resend.

--TXv8ADjWKuT9E31y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUq85wAAoJECTWi3JdVIfQ6NEH/1p4xg9515C4jqbNUkm6lL39
cAxhvxiIqAHl/clla+v+aXCY3c0zEtnaoLE9u6Lwc79mlS8ZQx1g3iaC8UEvIpNn
LxD08H2UfTJ4PA2fCdQKEh2iFXPKG83d99uJ/O2H4Nk6orURye3dD1eA9w+Hv/GG
jJPqrJDbSq54DzOQy1P2fuSjJieoLEwQ5X+YDBQcz0xvbYPn9DmUBrGPOO82AkpT
7vQeWT1BsHP9JslrAOWAOWg0W7awxNYFoDhD/S2zAUwyJRbBzIp6HtBaQD7y2poC
zgAE9Wz3dzfHMUNXoT4V950N5hZnmV7EHQ3RLl0JikCNf+15iShgXVtcBbCGGs8=
=j8+a
-----END PGP SIGNATURE-----

--TXv8ADjWKuT9E31y--
