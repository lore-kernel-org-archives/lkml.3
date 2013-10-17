Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755Ab3JQRmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 13:42:14 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52971 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758112Ab3JQRmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 13:42:13 -0400
Date: Thu, 17 Oct 2013 18:42:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-arm-kernel@lists.infradead.org, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20131017174205.GQ2443@sirena.org.uk>
References: <1381681071-6021-1-git-send-email-wsa@the-dreams.de>
 <1381681071-6021-5-git-send-email-wsa@the-dreams.de>
 <20131014131748.GU2443@sirena.org.uk>
 <20131014145629.GA17351@katana>
 <20131014163753.GF2443@sirena.org.uk>
 <20131017164331.GA2896@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XWGl2Oocib6fGxwW"
Content-Disposition: inline
In-Reply-To: <20131017164331.GA2896@katana>
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/4] sound/soc/atmel: don't use
 devm_pinctrl_get_select_default() in probe
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XWGl2Oocib6fGxwW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 17, 2013 at 06:46:14PM +0200, Wolfram Sang wrote:

> On the other hand, MAINTAINERS information gets overlooked and/or could
> get stale. Thinking about it again, it is probably less work (at least
> for me with i2c) to create a git-hook fixing the subject line than to
> always nag people.

That doesn't fix the main problem which is getting the mail looked at in
the first place - not having a subject line that people are looking for
makes it easy for things to get dropped on the floor.

--XWGl2Oocib6fGxwW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSYCFqAAoJELSic+t+oim9Q+YP/RtH19EYuBUnkdv0M8N9vO7N
9H0nBh7lhunYEyOvvWDCAECtMJeWcxSgulfKSbaZACtOVOTX33T90qQ2e0cBTPTN
e5bjP+QR6ZeQ1E4I2h229qAt0y+CM9hbSQau2t2Xmsl6ofvTT8FL0qXBcUpkMPQi
zBE1WCUKj2nzAfSKVPKHawnEZw1qXLoLtxe6SMxiVTCvo7ZAAVXCAD2s9CX+vbOk
3z1YaBQ+8Hg9zT7/MHWSsx7c1Kwj7kd48f+Lv6CXc5tau/he7OjwZG9DDSgnsIgc
7yeA7zDeze8r6kiIUr6Ty+Cv+ZnemS/90NNeicvqViuXxEZXdouOZ9ahCoRgxmmV
A31Ucqp67M5mnVEtB9oKXyOoMhk/iUhN38oRJJu/0kN5X74nwY6VFj5gFI7RtIiM
JUDBs4LEUha1y/fZHCaGWkoyTpv/FT744+Woemuey2exmj1Bg+xOSuhGVdCJzYdA
72x7i55eVHPD5iH7BkAqmkouyWA5t32fvMJKaEtbC6PGnCbly92Sf4AQFCE7bBOO
X8xuJqOxXyf7O5/z3JgVQeVDDihw5sjsBBMjBWuHdwZGhCOP32MgRyi46JI2B100
lUG6lObaECaWv3pJzCvtqtegeyxFdkTnSD5ltqkXOH/C7QDJ9fhDgQJyW9YHMcYP
Ix1+ommmTz6ZUjVWjUsO
=AE10
-----END PGP SIGNATURE-----

--XWGl2Oocib6fGxwW--
