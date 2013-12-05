Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab3LEPIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 10:08:45 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58794 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab3LEPIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 10:08:42 -0500
Date: Thu, 5 Dec 2013 15:07:47 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Kevin Bracey <kevin@bracey.fi>, Kyungmin Park <kmpark@infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <20131205150747.GW29268@sirena.org.uk>
References: <1384881351-10782-1-git-send-email-t.figa@samsung.com>
 <528BB1F2.4080107@wwwdotorg.org>
 <CAD=FV=XS0dbE7zfgDGVdp84h4fHH6tfO8aN_HNh1LbOjYy51aQ@mail.gmail.com>
 <528BB913.6080409@wwwdotorg.org>
 <CAH9JG2UjnL5bZzNUuJhWY3GpwPD=rJvR2O4Hcpm33G+prSS=BA@mail.gmail.com>
 <CACRpkdbyjm0X9RX+8WjqQxBPyRjBOAunkqVcO-0KUd1PTdGavA@mail.gmail.com>
 <5293ACA6.7060403@bracey.fi>
 <CACRpkdYrPd9tnO48bA_5n+-k=KEDyhY7czkCNhTZfpgF3ar+LQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GZxc/eAcyN/xQwfo"
Content-Disposition: inline
In-Reply-To: <CACRpkdYrPd9tnO48bA_5n+-k=KEDyhY7czkCNhTZfpgF3ar+LQ@mail.gmail.com>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] pinctrl: samsung: Allow pin value to be initialized
 using pinfunc.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GZxc/eAcyN/xQwfo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 03, 2013 at 10:29:42AM +0100, Linus Walleij wrote:

> So a suggested patch to support weak hogs would be interesting
> to look at. Can you provide details on how you think this would
> work?

Or should we be going and applying the default state to all devices on
init without worrying about a driver appearing?

--GZxc/eAcyN/xQwfo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSoJa/AAoJELSic+t+oim9MxQQAIiQ7biYagSPUH3xNFuPOCv2
XPDndz24i9I/xtewThg5QI0meKW01hkqiDpbTo4CqkJoQIVklQ//b8oWGXoii1na
/+NMt9i1XoxJqCbADKg6rJO+TBeIn+5GuETytXKHwXpcdOr9fP+4M7/MbVvsIbh0
tW21WCewN1Fmf4PYAvvIpYgn98uEYEAmc1Zr9fGt11VOzB/FziRROAP8SzCvbuSV
9yrnoy/EZugLS7ax2ECX+R5ooi2oOuMNkC+Pb9gCK4n6UI+uKSkEGxfPd4Dz0YMR
1nQd9MEeI7+67sMfM1poAoUsaGRMZDrTyn0oEkaEAlEFFtFCCBLX5XIIwe3vmyjw
VXpnH+APCDW9pGcPamcFu5NoZ7d227q1ltNNJ7+sOXNFVJtPDH6VUZEhzZNvOlBE
xmnmXL0HudLr4clyMNIPXK22XJW46bs9j1uFvdGSi6ToQTZsypj1wX+dw/mNd/Pp
m37iYVliRRpLLU+lWegFQrAq+zoL8UbdMdTXMhSwV38UoEjcc2sYirEFW+Yrxbwn
7sZCmEY1SJpQUmP831NECLuYsypJc+XpgJK1S3U0fHnJngVx6v+adzjahxyJWsOP
e6Q4i2w8tqya9Yrb9L5UJSGKF0VNJ6LzvsxhXgl0r5hzEEF6uXH7WLjtNUH/aHdY
H6GSi3Qrg3z29MXenAc4
=x9xJ
-----END PGP SIGNATURE-----

--GZxc/eAcyN/xQwfo--
