Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbaJNIKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 04:10:39 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52907 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522AbaJNIKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 04:10:14 -0400
Date: Tue, 14 Oct 2014 10:09:56 +0200
From: Mark Brown <broonie@kernel.org>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Message-ID: <20141014080956.GQ27755@sirena.org.uk>
References: <1412840528-31508-1-git-send-email-kiran.padwal@smartplayin.com>
 <20141013130918.GY27755@sirena.org.uk>
 <543CC015.6090709@smartplayin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Cin6vE2EUt+aR6AJ"
Content-Disposition: inline
In-Reply-To: <543CC015.6090709@smartplayin.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] spi: qup: Remove .owner field for driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Cin6vE2EUt+aR6AJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 14, 2014 at 11:47:57AM +0530, Kiran Padwal wrote:
> On Monday 13 October 2014 06:39 PM, Mark Brown wrote:

> > Two problems:
> >  - I'm missing patches 1 and 2.

> These patches are same like this one,
> [1] https://lkml.org/lkml/2014/10/9/58
> [2] https://lkml.org/lkml/2014/10/9/52

You should at least be sending the cover letter to everyone so that they
know what's going on.

> >  - This only changes one driver but essentially every SPI driver
> >    initializes .owner - why is only thi sone driver being changed?

> Nothing more intention, but just remove superfluous .owner field for drivers which
> use the module_platform_driver API, as this is overridden in
> platform_driver_register anyway.

My point is that doing a change like this to random drivers isn't great,
if you're going to do this sort of thing it is better to do it for
everything rather than making things inconsistent.

--Cin6vE2EUt+aR6AJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUPNpRAAoJECTWi3JdVIfQqZoH/1zpUjyD1P7dWLDPiHA8t8Pf
iALwXiqB473LNG9nve2WzAH7ZauyExcDjZKcimvSGustjggS+zV5NMSsfL3SMyBL
uYev2fiAzRRKbQf9MHsP6H0opTXB+hRRWK3+luBNM51xJDdmlxejSgzJMs5xXreh
AtY1l/jmSzLTgFokQCm7VQo/aUKY1RNJivkDWyOOc2tY3Bz3V0WHbABVzuGHX7yR
KVBhd1cClAMQDp/cTt51zbLr3JI3q4fd/pZtHj1Lj5UCNSHKJGs+MUJzhSCoR9fK
nipcLyB89jsBzwAByHnuKN7HTJVEuxHnYuCMGvvrIwo3WCc4mumgh+hGclNfRKA=
=4Uv4
-----END PGP SIGNATURE-----

--Cin6vE2EUt+aR6AJ--
