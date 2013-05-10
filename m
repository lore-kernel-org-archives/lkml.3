Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab3EJK4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 06:56:30 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39850 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab3EJK43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 06:56:29 -0400
Date: Fri, 10 May 2013 11:56:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Message-ID: <20130510105620.GQ3200@sirena.org.uk>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
 <1368173847-5661-43-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OrT4iOlIQZp3kw4S"
Content-Disposition: inline
In-Reply-To: <1368173847-5661-43-git-send-email-wsa@the-dreams.de>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 176.12.107.141
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 42/42] sound/soc/kirkwood: don't check resource with
 devm_ioremap_resource
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OrT4iOlIQZp3kw4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 10, 2013 at 10:17:27AM +0200, Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--OrT4iOlIQZp3kw4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRjNJRAAoJELSic+t+oim9LMgP/jywx9NAjFcL8jhkepKJGZ5s
ghvVXPjgCNTzxZ5U4/3ggS3l2zrv0yQ332KUU4cSMqMnkV2F6ge6ecO4qpArbffF
rqK2tw811plfTTR/TN4+PBnJgfslyRyApDCTg7xmqzndVCdaVnTjM6OHKfZ69pea
dd02q0sUSnI2Xv/f1EntMqWesqQ/YCoFp/hFAHEwK4ng8wMW7kxYbI3Pro8SJFMR
IxPH48Nf5lAZJHSbOtz8wS0d3F+rAgeZGO+IXH9+wUrRFVoNPrh+rP1PoikNoXho
IXjARjc1rbekTgfd5Jhx4P9x8wleiQisT5it4FBtfWwAROXCUrfSAWjmCMJHrCp6
yh7HVLlL/DJTwCj6NEBmx3j9CXXnZaZ+rRvKbj1pnBD+O8BzI8JVUp3dfNDso91X
hL1bI5ZcfZ+wSvSR6wCeAWXLv1uAaBNDBttLjNSjy3kmhTRgbA59rh/i2RM36tCp
DlGymaJzwLzBCoP07ozQPFutKoodgHmLBjoMty4AxQf4yXdh8f/BZC4azBJjWN7z
/8CPjrphHU8hlKWHTn7NmUV+1Po9gWpoAhNgjyGOu6TicuDDeEQ7NpQlnH0bLD7N
uka1d7EWvtsDqIxjoh3wfH+4VCl9/OKoxFR92kFryAtgw6tbhaGoso/XDZeZLj36
ZtcHQMskfb05ISehHbcU
=yxO3
-----END PGP SIGNATURE-----

--OrT4iOlIQZp3kw4S--
