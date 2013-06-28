Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab3F1LNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 07:13:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49613 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab3F1LNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 07:13:07 -0400
Date: Fri, 28 Jun 2013 12:12:41 +0100
From: Mark Brown <broonie@kernel.org>
To: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <20130628111241.GC27646@sirena.org.uk>
References: <201306201454.r5KEsAAS010978@swsrvapps-01.diasemi.com>
 <Pine.LNX.4.64.1306211035210.27277@axis700.grange>
 <6ED8E3B22081A4459DAC7699F3695FB71D6CABE7@SW-EX-MBX02.diasemi.com>
 <Pine.LNX.4.64.1306260952160.8856@axis700.grange>
 <6ED8E3B22081A4459DAC7699F3695FB71D6CF2E6@SW-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XrVBOfxXXtKOgaXT"
Content-Disposition: inline
In-Reply-To: <6ED8E3B22081A4459DAC7699F3695FB71D6CF2E6@SW-EX-MBX02.diasemi.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC V1] COMMIT 1: DA9210 driver files
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XrVBOfxXXtKOgaXT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 28, 2013 at 10:32:08AM +0000, Opensource [Steve Twiss] wrote:

Please fix your mail client to word wrap between paragraphs for
legibility.

> Dialog are planning to submit a DA9063 driver that 'stands alone'
> instead of being fully integrated with a combined DA9210 driver (i.e.
> the one that was uploaded to the mailing list about a year ago).
> Having said that, there will be a strong similarity between the
> combined DA9063/DA9210 mailing-list driver and the upcoming
> stand-alone DA9063 driver.

If there's a lot of similarity then one of the obvious review comments
is going to be that the two drivers should be merged to promote code
reuse.

--XrVBOfxXXtKOgaXT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRzW+mAAoJELSic+t+oim9UNkQAIqKgdG63mZq7rcQYd0Uk1Y9
uGXrliGISMml8faA47ge9dENBfDUX7MKgt98eQVBWYWcnd8dziwByLvQ8Slw3JRn
Q2c5guPriC2vK+sKwtK2KXwpMppQ1WkyJnHYdRuwI3t0AjJds99mqv7VkaneJvUO
EaYB12+JSUS1M+0Mte+Z242A839bJXYoUsBvH1/xjb1Zo5LrQ8tVKvgmWD1NKYfT
xtwCumCH7xK2Piy91xANx9PigtHzrezuX+LzZOss5YuHapOcJXYtraF+P07Uj7r2
zXnpnaKe0MEiVREh6NTvU97aC7jK7kOQwYw7xQSEhARL+haaeQVbOOYb8eUbgerr
1LrLQBUN4cpwo7AObeOrS6FMTEzTV5b86aY9wIkQbJuktms2rZE0Ne0B/lV2UOwz
61fPmBWkTtyR7fHteB1igYQILWvyelBUYDFRK+LSYfEr1DGNBW1p7+z10waYGtdK
1W4yWfbzNAea/8d9WYsQxM3/WKUFLHl/F3UuIcW3uDc0FJbqHeE7hj3ZkblZfXzW
t/IfoP2w1D2RW1Qj9mKPZzQ7NEkjSAYhBQrWhv+YetXnPokpWz9YM0xRl8Uwk6Kg
SBQ9GLZochLad4VhtjrmqHhHGRxX/iMlx86LMJlTwkfiU+NhAiCxGL9JG6CImzYp
IcbVub9xhIS2OTh/GmAT
=WyUM
-----END PGP SIGNATURE-----

--XrVBOfxXXtKOgaXT--
