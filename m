Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab3AKLxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 06:53:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44664 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753237Ab3AKLxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 06:53:53 -0500
Date: Fri, 11 Jan 2013 11:53:51 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/11] extcon: arizona: Support HPDET based accessory
 identification
Message-ID: <20130111115351.GX20956@opensource.wolfsonmicro.com>
References: <20130110120231.GL20956@opensource.wolfsonmicro.com>
 <1357819462-12232-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1357819462-12232-9-git-send-email-broonie@opensource.wolfsonmicro.com>
 <50EF7238.1040408@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AAkN98o3X3ouhQaz"
Content-Disposition: inline
In-Reply-To: <50EF7238.1040408@samsung.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AAkN98o3X3ouhQaz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 11, 2013 at 11:00:24AM +0900, Chanwoo Choi wrote:

> > +		/* OK, got both.  Now, compare... */

> Is is correct comment?

I think so but that doesn't mean I'm not mistaken or there's nothing
that could be improved - why do you ask?

--AAkN98o3X3ouhQaz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ7/1HAAoJELSic+t+oim97fwP/2tmlJJunCBuqa4Xke3LLejG
JXj73RZGCckrN1oUF2Yc6IMLaWyRf39x6dhzDSCyMwP1/PBeIu0+7cAtHRd/LvyA
I+lhG2rQvhLTEEfSp8ZPYtyC1fhFX/Jp+N4da6D65cy1prf7/CVVXv+KRoN5tHrH
XP+vw0dSSJyjI833STXsgRzq46dtkXJGhP4m/1opICmN3XP4/+78OwogkF24EYrn
deRf8Q+h12pT2pxxusLwe6oShbYhAFdeYltye35DXpHwGanLUTSVn+j1gRy2EN1x
M3nEpG7B0Z8vZ6NvSf9Dj1ARcwrBXdE6/1sZ3hb2JCdiAhpnKZqey3tX6CFUHUr0
+87vaByArKE2smFeWOmFtY2lsZFDF9NTkNBYuWnYFS/8fB/gRfzsdPXzNNd4o2Gf
H4P/PUlEv6Ox9ib0Lveh/1p5QvhTYsIWTaWN3vXM+TqnKlSGyI8gywiwmUCckmKm
TYS2pQ37ybHckoAYhgzA3DHB1d71mh8fVFZ9/4M+sHLCaanuKT7S7rcDa6trXLCY
uJpIBw4DMStKCijB7XwTcsLKKXNJzRcQj0UEbhm8gVWJobuvmj8TSA6+qNpK0QLT
kJrI3iVOvneYBHGGvDNXwgtdM2jTDpWfzs1vHkJnkoirrf+avYzwJY/z/LaOPjEe
BZREF8/RE2bHfVIyUhk9
=NTio
-----END PGP SIGNATURE-----

--AAkN98o3X3ouhQaz--
