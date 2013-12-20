Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab3LTSbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 13:31:45 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34006 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab3LTSbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 13:31:44 -0500
Date: Fri, 20 Dec 2013 18:30:50 +0000
From: Mark Brown <broonie@kernel.org>
To: Arnaud Ebalard <arno@natisbad.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>, jason@lakedaemon.net,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        linux-arm-kernel@lists.infradead.org, Rob Landley <rob@landley.net>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Peter Huewe <peter.huewe@infineon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thierry Reding <treding@nvidia.com>,
        Guenter Roeck <linux@roeck-us.net>
Message-ID: <20131220183050.GB31886@sirena.org.uk>
References: <87siton6ke.fsf@natisbad.org>
 <20131219164624.GV2609@titan.lakedaemon.net>
 <20131219175738.1dad3ade@linux.lan.towertech.it>
 <8761qk32pj.fsf@natisbad.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oMfk58fZ06Sy4zVm"
Content-Disposition: inline
In-Reply-To: <8761qk32pj.fsf@natisbad.org>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [rtc-linux] Re: Can someone Ack and queue a patch for RTC
 subsytem?
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oMfk58fZ06Sy4zVm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 19, 2013 at 11:17:44PM +0100, Arnaud Ebalard wrote:

> All NETGEAR ReadyNAS 102, 104 and 2120 have an ISL 12057 RTC chip which
> is used as main RTC clock but can also provide alarm. But the alarm
> interrupt line of the chip is *not* connected to the SoC. It is
> connected to some power component and can be used to wake up the NAS
> when it is completely off and the alarm rings.

Can the PMIC or whatever function as an interrupt controller and report
the interrupt on to the SoC?

--oMfk58fZ06Sy4zVm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJStIzXAAoJELSic+t+oim9h98P/3GpohQAvYG7zgqjRp2BOOSF
NUgM0DHhXGM8Pn9Kg82wZvbrj52UIey8xl61n3Bzp3FXFgK9i8fPJRZ0dLhfKBOF
E96/vbDIIBGmZwt27mpVbX1JBUS6x2sqDtALoG9+BqVSZz8cIstbkOFXELVqVsqS
+OuZRKyJbC6IIk2PnLHe/inS7FYjxLAY+gk+zXPtya5ZvGomAMmvk00OVzsJaxOY
jQFug/6/C+3131w2bCZhuLocIdbUz+rjo2iwmrCjWwht0qIm/YkSSIf9w523WYnv
rFwe6CRi+b5lz6xTLvslq0NbxhCPMF2XW0I6fjfNjz7i34Ck6jm9hltDHkMkXfL+
kxjTVhyPtG6Tvcw/aHe2fLaP26Fi05f0PCLMFkWAcJF8AUbNO2+VZ5/rJyo+9XG9
tpmZD4uTHJVBGNdCFXNwkYkGw5+csSgRTix3WsDhi7RUOdHIJB1vPdKs1GWVw3zA
3C8MOXxGeCrwteprDN93bYItTEaJNN9gA3N08RwTm8EN5vw7xSmG+njj72GdCgg2
2p29CKgptgszpnbOV8rf95Ut3DwPD3ktNKlYTG8sPTBYtHEb3TQp1sIvKHrhsYqw
sygzlOX22uwq9EWWZx/P9qzjBm011fztun2WA25fM677f8a328YId9medI5Xy5Ml
cBxeCQQ6qQqmGeqzgxdx
=lMVy
-----END PGP SIGNATURE-----

--oMfk58fZ06Sy4zVm--
