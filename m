Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaBNS0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:26:50 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46224 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbaBNS0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:26:18 -0500
Date: Fri, 14 Feb 2014 15:05:20 +0000
From: Mark Brown <broonie@kernel.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Gerhard Sittig <gsi@denx.de>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140214150520.GD4451@sirena.org.uk>
References: <1392302806-17267-1-git-send-email-iivanov@mm-sol.com>
 <20140213212757.GM4524@book.gsilab.sittig.org>
 <20140214002627.GG28112@sirena.org.uk>
 <1392365765.12787.89.camel@iivanov-dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="76DTJ5CE0DCVQemd"
Content-Disposition: inline
In-Reply-To: <1392365765.12787.89.camel@iivanov-dev>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 149.254.51.37
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: core: Validate lenght of the transfers in message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--76DTJ5CE0DCVQemd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2014 at 10:16:05AM +0200, Ivan T. Ivanov wrote:

> "SPI transfer length should be multiple of SPI word size, where SPI
> word size should be power-of-two multiple"

Yes, that's clearer though you could in theory have a three byte word
(I'm not sure that anyone would actually do that but it's possible).  I
do have a comment on the code as well.

--76DTJ5CE0DCVQemd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/jCtAAoJELSic+t+oim9mo8P/2JMICQN2GFb3yMoCoNCuzt6
ieRjfgN9F2kkQSqumpGRXtZhwFuDL4eWO8K4tGRCT31jumCKJT+nkHwc6fesTwoY
HHASYD47TQPcMuulY+fwLZKt6TjGQdX2X/HUWcvAKa5kcgseyi4+vNdj/SKx20wX
kq27k2w1oKoSNBxxYWY2psnxVch/1mJ9Hw99O0ukpEqwxES/bODSVb/Rpzn2wtBu
9eZzga5KTEr1+a94qXHUE+nvzG1I7Nc9gjmKQD8N+hAbM/wF84U/wH39wl6IF/eB
qowoLSBOtKhmmliaizSjoFN4eNxNM2tD2mZMUJn6JhBQsVdD7AvsoiTsImP/UoT7
Y5IXjK68uV5owpdt/GMCA8PPKIj2nMP6XUamoqbUCl1K2GiwJERcXApTnV/Kyd9f
rYOmwvRi+2lsU5PLms04UB7kvGBvSbLctT38NdwpNRJJdk1Ci1Z9euqycZC9HTs8
Hsd3Y9SO6viBPeE6p9ar0Bs+AekqmTu55QpV0e5KcCZXiD9SzNFPo9tR9K4AUjfS
AR94kJc+7dP9+SmkMIWEqzsDo9s5igg8EAqQbP2H28gQp7JmbkEKEItUgi446Ur1
3vDIpP2OYir0WFMw8rRmCnQhhs9lq3XB0Y3foeYxoE6tiCo8PiJkKpAHlQh0YP4U
yyFE8hlZiKZJ8CEfAgVK
=0TMQ
-----END PGP SIGNATURE-----

--76DTJ5CE0DCVQemd--
