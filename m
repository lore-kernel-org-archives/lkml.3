Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaAPLDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 06:03:50 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55523 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbaAPLDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 06:03:47 -0500
Date: Thu, 16 Jan 2014 11:03:03 +0000
From: Mark Brown <broonie@kernel.org>
To: Bo Shen <voice.shen@atmel.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        nicolas.ferre@atmel.com, linux-sound@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140116110303.GN15567@sirena.org.uk>
References: <1389669956-2304-1-git-send-email-voice.shen@atmel.com>
 <1389669956-2304-4-git-send-email-voice.shen@atmel.com>
 <20140115115417.GA9558@ns203013.ovh.net>
 <52D736E0.90207@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JjsO4Ft8DCMnlCnY"
Content-Disposition: inline
In-Reply-To: <52D736E0.90207@atmel.com>
X-Cookie: Marriage is the sole cause of divorce.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] Binding: atmel-wm8904: add option to choose clock
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JjsO4Ft8DCMnlCnY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 16, 2014 at 09:33:20AM +0800, Bo Shen wrote:
> On 01/15/2014 07:54 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:

> >>  Optional properties:
> >>    - pinctrl-names, pinctrl-0: Please refer to pinctrl-bindings.txt
> >>+  - clk_from_rk_pin: according to hardware design, clk privide on rk pin
> >							  provide

> >	?? no example?

> If this patch set is acceptable. The sama5 audio will use it (I will
> send patch after this patch set). Do I still need to put the example
> in the binding document?

It doesn't seem terribly worthwhile to have the example include every
boolean property, it's not like people should find it hard to work out
how to use them.

--JjsO4Ft8DCMnlCnY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS17xkAAoJELSic+t+oim9NXsP/2iHK/usFtT3j305+tbZ8Fq6
XLveQXN/1X0buz1qcxK+2Ty6DMQZKA2DhH+uL9i4HmdOXmIBclFNpuQt1j2Gf4FX
CN6x9WT+IG6XkFYtOMRnYaiMOq0Y9zGp/kMh0jGfO9e1KpZk6h8tIrP6uAxTeRJU
ZNVPtCuoCQs2XMVV0heG8qWX8u+CzOgPz4wOapHHQJjDV9vMB3FLckn8Z5RnSklL
0t0e01O/utDwvBndZlpc6TGR/viS6HzgpMufqaZQMPmqBMSR0Z/V1AKaZKjmHBjK
OQ88+uJWCUII1bCxIEOXhB62Qap81pKKuUmKLyRs/8NMKiqqfkdRllmPotj8S5b3
zT9PGfygBfgAThUbw3kcePEcTXawtH5Jg6Q6gNUIyNnSItIRnied9P+7vdz7mgjm
3GkG1omF4IhYdPxfUAqQZtGeiud+RTmo7bPyglJMGE91jm9Y5W4TGHNLDtMGxaX+
pnJr2BMClYY5jgSZYAuDaipP0BslIVtDYXqYIN6tn76sOEczY7fSEOITj5E2433D
qGXk9bwwMkkD42BxJ8CgmwqjmczAd/FsAGe1SfYDcGBdUxaPldkF3laxbgPphh6O
FdxN9f24o1DPo+TlSbGKI5MLTb49V4j+7aV3cr0peFeKnn1e8LgeeOSIhk/dV6FN
QCx6WBMHuc3IxUEPrSKU
=ueZP
-----END PGP SIGNATURE-----

--JjsO4Ft8DCMnlCnY--
