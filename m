Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab3IPT14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 15:27:56 -0400
Received: from ring0.de ([91.143.88.219]:43286 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab3IPT1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 15:27:53 -0400
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: github.com]
Date: Mon, 16 Sep 2013 21:27:22 +0200
From: Sebastian Reichel <sre@ring0.de>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Javier Martinez Canillas <martinez.javier@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [RFCv2 3/3] ARM: dts: N900: Add SSI information
Message-ID: <20130916192722.GB21903@earth.universe>
Mail-Followup-To: Aaro Koskinen <aaro.koskinen@iki.fi>,
	Javier Martinez Canillas <martinez.javier@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
	Carlos Chinea <cch.devel@gmail.com>, Paul Walmsley <paul@pwsan.com>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Tony Lindgren <tony@atomide.com>,
	Russell King <linux@arm.linux.org.uk>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>,
	=?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
	devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
References: <1379277856-24571-1-git-send-email-sre@debian.org>
 <1379277856-24571-4-git-send-email-sre@debian.org>
 <CAAwP0s0e-gYkNA78eQH7x2VJbM1byaisUeqU8YbbeWUbKwsxCQ@mail.gmail.com>
 <20130916150147.GA14047@earth.universe>
 <20130916181032.GB30568@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="1UWUbFP1cBYEclgG"
Content-Disposition: inline
In-Reply-To: <20130916181032.GB30568@blackmetal.musicnaut.iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1UWUbFP1cBYEclgG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 16, 2013 at 09:10:32PM +0300, Aaro Koskinen wrote:
> On Mon, Sep 16, 2013 at 05:01:47PM +0200, Sebastian Reichel wrote:
> > > Is the Synchronous Serial Interface (SSI)  only supported by
> > > OMAP34xx/OMAP35xx SoC and not by OMAP36xx/OMAP37xx SoC?
> > >=20
> > > I'm asking this since if SSI is supported by both we should add the
> > > device nodes in omap3.dtsi instead of omap34xx.dtsi.
> > >=20
> > > I thought that all OMAP3 SoC supported SSI and all OMAP4 SoC supported
> > > HSI but I guess I was wrong...
> >=20
> > I just do not know. Information about the SSI core is not included
> > in the public OMAP TRM. It only lists the memory space as reserved.
> >=20
> > Thus I only included it in OMAP34xx, which is used in Nokia N900 and
> > must support SSI.
>=20
> I think N9 and N950 (OMAP3630) are using pretty much the same driver.

OK. I've checked the N950 kernel from [0] and it uses the same data.
I will move the data from omap34xx.dtsi to omap3.dtsi in the next
RFC.

Thanks for the hint.

[0] https://github.com/nemomobile/kernel-adaptation-n950-n9/

-- Sebastian

--1UWUbFP1cBYEclgG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBCAAGBQJSN1uZAAoJENju1/PIO/qaYZMQAKag/PnkRZD1Z5sL72wzwlow
nLzrbXSaY09Re18fgC32YHESnhwtoxUrWKNZIk1qQf8ppzeAbdjCBifsTTWB4X4q
RrlZ1u6UfwO8cfqTtHKNrz2uA2MVWQpcLqb7j9zw/OLqDIDwhlZ/DEA7zF3fQgWA
GdJxtjkLXAvoB5meTumn1iBuqe2NQGWolrUi8YL0zrabt1mrfhXQKHDaPv54WsHO
G2UMURtQRXsjI5+kumX342TBbup4gGG8+ohZ/H8tOIbm6FWQa6jBp3PYn4UlybbX
PUxxnqEkAKB44Pf4o4i2dPNg4Ehe0KdcIKXR8DYZbg46Nl+wQa/wtgqJ9/U4413Z
6wViT4Xdtv3lxq4p/OrMUhU8uZWr2UTaZ6w5i6grWFRKhsPqVfXm1hnll3z8OBwo
cDyYG2h/KP7IROYCMShP2FNEb43AdSxW84pv1c0G35LEyE5ehBVNujMzbM2bgL2R
67swmCBvSAxaumtkY5vJ8+cMR4mt47iWMCfe5sN9hp6uCXZICk1u9kb5KRgkNgSe
QdbXfvNwNKlQOmwAhIawLxolnaji1w+7V3abPf7qZuP2GnJsCsuhdTvhUYwShQkA
LCZ99aAbmtyfM9z9a7RmSmsjUHLwdGZsT0Kq5AX7ON3KUajhX+7kEnVPy7VMmKIZ
Efuk9Z4VkqZ+nfAeHMGh
=KlmL
-----END PGP SIGNATURE-----

--1UWUbFP1cBYEclgG--
