Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab3KSSyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 13:54:01 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48960 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab3KSSyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 13:54:00 -0500
Date: Tue, 19 Nov 2013 18:53:37 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org
Message-ID: <20131119185337.GK2674@sirena.org.uk>
References: <1384859269-19801-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2XUWoe1nmt7t49kG"
Content-Disposition: inline
In-Reply-To: <1384859269-19801-1-git-send-email-lee.jones@linaro.org>
X-Cookie: Drive defensively.  Buy a tank.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 00/10] ASoC: dma: ARM: ux500: Obtain DMA data from Device
 Tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2XUWoe1nmt7t49kG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 19, 2013 at 11:07:39AM +0000, Lee Jones wrote:

> If this patch-set could go through ASoC as a whole, it would drive down
> the chance of a dependency mess. Vinod has already provided Acks for his
> parts, so it's just between you two Linus and Mark.

I applied the refactoring patches since they didn't seem to depend on
the DMA patches - they're on topic/ux500 in ASoC but I can easily drop
them or they can be merged elsewhere if required (I'll rebase once the
merge window closes anyway).  Let me know and I can provide a tag.

I'm happy to merge the first few patches if that's easiest for everyone
else, let me know and send them to me if that's what works for people.

--2XUWoe1nmt7t49kG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSi7OuAAoJELSic+t+oim91OAP/3Xf395Qnd57uor+jcolwhIl
5PGxr8dnO8KQnYJ8QLeDl1T6KeoIRKhXOfYxEESIHlW7+rgJja25S0vm2aJUQAbM
gABOlYwLZB+ba00UmGltgkfK0yEQQZY5viKI5zi6Yt+M85zlOSAG8wq27RqiagXY
KAqBjtKC1UA/KhbAkGrC35GaokxuuvoRivrD7BVEng5GDxMKz8RXEadY5G1z2bD6
Vu3/6vizHGGY5f30T9MVGEP6njesQ94fXAJutriYCadsvIzQWArjKzsOH9pfCepc
rmtimnwzewbMOKEIi66aPZHb10T19QeP3S1h2unsSL43tQOY/P2O3NvlnSQ3pPzO
J04oeZ0NFccTvGSUguDtjtxN3oJBDPnrWhT9gIBFAqqzr2KvSzyBbV8/E6VfeNt5
lDql2RNR+4hmcP08RrI7ZRmLub1KiGvptPWOGzA0sBuvVLFBaOpWLajg6SzOxLEY
ME/mrKTDFtz2F4syFfMHH5My/q8D6fv+JWOIxlWdWpq8/Uobihtr+xSH7THXwlcJ
Y7FohmFxWg8ZmHBbaqvOyVmseZ82D6WeCZjuZvzorbnH3kI7nEeWOZ75JbjLbWMK
cKy5odtH8BgdRpKWskrLQ5NI2SmU/xIoOrKFyutQgpUkXyHfReVHxQO0wcMDQi+U
3ckoHw1x8bbNauAJKm3o
=HlK5
-----END PGP SIGNATURE-----

--2XUWoe1nmt7t49kG--
