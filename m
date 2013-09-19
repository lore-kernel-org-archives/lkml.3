Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab3ISQnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 12:43:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45755 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab3ISQnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 12:43:03 -0400
Date: Thu, 19 Sep 2013 17:42:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Message-ID: <20130919164245.GG21013@sirena.org.uk>
References: <1377836978-24082-1-git-send-email-linux@roeck-us.net>
 <1377836978-24082-6-git-send-email-linux@roeck-us.net>
 <20130912164100.GF22013@e106331-lin.cambridge.arm.com>
 <20130912165304.GA12202@roeck-us.net>
 <20130916142147.GF30650@e106331-lin.cambridge.arm.com>
 <20130916151953.GA5801@roeck-us.net>
 <20130918153828.GB17453@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QC2OnzLPmgM3Ncx9"
Content-Disposition: inline
In-Reply-To: <20130918153828.GB17453@e106331-lin.cambridge.arm.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 86.153.71.95
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH 5/6] extcon-gpio: Describe devicetree bindings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QC2OnzLPmgM3Ncx9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 18, 2013 at 04:38:28PM +0100, Mark Rutland wrote:
> On Mon, Sep 16, 2013 at 04:19:53PM +0100, Guenter Roeck wrote:

> > I think what you are saying is that describing a generic connector via
> > devicetree is not acceptable, even though it _does_ describe hardware.
> > I would have to describe a specific connector for a specific hardware
> > instead, which in turn would need its own driver. Is that correct ?

> Regardless of how the connector is described, the block of hardware it
> connects to will have to be described, and some description of the
> connector will be necessary (either in the node for the block, or by
> phandle to a node for the connector). I agree that having a combined IP
> block + connector driver for each permutation is not good.

Many of the things described only have passive components attached, or
things that otherwise don't need drivers - things like power inputs or
headphone connectors, they're mainly providing information to allow
userspace to behave differently (eg, display a charging indicator in the
UI).  It's not 100% true but by and by large if detection is being done
using a GPIO it's probably something like that.

--QC2OnzLPmgM3Ncx9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSOymCAAoJELSic+t+oim9PXQP/0a+jgxqfxO6JZ6TbalHx6r2
HAf4JyhuDDZtdmiAZ5LY7JV1ke84qxTDLZE4P9OlSiK6/UW3PGoEt9RTS2cDJCuC
SL2SUBaBeKX4XQTr4i6NPWjwl5Qv8oUq0Un8jb1eZY8DYabPbdWUcgLjnCZp6y16
6sUqrv0/OLpCcHb72dEcKpYoZqrZQxecHiFhxgnunc1rgco4FfhK7PldtbMp01FZ
bJNnhpPKL0kCFaj6YMYFKYmBQ11nTj81NJI16DOVZlFVZRJNxA6bEvh4e/NDpUyi
2smp/edpQqkGybGSvcke/GaZOCApFZV92NvvKCtungk1+IV3jLX4s/JKhTMLAfqT
4bhC7KmVuDdnQZgrjv1JJDocntvxCx3LhB9gkO68xw2C5DNd9AAhjtr/UyQvxymq
7R5td/KumhVvNTL7FowUh8zjkaaOLcxN/XJnug+/BQlFwbRkiWKRrHe/gi7untu+
2S8LrbqvXV3WYdWMDFRfp7lq3WJUkW7Qj/I35bqnmrmHiDpDbn4CqK6K130+3l5M
C1hzQ8+JSh8o0isctR7v8f3xRK8bJlaDTOaNaNP1znCqxlGaWXLv6x80F0Sh/TWl
4QPbslMbSd/JCJ9dBu43auLJgNEnBhwDauVAsA0nL+Tiy4fOdFACExOtxkxoHaD9
7xD5w1ZBVoT28N8clyqO
=lsDU
-----END PGP SIGNATURE-----

--QC2OnzLPmgM3Ncx9--
