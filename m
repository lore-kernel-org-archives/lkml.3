Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab3JJWWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 18:22:44 -0400
Received: from ring0.de ([91.143.88.219]:38955 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755764Ab3JJWWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 18:22:41 -0400
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: elinux.org]
Date: Fri, 11 Oct 2013 00:22:10 +0200
From: Sebastian Reichel <sre@ring0.de>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        "=?iso-8859-1?Q?'Beno=EEt?= Cousson'" <bcousson@baylibre.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org,
        "'Pali =?iso-8859-1?Q?Roh=E1r'?=" <pali.rohar@gmail.com>,
        =?utf-8?B?J9CY0LLQsNC50LvQviDQlNC40LzQuNGC0YDQvtCyJw==?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [RFCv3 0/7] OMAP SSI driver
Message-ID: <20131010222210.GA7938@earth.universe>
Mail-Followup-To: Aaro Koskinen <aaro.koskinen@iki.fi>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Linus Walleij <linus.walleij@linaro.org>,
	Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
	Carlos Chinea <cch.devel@gmail.com>, Paul Walmsley <paul@pwsan.com>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Russell King <linux@arm.linux.org.uk>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>,
	=?iso-8859-1?Q?'Beno=EEt?= Cousson' <bcousson@baylibre.com>,
	devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-omap@vger.kernel.org,
	'Pali =?iso-8859-1?Q?Roh=E1r'?= <pali.rohar@gmail.com>,
	=?utf-8?B?J9CY0LLQsNC50LvQviDQlNC40LzQuNGC0YDQvtCyJw==?= <freemangordon@abv.bg>,
	Joni Lapilainen <joni.lapilainen@gmail.com>,
	Tony Lindgren <tony@atomide.com>
References: <1381091235-18293-1-git-send-email-sre@debian.org>
 <20131008172815.GA8313@atomide.com>
 <20131010172128.GF28657@earth.universe>
 <20131010182801.GB29989@blackmetal.musicnaut.iki.fi>
 <20131010200236.GA6603@earth.universe>
 <20131010201914.GC29989@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <20131010201914.GC29989@blackmetal.musicnaut.iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 10, 2013 at 11:19:14PM +0300, Aaro Koskinen wrote:
> On Thu, Oct 10, 2013 at 10:02:36PM +0200, Sebastian Reichel wrote:
> > P.S.: You can get a mainline kernel status matrix for the Nokia
> >       N900 on this page: http://elinux.org/N900
>=20
> Thanks for summary,

You're welcome.

> and the above page looks very useful. I wonder would it make sense
> to add also N9/N950 there (some functionality is shared)?

mh maybe. I haven't looked @ N9/N950 so far, since I don't own them.
I would be interested in a N950, but I don't own one and it's almost
impossible to get one :(

Apart from that I'm not sure if it's a good idea to make the table
even more complex. Maybe just add a new page?

> Also TWL4030 DT status could be updated, e.g. watchdog support
> was done already last year with 8899b8d93ec64b7a8e54807a68a958e1206535e2.

Yes. I only recently added the DT column and have not yet checked
all the drivers. Probably it's also a good idea to split this
column into "driver supports DT" and "DT file supports it".

-- Sebastian

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBCAAGBQJSVyiRAAoJENju1/PIO/qaNL4QAIdGVPbzbRA2WqFoRtzh1tPi
U0a23hlw9ehmQm8WUABapv43JGD9QRIlJcI+PK0RteedCjuHofZwftMUi1UKYzZD
X0U3Gwz8nbBS1RuU8IRjiHQLVpzucNYfBt9qvyK863dhfxL2AA4PhdvhAXGqoNJj
bQap7CPocvjJV1sqpiZOte3oEQUkrjx8UkWaxDmHWomuFyLjFIzDVXqAj3rxVp+9
ghd3KvVeoquo2zrN/yWi3fAd13gc1iwibviBWgj4JopStcvtQLO9/BLG/BLNJRig
w7kRH/SOJ34hGedxRycB+KdT00ZmBNYld9QZ05XGUwSxD8FvWigB31bTR4fJzJ9k
8k28yYvBowh6Onh4+7dV8G+5uPjGcY+53ho+0wOc+VAFpS/LKl6CpOHYazxYN4jO
oAU5HEgjJLbjrR/3+wXPbKyZhifWn5OpfceYXEI7hrt9CGB1t9IuAfFM5pRnVW8x
qCLYRejlYjCsWFob6YwKw+H49kwHuRkQpB5re+ae3xwtr6jBMOSso8nNw4xQ4OtP
U1Fc3c8bZtaq3pFN/p8z/TvgeHuUhGW55cMhndjS355WTMkzI/aNsZEzFxHa70EY
Ftc9prFx2X9CjV//WHckIH8D+ffdJk6UYC7tyP0x/05uer6fye/xcwbvqJQw3iBM
bSuilKIzvWr0+S/ycFBH
=N0Yl
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
