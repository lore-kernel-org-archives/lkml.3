Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab3JDPJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 11:09:17 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33335 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316Ab3JDPJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 11:09:15 -0400
Date: Fri, 4 Oct 2013 16:09:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Message-ID: <20131004150910.GP27287@sirena.org.uk>
References: <1380562166.32071.172.camel@dvhart-mobl4.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qUGjz7OmxI7iFH2Z"
Content-Disposition: inline
In-Reply-To: <1380562166.32071.172.camel@dvhart-mobl4.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: GPIO: Performance sensitive applications, gpiochip-level locking
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qUGjz7OmxI7iFH2Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 30, 2013 at 10:29:26AM -0700, Darren Hart wrote:

> Is there a best practice for dealing with this kind of configuration?

> If not, would it make sense to add optional gpiochip-level lock/unlock
> and lockless direction and value operations to the gpiochip function
> block?

Another thing people keep suggesting for this is a block GPIO set
operation - something that will let you configure multiple GPIOs with a
single call.  That maps nicely onto hardware which has a single register
for multiple GPIOs but there's been abstraction problems implementing
it.

--qUGjz7OmxI7iFH2Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSTtoSAAoJELSic+t+oim9VvcP/3TDjE/E7+D8fCYcLstvvAI+
CFmyXGOH5mGRbhMeahi4k1rA/3qe1Cegalqr/BcqORXdSBtYtLNndfWWUV5liF49
JuAZld2ZH0DncsA3YOPj6AgQYRIsxSzJi1/3UL7IDJDMm2bVW0EauBhOHjQwOh2d
AaqEY8RZMoxdAUOsV+M0Ie0skHxu2eXuSd94ws0d7qkGb1N2NglGTUrKnrYKlR+M
11+7yPpQZjbTEculq1LA4oPnk45x8NCrMzE0nMYB1g4I+Mj8vNFUHcur+P/9x2eP
lItBnoSUrOfwn1EJSY6++7HtjxQhqRno4HzGlyvGs3syvGCrDQQ4nexxwjY9EMZy
Yj2aw8DZlZPwEm6CBqGPMb9PNXHD0/9kGkSEByNLQLHQLrJ2vZ7/smOUPzh7bMnN
21OhUmtTS0lYaRvtYEJZjprSl7BQv9hZCKciSEgBFq5cpIkYWp3wECuCrcGp0h7x
Y053f+SI1Kfx2KzE73TZ1lNvNsgEgjWsiQ1N3HeyyXKtCGsDk/Y9TLyyNFPxxuUE
3dMbSTAeWONJvE+SpAg8F78AUNAOvCf5E/wwEI6BkAkLWxAhBTSxT6g3QuypBg9H
YhZKiwPE/Aa53T01lJXaiFaHDe5Jxl8CEYlVBCtPYCAJQlX8WBl0rAJTlRoTqtiG
+NM2oT5ZYABpRDpH9gVD
=tAG0
-----END PGP SIGNATURE-----

--qUGjz7OmxI7iFH2Z--
