Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933796AbaJUVZC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:25:02 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40636 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933551AbaJUVZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:25:00 -0400
Date: Tue, 21 Oct 2014 22:24:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141021212438.GB2344@sirena.org.uk>
References: <1413903675-3363-1-git-send-email-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZoaI/ZTpAVc4A5k6"
Content-Disposition: inline
In-Reply-To: <1413903675-3363-1-git-send-email-linux@rasmusvillemoes.dk>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.174.112.79
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: dapm: Remove redundant cast
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZoaI/ZTpAVc4A5k6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 21, 2014 at 05:01:15PM +0200, Rasmus Villemoes wrote:
> Both path->name and e->texts[i] have type const char*, so the cast is
> slightly confusing and certainly unnecessary.

Applied, thanks.

--ZoaI/ZTpAVc4A5k6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJURs8VAAoJECTWi3JdVIfQ+jgH/13sYOK9yAppjGlyOLkAu7aI
VwO6zIfmYVP+yg1j+1foRqHLwiKCTJ55TYla68j7ZopieOa61Y6XSrrerovJhKRa
QvGZ9s9n/l9i4geXibGaa2bFo6c1cv1qAzc0dDhPkRWePFV8FYCgzmUxI9OWr53U
lOru4mw3BXq7elnyM8hg2n+3BaVmEvpNHIqjZy5KKstrbJSB7QW5Ehtr/wIeHoKi
H7IL7VUT/seSlIyBFgt6x8AID1ZhYBh+MRBqan2bkwSri7q+oH/XMd2KavYzrXqt
b3OEcxyeg+9kwORPE9J+i4xtQfac18HgB/sU0RlMs5gHXSb0SorgAX5t+dX1mQs=
=DWqT
-----END PGP SIGNATURE-----

--ZoaI/ZTpAVc4A5k6--
