Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaAMLKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 06:10:12 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53419 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaAMLKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 06:10:08 -0500
Date: Mon, 13 Jan 2014 11:09:35 +0000
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-pm@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Pavel Machek <pavel@ucw.cz>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20140113110935.GB29039@sirena.org.uk>
References: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com>
 <1389469372-17199-7-git-send-email-tomasz.figa@gmail.com>
 <20140112192910.GW29039@sirena.org.uk>
 <52D2EE32.5060709@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ERHfpFOxJvIsVBXy"
Content-Disposition: inline
In-Reply-To: <52D2EE32.5060709@gmail.com>
X-Cookie: May I ask a question?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFC 06/10] ARM: s3c64xx: pm: Add device tree based power
 domain instantiation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ERHfpFOxJvIsVBXy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 12, 2014 at 08:34:10PM +0100, Tomasz Figa wrote:
> On 12.01.2014 20:29, Mark Brown wrote:
> >On Sat, Jan 11, 2014 at 08:42:48PM +0100, Tomasz Figa wrote:

> >>This patch adds support for registering power domains of S3C64xx SoCs
> >>and binding devices to them using device tree.

> >>+#ifdef CONFIG_OF
> >>+static struct of_device_id s3c64xx_pd_matches[] = {
> >>+	{ .compatible = "samsung,s3c6400-clock", },
> >>+	{ .compatible = "samsung,s3c6410-clock", },
> >>+	{ },
> >>  };

> >Looks like a rebasing issue?  Otherwise this looks nice.

> Hmm, what's the problem here? Maybe I'm just blind, but I fail to
> see anything wrong (except that the array should be const...).

> Thanks for reviewing this.

I wasn't expecting to see references to clocks come up in power domain
code.

--ERHfpFOxJvIsVBXy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS08lsAAoJELSic+t+oim9z3gP/3zuT0HAcaALVWqSI4PzqxhM
YJAkiKO42G6jdgTNpVdzpNH5tymXRnUCWAcHi8srz8UNtnfuJjiCRDiLcoXlrVAv
cBEPFW5ThOx8dvsMjS11n1j+R/rUKdiZ1pzIw7YOyYq67zj+k92JCT2vNATUhXuD
6OO4BCAC0Ke38rlaXxh6w4G7mnD9NbMLiAVgIgohLMKnB4JIN4C9I+H3drgx6tgj
uL8gL5XqDw9ACjOpcbDpzEP/6iNFJvyqTT1XYefRkMmEw7BJwiHHXJU0OhA1JBxj
n2xhhfScZGHuhlwsGHnsXMywsS84m6UbCavEhyXd7XCS3RUjUJkwYJcvlNhavz9H
CoqKfq9LuoGaYle/UCUZFkF8eCiaMghalZDg9WUP4ZKQtxbmkqs+/cbyh0nOyoPB
1Wb93KKxrLj6cUmyeB+AeRzXs4MY+0b28AWThxSO827AIZrx6kT4DqUt4ARCKIMw
sLGHMLTo/aAxIDPYY+slB1vu+PDNZmIH+hxwRKElvzH6VvNoOAKBMfZVsetUI1Vf
u/QhTYD6dAolXkM3+oJX2mo3RCWeEZJ3qnS8SbAW0kn44IMN5qjJlDYbwcvZEQEF
LgPjissE+hU9xjmh5NGJbkx8x5wHD4t5Wtc5+ATu24elCjzmSo2jPgS4nOy0av3B
ErihFbYiIxBblajNYIp8
=ltBf
-----END PGP SIGNATURE-----

--ERHfpFOxJvIsVBXy--
