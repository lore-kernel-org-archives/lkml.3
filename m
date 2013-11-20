Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab3KTUeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:34:11 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36322 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab3KTUeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:34:06 -0500
Date: Wed, 20 Nov 2013 20:34:00 +0000
From: Mark Brown <broonie@kernel.org>
To: Felipe Balbi <balbi@ti.com>
Cc: ldewangan@nvidia.com, lgirdwood@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Message-ID: <20131120203400.GL2674@sirena.org.uk>
References: <20131120175814.GC27423@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOHdEyqYAbgZNeC0"
Content-Disposition: inline
In-Reply-To: <20131120175814.GC27423@saruman.home>
X-Cookie: Drive defensively.  Buy a tank.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: commit c368e5fc2a190923b786f2de3e79430ea3566a25 regresses MMC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOHdEyqYAbgZNeC0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 20, 2013 at 11:58:14AM -0600, Felipe Balbi wrote:

> commit c368e5fc2a190923b786f2de3e79430ea3566a25 (regulator: fixed: get
> rid of {get|list}_voltage()) regresses any MMC host controller which
> uses fixed regulator for functionality.

This is already fixed in -next.  Please remember to always CC
maintainers on mails and please try to write subject lines which are
readable by humans - full SHA1s for commits that obscure any actual
content don't help.

--BOHdEyqYAbgZNeC0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSjRy1AAoJELSic+t+oim9oVoP/0lfe126LNuvhEwFW1mvHlm3
VoO7QFg6lP2OHzgMx7rfvCeFspVumerWIvMFqyGFd8zZdcN1sYN/BVJqg0YUbx1q
ZBQ0FLMTkc0S0c8BPifI+U8T4wTeiYyjrB9AjkOx+xRymR6E9sMjgoLkqm7sB9oe
bpv1FGzu8CzSoEdfm6mfKyhwnIAxHT+mMTCLA1wiC0gUXbYJrDibn1mYaiTamFjQ
4P+cttDpT5AeAwOIBu8sFnAbChB3bLGzTyhu9WkI5maY6RhemsKrWu0n95gP83jo
35AgciUQNdRVwXti2HpE3eEIZASF9uuBwIzBBCJmzU3IE8wccnjQ7z5BG/iAhoGC
h+4B+byBTk8GxrYpi2ka4yxsW03IDaV1/K1xbH6QgKmGwk+Vo0gzf68+lTOdB64l
gLya//KndYHOM3I6b2HSkBzYuPgvOThrYujJ7LoBNZJeEn4w2cLJNEE5qkgas6uv
rjYSgTk1Ct7XuoSF7/NGxSGZ+MmUfsxSJVcj0UXstplCUoZrSzw36N88A1GlGGN+
Pqnygc/rtLyCSSudv8C2RmMCxHRaUIBXY+N1OO/Dq0dyDWsdnc7kqo7aElTNeC/2
xQov1AiNfBOOjtp0C+jpjh0zQvYNk3zAfJgdm8P/T72adMI/QhqRg6KQpwOowgUH
JAsZlWsGYlpy3ev/1kh3
=Qmyd
-----END PGP SIGNATURE-----

--BOHdEyqYAbgZNeC0--
