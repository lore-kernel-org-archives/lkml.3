Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab3C1MzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 08:55:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47475 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755705Ab3C1MzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 08:55:17 -0400
Date: Thu, 28 Mar 2013 12:55:13 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robherring2@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Axel Lin <axel.lin@ingics.com>
Subject: Re: [PATCH] clocksource: Fix build in non-OF case
Message-ID: <20130328125513.GY18316@opensource.wolfsonmicro.com>
References: <1364473805-773-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <201303281239.46639.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gvfmMvdBxOmac5ck"
Content-Disposition: inline
In-Reply-To: <201303281239.46639.arnd@arndb.de>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gvfmMvdBxOmac5ck
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 28, 2013 at 12:39:46PM +0000, Arnd Bergmann wrote:

> Axel Lin reported the same problem and I fixed the below code earlier
> today by using the correct __attribute__((unused)) and dropping the
> section magic for the non-OF case. My patch now looks contains the

That still looks like it'll reference the function?

> change below. I also proposed a fix for the clocksource driver
> at http://lkml.org/lkml/2013/3/26/103.

This is a different driver that I'm trying to look at here, the s3c24xx
one which is still not merged. =20

--gvfmMvdBxOmac5ck
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRVD2qAAoJELSic+t+oim9Fa8QAIEf00sD6sTYdpMxiHznVXsO
rmAJpQnyDSIQsBrh4ypBpODEr1nmYb6dg7j2hhDo52EYhKV0vI9bqfFFOBJCukwC
AaadipBxNMivKbyfHW9nMLaHMA7BYZVqQwUYPJlwxUOh+RZ2V8dWRFo0XebmUR7c
Jl3jLT2f61uCyXzW+TqUcUfvsSOG7l5jO10BNnRv7Jm+9MnGG0z0Fhp9kVqTo98c
cC8JuY7K2rWYU9KQEQhOEgfo5lXr23gAHR5AqxAuKOaHpiPppUMFX/JwhwkZbYSF
QF5pAIT5Gvoe/HV+nMBd4KcJ2CKGR4AfEqJDgODtYsuYMLeWhemNIpdPTncy3eta
fNK20+1Y7VF7QQsFeGInY+bSjakM6mfVOt9TK0h6Rgx6SHN/gGHVRbgl4ytZrVnP
DiD2ziNxttq66d/ZshGWF69ylv8FRN4L7s9Py9sIcgBhcWQztFhPYrz1xjfNM5Mf
5IUdVvQTx+YR+VR6LUd6QJ6L8TVEjcxVcHKkb7MuKTxvedHZtx6eFEe6EzDDWUb+
NYgCPsQOhub/mRtd62W5Q1jajEIOGxTx0t6iMVDNsL5LNhf+xi+wqCkGcWAMO9qq
S/1L6AyIISxyn/2ZnabQRW0D8hYsM36y/OOXDg5PAK4DuuvbJ5PHwxkUEN7uoU9M
XVjWT4/4D4Qafh8X24tc
=axqk
-----END PGP SIGNATURE-----

--gvfmMvdBxOmac5ck--
