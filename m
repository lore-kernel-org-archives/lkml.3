Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034Ab3CYTr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 15:47:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45088 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932858Ab3CYTrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 15:47:55 -0400
Date: Mon, 25 Mar 2013 19:47:21 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Ian Lartey <ian@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-leds@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net, mturquette@linaro.org,
        linus.walleij@linaro.org, cooloney@gmail.com, sfr@canb.auug.org.au,
        rpurdie@rpsys.net, akpm@linux-foundation.org, sameo@linux.intel.com,
        wim@iguana.be, lgirdwood@gmail.com, gg@slimlogic.co.uk,
        j-keerthy@ti.com, ldewangan@nvidia.com, t-kristo@ti.com
Subject: Re: [PATCH v10 01/12] mfd: DT bindings for the palmas family MFD
Message-ID: <20130325194711.GT18316@opensource.wolfsonmicro.com>
References: <1363964122-19201-1-git-send-email-ian@slimlogic.co.uk>
 <1363964122-19201-2-git-send-email-ian@slimlogic.co.uk>
 <5150906F.9040202@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y80AKZIs+e/pKYlV"
Content-Disposition: inline
In-Reply-To: <5150906F.9040202@wwwdotorg.org>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y80AKZIs+e/pKYlV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 25, 2013 at 11:59:11AM -0600, Stephen Warren wrote:
> On 03/22/2013 08:55 AM, Ian Lartey wrote:
> > From: Graeme Gregory <gg@slimlogic.co.uk>

> > +Optional nodes:
> > +- regulators : should contain the constrains and init information for the
> > +	       regulators. It should contain a subnode per regulator from the
> > +	       list.
> > +	       For ti,palmas-pmic - smps12, smps123, smps3 depending on OTP,
> > +	       smps45, smps457, smps7 depending on varient, smps6, smps[8-10],
> > +	       ldo[1-9], ldoln, ldousb
> > +	       For ti,palmas-charger-pmic - smps12, smps123, smps3 depending on OTP,
> > +	       smps[6-9], boost, ldo[1-14], ldoln, ldousb

> The list of legal compatible values for this node above doesn't include
> both ti,palmas-pmic and ti,palmas-charger-pmic. Should it? This node
> should describe this PMIC block in a completely standalone fashion,
> without the need to go look at the top-level node to see if it's a
> "charger" variant or not.

The latter was removed from the code in this series, only palmas-pmic is
present now.

Just as a general thing there seems to be an awful lot of stuff here
about the boilerplate for the generic properties like the interrupt
and GPIO controller stuff - we probably need to spin round and look at
factoring this out to make life easier.  There seems to be a lot of
boiler plate in the bindings that is factored out well by the frameworks
in the code so people don't even need to think about it.

--y80AKZIs+e/pKYlV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRUKm3AAoJELSic+t+oim9fowQAJK8XJJZnIkcTIK2LzQfAHFo
H+dqFvQDFXcfH+JaE/pnAQAYQaTexgj/VaS7ujlkjyxgz8HcnCUqA0daW+uInZB4
rUiLmt/SpprD0uc9cv6zV7uzff9aZ/MYFUz51IF+MBM5RPu4XYl/jLXWGG7rHDAq
KD/m1IThbMSJwl0uZ319Qujm3nYorRJzcaJwEcIncfr74h08hr0bqqMCqL/wfZqf
g63A7Nb9iBVVwcc31OVQk0PmSnMOam6arf1OTbQmSGwUoxH7v6YIELCy3IanUTka
iVJMrQU22Wwi1gdG4RcMCGmagUoNHD3F+QUD08EqepkVoznfkZHQtKW7Ul1FP0aA
dvTEUUXk/dDEgIsqX70nbC4Bw94a0ZCV5h6L61kPdgmCvUMfWI8iqsEh1E52yE42
GkMQt02dcC1uAa+T5J3OoYr9nTDoMm8T6ImuYrV1jl9unO1KHYJ/bM1t8Ayp+kNN
wAnGfvcFQRF7BtwAwbJu/6V80529fyh+cBztvd69FinY2urQTc0zQUr6swnC5Q15
g2dX/RMesFZLAo3+l/y6Mfjj9PDMLjPnArF4ai8nH7s3mmOWeCx9sZemM58JGBNq
E6DLjnaE7NASTfGxA1AMh5A81S/rvCYPyx2CbZpNB98EdE7pnEJRbjCjI8cQzXvn
YtwdbowWb+augz2h3QWD
=dRiZ
-----END PGP SIGNATURE-----

--y80AKZIs+e/pKYlV--
