Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbaCNQaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:30:22 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50484 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbaCNQaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:30:15 -0400
Date: Fri, 14 Mar 2014 16:30:10 +0000
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Message-ID: <20140314163010.GX366@sirena.org.uk>
References: <1394787326-14520-1-git-send-email-s.trumtrar@pengutronix.de>
 <20140314161403.GN25870@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AG41CdL1ZWVzkk/P"
Content-Disposition: inline
In-Reply-To: <20140314161403.GN25870@e106331-lin.cambridge.arm.com>
X-Cookie: Some assembly required.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: dw-mmio: add oftree support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AG41CdL1ZWVzkk/P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 14, 2014 at 04:14:03PM +0000, Mark Rutland wrote:
> On Fri, Mar 14, 2014 at 08:55:26AM +0000, Steffen Trumtrar wrote:

> > +Optional properties:
> > +- num-chipselects : The number of chipselects.

> If this is optional, when wuold I need to set this? What's the default
> assumption?

> Mark: I see some bindings have "num-chipselects", and some have
> "num-cs". Do you have a preferred form that people could align on?

Probably -cs but the whole thing needs reviewing anyway for handling of
GPIO based chipselects.

--AG41CdL1ZWVzkk/P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTIy6PAAoJELSic+t+oim93OAP/jK08OBIZnIXbqS2KH/Aoer6
OvJq0y2nGCVE7YxCdr9EQ/oWB2y2TTLD9A0KGyFrcit4+Ebyt8TXt3S+VUUOB2xP
pUc6H6KKt+ul5mWmsgh+p5R9yORV8caZg4UXtRJ6a+EsGDcLASjlXIhNj23VIYrS
G32jOtsxguSRl/FM+BpGWubMobj17AgLNC6iFWKaUP8E7ctwDZIO/BEmR8Lf2GJo
YeSIuFNUcCSXlI/fiKZSVzQLGtil+3PrgnKh1WbdxsB6tIktBHTF+KU3R+gUPlVp
ZeShi+eiMF0xhMlOIRlLJ1U8eG57VsHTHKzFtSpkfsbPBu/9DTyuf24OxsQqU6SC
OIuCFlZ59KyNWqChwau8LxVGwtTE2P41tbuQGl1UDOn2vDoDIytep0TGviX027lm
dB/07+LIiLOtQ+98EERjxWwpd4HLSowGPH7S+HkJNIT9B1Q9ODV91Lif+qgOtwG1
C6mfUEse9Y044A35tISWy77Y5h5huPQWDhzmIcpl58t5Q2oWRA3u+1s7NaaxnY8R
UPrncktgllCbc5X/qm7WX8Dxo2GwFZZ7Ts8uWoR02QmVhhQxqZbxDVUUL2qlWztx
UIP+RjVuNwdlvs3w9ODA3620peoO684jQ8mCNu4n7uh/I8pVJHymAGPk1yqCHi9j
yCO0AivHOkE0F8Ne1kMW
=SmBh
-----END PGP SIGNATURE-----

--AG41CdL1ZWVzkk/P--
