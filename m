Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbbAENab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:30:31 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36138 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbbAENa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:30:29 -0500
Date: Mon, 5 Jan 2015 13:30:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: nizamhaider786@gmail.com, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20150105133014.GP11764@sirena.org.uk>
References: <1420459263-2190-1-git-send-email-nizamhaider786@gmail.com>
 <1420461363.2652.6.camel@perches.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y62Kqbgmh9Jn6qql"
Content-Disposition: inline
In-Reply-To: <1420461363.2652.6.camel@perches.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] spi:spi-gpio: fixed space coding styple issue
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y62Kqbgmh9Jn6qql
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 05, 2015 at 04:36:03AM -0800, Joe Perches wrote:
> On Mon, 2015-01-05 at 17:31 +0530, nizamhaider786@gmail.com wrote:
> > From: Nizam Haider <nizamhaider786@gmail.com>

> > fixed a coding style issue

> This is a checkpatch defect and not a coding styple (style) issue.

> Please don't blindly take checkpatch messages as dicta.

No, it's a coding style thing.  It may have been identified by
checkpatch but that's what it is.

--Y62Kqbgmh9Jn6qql
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUqpHlAAoJECTWi3JdVIfQEesIAIYlirvI7Fs28AVIVfIjm3u9
g8bS9FQhHgpBpUHtPwLSsLREp13NvRh15v0tQb+8SXMwznXx34gDiy89yvWzRvau
g++RHZ8pmztacgLmWXbVfDCf7QbdpuABwdJI7xGCY9vfYnF4CHVYzaOftM/Xy6oY
dUjLtLig6SVqur/NvWoyNjayO3hiEAvTQ19HdbB7dCM4lV7f2BgNEz6bjQRQl2pz
Ih4rrZVneA7XZ2XjsiJ/7ZRRlTHwSr3fbkbZppwJ46JGNYNMC2/90e+xA387ubwW
xL21Gmmfn+UDjKf96ZIeRt34JHhY1kUklm8DUOy6AGG4XERypQwlYqFUzDQKDdw=
=qjqT
-----END PGP SIGNATURE-----

--Y62Kqbgmh9Jn6qql--
