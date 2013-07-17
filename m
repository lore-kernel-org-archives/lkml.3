Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab3GQK04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 06:26:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49057 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab3GQK0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 06:26:55 -0400
Date: Wed, 17 Jul 2013 11:26:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mike Rapoport <mike@compulab.co.il>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130717102631.GO22506@sirena.org.uk>
References: <1373941094.13228.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CMebLzmeJATad/OR"
Content-Disposition: inline
In-Reply-To: <1373941094.13228.4.camel@phoenix>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFT] regulator: da903x: Convert da9034 ldo12 to use
 linear ranges
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CMebLzmeJATad/OR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 16, 2013 at 10:18:14AM +0800, Axel Lin wrote:
> The voltage table of da9034 LDO12 is:
> 1700000, 1750000, 1800000, 1850000, 1900000, 1950000, 2000000, 2050000
> 2700000, 2750000, 2800000, 2850000, 2900000, 2950000, 3000000, 3050000

Applied, thanks.

--CMebLzmeJATad/OR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR5nFTAAoJELSic+t+oim93rkP/A2GtxAHnRj64qMOTISv4AQT
HZS/+6AUio9QZTPl+lnxeQrwyOAgWXl7XYFt/d1hhqTHQ/nUBhL+MdvQa96VDO2N
jQ7Y11j3sONeAGj1OQ9Jl6bbJOnFKnnZfyT/4ashdGslUXhQ2XT1sZqqDkACBO9A
290LWRUsQOh6Vs35BGNzdYt9YWXJBAjpEARDR6eRx012k30awplYd3Gxm5Jcjtel
mUAl2eJnaYhcCBGorT+gIkheRcsMXn5lIS+SJHNu54/Juw2tpwYKpVWJjSKCdvCS
WAFtNF+MA7QeYCKQGVQq5TK6/q0HGkRxXLFkUo0iwGwU1X1HlizYc3jQmXWsioGb
ITfPMBjOzkkx9dfxIaDFkhebkjVKOdxGiIba/o+BFS5U+YJZvUPWW0ojD/4NCnS3
H9wxHARfDtxTzMVYI1ubuJbU550g/9yr5bmfpQNwMqUZQfLbJngH/ya72cix/BKQ
T/CyXbokd/0Tnj4KWYLNdiGna78V/sINhnPAChlTA9jIuo/VlQ8xwQZxHAivkD5/
Lnq+EemjxAhHzAVpDuhCdRcZI69WvIOKURxQPyinIfbDMsVU/9BsSsgJYxw02uUC
Q9inY6uSFxMZDgo3UqWONd7Xn504BdY7qmbQpUV4pjilPuqf4YptqLjMxPQPgKMf
cy5T9/U7m5qgtlgjXdEo
=YWUh
-----END PGP SIGNATURE-----

--CMebLzmeJATad/OR--
