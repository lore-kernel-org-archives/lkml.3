Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbaITQsn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 12:48:43 -0400
Received: from sauhun.de ([89.238.76.85]:32986 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbaITQsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 12:48:42 -0400
Date: Sat, 20 Sep 2014 18:49:07 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, lars@metafoo.de
Subject: Re: [PATCH] i2c: Add generic support passing secondary devices
 addresses
Message-ID: <20140920164858.GA2260@katana>
References: <1409925739-28188-1-git-send-email-jean-michel.hautbois@vodalys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <1409925739-28188-1-git-send-email-jean-michel.hautbois@vodalys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 05, 2014 at 04:02:19PM +0200, Jean-Michel Hautbois wrote:
> Some I2C devices have multiple addresses assigned, for example each address
> corresponding to a different internal register map page of the device.
> So far drivers which need support for this have handled this with a driver
> specific and non-generic implementation, e.g. passing the additional address
> via platform data.

This raises the first question for me: Are the additional addresses
configurable? Sadly, I can't find good documentation for the adv7604.
Otherwise, if I know I have a adv7604 and know its addresses, this
information should go into the driver and not the DT.


--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUHa/6AAoJEBQN5MwUoCm2cowQAInZoQAN+opPxEQBakjTtvMO
PBst3S+3n1IL75pEgsx6nqA9Jj5DrdEPTL4NRXwK5Oa9Cd1AyrjsmyX4267YeGz8
Ud73Zxz04Szs6h4iYOJebuBBkHKttTETqv4RVpHDm0PGRR2e6K1zPl8Ik9bxfSI8
FvLhQAv6ijO6iTtKzv3GnrMdqkHO1iY+vwy+M01caP52ruRl4aatEziLgY/1hn6v
reCClnyswVdbz/JEcCIoiHScirRVUJpIMYqbdgcJp1nqcQ6W3wsg4JNUrxa18+Rm
pRuJLVwqyzuM2aLvKA22C3i4uHz8L6zdSWswmrnyV/Sy6G/7CVG4CB4iIS6X5sSo
p7ay1aLrPYcFTX66hr0Fz+1nDPkQ8lp/gT3mnZ2D1pLxwSJyyC3+/1vKVtkItSA+
BmQicrewzCnspQ7H+3lSez7RaC8ye6pGIKF4dQABNIj8/IaxU7onHW9wOwB/Q8Y1
sXId4PPNoIMn28duS5M07lB99aSruemP1EHUXx1XaAkSLmD2SBvK1QUvE2v9zCcS
kNGTqlxnvb/TE38UoFtdQ8yQs7tH8awdavDzUvpPTOP4x0Vv8GmH3YHcQDcndz0d
gnCpLzdLE3ukRr33AsKKU5rsj9vA7BStb8g35EvCVwlKjerVaierYc+CWWUOpQgv
w3M6pKO7MFZ/o3t+QJeY
=Kl2+
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
