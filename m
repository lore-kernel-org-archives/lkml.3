Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab3IPPCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 11:02:10 -0400
Received: from ring0.de ([91.143.88.219]:42237 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907Ab3IPPCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 11:02:06 -0400
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
Date: Mon, 16 Sep 2013 17:01:47 +0200
From: Sebastian Reichel <sre@debian.org>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
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
Message-ID: <20130916150147.GA14047@earth.universe>
Mail-Followup-To: Javier Martinez Canillas <martinez.javier@gmail.com>,
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
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <CAAwP0s0e-gYkNA78eQH7x2VJbM1byaisUeqU8YbbeWUbKwsxCQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

> Is the Synchronous Serial Interface (SSI)  only supported by
> OMAP34xx/OMAP35xx SoC and not by OMAP36xx/OMAP37xx SoC?
>=20
> I'm asking this since if SSI is supported by both we should add the
> device nodes in omap3.dtsi instead of omap34xx.dtsi.
>=20
> I thought that all OMAP3 SoC supported SSI and all OMAP4 SoC supported
> HSI but I guess I was wrong...

I just do not know. Information about the SSI core is not included
in the public OMAP TRM. It only lists the memory space as reserved.

Thus I only included it in OMAP34xx, which is used in Nokia N900 and
must support SSI.

-- Sebastian

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBCAAGBQJSNx1bAAoJENju1/PIO/qaOVUQAKFOU5QX6CGyWq647P1idzBq
VwzZpJUSScmjcZBMlvD2ogMREJhOyPr6gsj4ClzlYCkH1drGrBHCgSsIt4PdnYh2
JXODjsAtdSMg6hC9r4eG4KECSoXLNduRvhzLB/ejNMwJuCFwuHX3x9JCCIBReg+g
4/Vxf6x5kJJr7bZuG3Mw66/MAQh87w/l0k4LVDiQP/U2Jd7dWvyYiOCbYwngaOwY
mFUr6lR2nltamKytJkiNOP55uNKywhwXJ/pTse8NQdQQZ92ymn64RglshJ4/1R76
PsXwfz7aWoyYvdZUSHVBM0XXszLxqghPYcsdXyQnrImVPh9fxMJxoJ2EJxkrvaRG
DnYKr7C8+60aahGY676yM2dyfiK0EanZ1nWXb3kYq6ZednUaV7f+wsHsHzc3PtJd
yQx3dCus6bGieVPxYCp0UUS9AsR6MbnOXa1HRkUkEl42LZwCE8N6pcOJJq2tyRi1
JH1r2WXHEYC0y26yxLBJ1NF6DoOf66h48OU/VhOdqg//W74JSuu1D/7zMj/Pb9v+
llZZfBsPYNxErUtZ1yCAKD+5RTsns4vv1pN7a+ANJ6I+dAZss0MBRArD6QUlYug8
yY4gFmfAPSJV6lGA/ohLMNAyfINkz+4WtgIqXzeaAufo3S0nrLSZag6ReD+j+fGA
iMffh7ZQBKn/4M0pdYHD
=aYve
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
