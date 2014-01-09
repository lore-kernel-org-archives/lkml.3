Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaAIRm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 12:42:29 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50299 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaAIRmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 12:42:19 -0500
Date: Thu, 9 Jan 2014 17:42:03 +0000
From: Mark Brown <broonie@kernel.org>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: nicolas.ferre@atmel.com, richard.genoud@gmail.com,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20140109174203.GJ12858@sirena.org.uk>
References: <1389244755-16188-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5me2qT3T17SWzdxI"
Content-Disposition: inline
In-Reply-To: <1389244755-16188-1-git-send-email-wenyou.yang@atmel.com>
X-Cookie: Gravity brings me down.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] spi: atmel: Refactor spi-atmel to use SPI framework
 queue
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5me2qT3T17SWzdxI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 09, 2014 at 01:19:15PM +0800, Wenyou Yang wrote:
> Replace the deprecated master->transfer with transfer_one_message()
> and allow the SPI subsystem handle all the queuing of messages.

Applied, thanks.

--5me2qT3T17SWzdxI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzt9oAAoJELSic+t+oim90DQP/RH6oIIOxqSRxPBljD+ZHyFN
xMhJm5zf8HloQnMOPpV1g9ezBxYwXgjfiAzVVJ2Po/hc0wMf1HWXDru8Qzl1mc8T
UYCOWa5WKliYSw0eoypiYB5/cYaAq8TXh3wbeQZmFBY9MQxvHLH/Xs2UL0CG+Cba
IjdtAwktdpbFh0t+2YkHM8lMbQv16iqo2ZdZ2GA+hWGSbN2YL5AR/QoNJ0v+Ni54
fuxktzjIHXLy5v6gpgAzEqs7h9ZQLE741idzmFefHneWrJ/19/WBczRur32KumEC
BwPFVA8eVPzvXSEzTvy8H0n1qHJW4GEb/bFjoBupMPk2nTTvLdf43OXXI/9vC4Fs
dLcEawghUfsGkiZfYshaqHV6jUs5AseaBn3azv0AVIhC1FHVikIT9Y3+wwWgqlnC
dINPLmgnNi7UliJtaURkJO+I4GxPU4btx26T5zLGwsEc4Q2alyUYf3gmfPuSYPMR
azoMhqs/w8hFUWBWYL1zuWeWkE9fifH634pqbgFJK2I5JfCpW52r6CTEo4EKzDHD
7Ssjf4qkUrg0jfyXhqClScbIW5spjg2OAhBlwS+pyWvau5dDEK/7qpFtw9ls8ADB
TreFYOJsqQNMm29r46hlbarGSzvs/P9Ybp2r3rMPR/XJGch/jYdqU1G+EOocC69I
iByVhLPnzonpGJgTBJLF
=5I5s
-----END PGP SIGNATURE-----

--5me2qT3T17SWzdxI--
