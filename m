Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544Ab3J2QY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:24:59 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38150 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab3J2QY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:24:57 -0400
Date: Tue, 29 Oct 2013 09:24:08 -0700
From: Mark Brown <broonie@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Tejun Heo <tj@kernel.org>, darkstar6262@gmail.com,
        Grant Likely <grant.likely@secretlab.ca>,
        Wolfram Sang <w.sang@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ext Tony Lindgren <tony@atomide.com>
Message-ID: <20131029162408.GG16686@sirena.org.uk>
References: <20131024124631.GA14517@mtj.dyndns.org>
 <CACRpkdY2d88RxxgZ5=rPuQHrb3a7Q+trvBWsEMSaByhtWKf31Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oOB74oR0WcNeq9Zb"
Content-Disposition: inline
In-Reply-To: <CACRpkdY2d88RxxgZ5=rPuQHrb3a7Q+trvBWsEMSaByhtWKf31Q@mail.gmail.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 66.78.236.243
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: READ/WRITE definitions in drivers/spi/spi-omap-100k.c
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oOB74oR0WcNeq9Zb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 29, 2013 at 02:34:26PM +0100, Linus Walleij wrote:

> That seems like a good idea, but we better poke the people who wrote
> the code and the SPI maintainer :-)

...or send a patch?

--oOB74oR0WcNeq9Zb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSb+ElAAoJELSic+t+oim9cx4P/1E9oVFOMjOkpgF7bfBRTTz9
seGAe0wQqkV99CuyIbDJkUNCL2x8TmZMgWWGdjpPYUNr/+45Z/tjQhQcgnuo/cR4
hp+l/xL+X81pnbjY73g2RDrRemMpCN3ASN9/rHjYU5d0iUfwPqENobnHzyczJZrh
vGF52L6F93yu3LrLi3GnzIZQvmdFVpPsz/SY8JYOGcPkqhz/m6mkju5Ksq24j4ba
FpzSeC41dXV63YpEzJjRkMYXb7P2upvJHmKXiwONeehLpta7Cwa0hHb69ekFqvT6
WZ4qkg7trO54C6MGVokFCOovHtPcXHpN5lisnngbH8kqYdhaeBDlgXtveTCA6hvh
J2XT8cffr9ULljYJdPXzdMkppJZt4vOGk7NmcCCJC9XdVUcmlxedPTylNkXMNNPd
As//dr4aPOMxhfRER3fGk3A29Xo7nIC8qbB3ou/K5DwmLJYO8rEbEJMky/iwkeQy
LiBAXkE+UUYpR7OW7V193xJhszRlbh5ydBv4yHm8Pik2I/rPh6IGsoOUL2+j0xfM
gbn0HroXOQW7e6TL0Oa8PHyFYD45ih1ko4lemmlkCYZ3PT5O6llIMqmY55HvYkWa
S1sFrxEVAIJA2GPHVrgUd8drJHnT2VyvmE45WgKFjJmniuXVncZrXjk/GbKuupBj
qBc1u+tWBmc1Ntq0KEWI
=eh+L
-----END PGP SIGNATURE-----

--oOB74oR0WcNeq9Zb--
