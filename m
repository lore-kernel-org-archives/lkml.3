Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab3JHMNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:13:38 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36337 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab3JHMNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:13:34 -0400
Date: Tue, 8 Oct 2013 13:13:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Wenyou Yang <wenyou.yang@atmel.com>, linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20131008121326.GB21581@sirena.org.uk>
References: <CACQ1gAhNFTdG_2OCTnsOCaBozHnGb9EwAGHT5+f=cARRpC_WBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TqjUw3h+J5USMjbw"
Content-Disposition: inline
In-Reply-To: <CACQ1gAhNFTdG_2OCTnsOCaBozHnGb9EwAGHT5+f=cARRpC_WBg@mail.gmail.com>
X-Cookie: Penalty for private use.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [BUG] spi/spi-atmel: DMA rx buffer corruption with
 SPI_IOC_MESSAGE
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TqjUw3h+J5USMjbw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 08, 2013 at 12:44:16PM +0200, Richard Genoud wrote:

> I'm attaching the test software that I used ( ./spi_test /dev/spidevx.x )

Looks like the attachment got forgotten?

--TqjUw3h+J5USMjbw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSU/bjAAoJELSic+t+oim97uQP/REhQmaLFGOFPKZSVw0411ux
CoNxNnOq3TBHIr/fuNj/0W/YZc8LASgpGrnh9qAk8mQ83pEKZyPaNfREeDY9Gu/l
HXkRwktwQRgMVEvaQdHadTmhAE7Kii5/DVDybgbC8hVdkRSCy0wSQVQzCpwCZXAw
WYZWSepHsakvslr6zaoi9FGe0/VhTX8F2nIN9tft5qqx0ti05nwsyJtfo0iPBpJQ
CVfWffyjS2SZuQ5z/OSSlboS6Mq8hUHb864AH/Sn2+59Fj1JQik3X5gWPAN9aXW5
j4Y7V5wUJcNW2IQO1pqeysCujLLl4c5AMY7pLViB/EPWdXmvW/ymSkhfJU36rR+X
QJC4+OOd4mGmDCPriWXFTOZEpd4fhvN8mZxDcPuspVtNDUvYIurhaG/cIkZgZ92w
H5yYyMxr4pgk0StJllG+hExGbgIjj4L19gaSDPYziSZqv7f60VcxRvF292oack1e
HzlBE+UbgqE2zmMHmmfTspGGS1YT3uqcUMR1bgyN8tvjvurCF9fXX3KFy24QVbBc
i1MfB/vhRO0m8eTeSSZONzS1buUWS8+WlWH9kpFOGD3tgEl5bebt1PYM/HVxKRvu
qZi25ji+EMdqXPjPhV5YOeqaYS48ZY/LLdPRj+QIyaDbo/+3dgJcRRJsYpZe6u48
MDf21c2Qdc6KMQyCT0x+
=OfkG
-----END PGP SIGNATURE-----

--TqjUw3h+J5USMjbw--
