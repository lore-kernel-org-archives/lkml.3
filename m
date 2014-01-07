Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbaAGOTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:19:34 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48288 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaAGOTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:19:24 -0500
Date: Tue, 7 Jan 2014 14:19:16 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Message-ID: <20140107141916.GG31886@sirena.org.uk>
References: <1387468508-12286-1-git-send-email-lee.jones@linaro.org>
 <1387468508-12286-2-git-send-email-lee.jones@linaro.org>
 <CACRpkda5bQ37OCtO17hj_tVrkAdTXA4-DzgBTaFmuswvb0h9fA@mail.gmail.com>
 <20140107141154.GI3182@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DeaqLsaJcuYlI8Od"
Content-Disposition: inline
In-Reply-To: <20140107141154.GI3182@lee--X1>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 01/11] ARM: ux500: Don't use enums for MSP IDs - for easy
 DT conversion
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DeaqLsaJcuYlI8Od
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 07, 2014 at 02:11:54PM +0000, Lee Jones wrote:

> > Acked-by: Linus Walleij <linus.walleij@linaro.org>

> I'm happy with that, although I haven't heard from Mark for ages.

> Mark, are you still tracking this?

Yes, I've been waiting for both Linus and your testing of Takashi's fix.

--DeaqLsaJcuYlI8Od
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzAzgAAoJELSic+t+oim9Y50P/iSvBGJfJxBowlIRAECsFnZy
CcOPtBFy6/H6G20Byfu34AsdrhNRKkjxe12bKLPND0avKYjTOj3u+fQp11ajNKSQ
0EMKicSk/8Dwb8hG7gY9ZPUk8zLqMs9QyggWBO1yghFVxIwwYHKOjw8lSSaCJv9E
9uaUinhqyVE22POjnUeoewP5ZWTgTYsK7eECl9N2dItldDF4aBRLJuvO3qNYbaCL
3r8beUMzqCD/fOpxX7evFgTg1rbWdB5UAo9lVFfvxXRIQVvKZ+wxqRiLhk5A3jpJ
g9qt6aSJJqacS17BF0te7Ub3Zt61ol2TRgiJL40cnizozBdVAl8rMamPRBjuvgIk
ZjFn0+jGNsBEk4n1zozHvcZsGfhGqeVQN3WAsXj/ljqnQV9BtZki8KJP0OvFHSrx
AdvzhT6VFgbAKw1tcAK77co5UnVO9kfbQ32stz7vhl2ft9SaNJDT78Twl3fl4vwv
NaWJy9RSZhzzZ+J51247/gB3blX91nmNzmAvaBaU2Sp7dQBHEKoZ8Jepz7hJ0GLM
20wJu97nythTlqXDgYwp+fa5Ue8SVwczckSNb25R4V9YX/4ERrZJdu6oO2JD0Fhz
xvmKpV5vBRiebq31NmREP1UbWEROmJfVGx875bwoVtkGek4ngBoPKEN6aaQTZmte
Hdme1BMwWmOIXqntk4T8
=wguB
-----END PGP SIGNATURE-----

--DeaqLsaJcuYlI8Od--
