Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab3HLNbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:31:49 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34909 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab3HLNbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:31:44 -0400
Date: Mon, 12 Aug 2013 14:31:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Joel Fernandes <joelf@ti.com>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sricharan R <r.sricharan@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Lokesh Vutla <lokeshvutla@ti.com>,
        Chris Ball <cjb@laptop.org>, Arnd Bergmann <arnd@arndb.de>,
        Rajendra Nayak <rnayak@ti.com>, Rob Herring <rob.herring@calxeda.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Balaji TK <balajitk@ti.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gururaja Hebbar <gururaja.hebbar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Dan Williams <djbw@fb.com>, Olof Johansson <olof@lixom.net>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Matt Porter <matt@ohporter.com>
Message-ID: <20130812133111.GZ6427@sirena.org.uk>
References: <1375719297-12871-1-git-send-email-joelf@ti.com>
 <1375719297-12871-9-git-send-email-joelf@ti.com>
 <52087921.8040101@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tGkjKzRlkSQaY8nx"
Content-Disposition: inline
In-Reply-To: <52087921.8040101@ti.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 08/12] dma: edma: Add one more required slot to MAX
 slots
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tGkjKzRlkSQaY8nx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 12, 2013 at 11:26:49AM +0530, Sekhar Nori wrote:

> No need for a separate patch for this, just do this in the patch where
> you include the two linked sets.

Can you guys please think about the CC lists you're using for these
patch serieses?  I've certainly no interest in random patches to the
DaVinci DMA controllers, and I suspect the same is true for most of the
people on the CC list.

--tGkjKzRlkSQaY8nx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCOObAAoJELSic+t+oim9MDoP/1Pf5u0EF1e7uwz2dkWKEZxq
Go181n0SjqRkqv9Mb/+Q0ITVmoT/r3kOaqK82s9Va5g7WxMQVejtRQsDsubLnI7H
ywTmxaJicLA0PFbCZTM4n2Ghk1BZOMxjbS9pPqXgWzGuK3V+gKvGJoCRqhDspsVK
5c+TVRuLDsij1y4QjklGY38DdCB0XsjCqVRItLaLFet78UZvgOdlTTBYO8nkDtnb
QN8noUo2ZytYH0Zfp74tFgUvRZjo0psJkBRUb0JWX4jlUwaEFVMjYITrK1fUrtso
kIcS9K6ckW4XSwwJ+QA3BzG9lG6lx9lW6NbbpgKd7QyZPnTfcRiw3hI8ELKVksfF
6XxJRCCNyuCd7zOY40V7rS5Cjol9pMpYcT3mVp0fK1KCGKUGoxAVOa4p2ETcc5CH
9E28arMhTiqrVaXjkyUagdmi59bSueetYzpOkhnbuiLnb41RPG1EESfv/6U8Halk
S6S3KyM1sxqzyHM6++BCMazqVwKwLoXyz5KW9BFp0IlX5XwRuxqDKRMYp70fUGq4
anLH9DgtMfYmdMywZI4mYOrbawl3OPvLLDew1VTyxyOeDz/pwetJWrTrMVDYbRXs
B2h/bdN+fso0lcx/qONlSSb+9ARSEYwkJwJcrQiQmryNUYKqb7DvgBUM68rqRViO
YJmwQJfhHy2K1uU7p7Nl
=LYWm
-----END PGP SIGNATURE-----

--tGkjKzRlkSQaY8nx--
