Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab3KNMbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 07:31:05 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59706 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab3KNMbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 07:31:03 -0500
Date: Thu, 14 Nov 2013 12:30:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Tim Harvey <tharvey@gateworks.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20131114123057.GO26614@sirena.org.uk>
References: <1383715045-15341-1-git-send-email-tharvey@gateworks.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xTKfHyrFnSV9DG3y"
Content-Disposition: inline
In-Reply-To: <1383715045-15341-1-git-send-email-tharvey@gateworks.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 149.254.58.211
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: pfuze100: allow misprogrammed ID
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xTKfHyrFnSV9DG3y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 05, 2013 at 09:17:25PM -0800, Tim Harvey wrote:
> prior to week 08 of 2013 Freescale misprogrammed between 1 and 3% of
> PFUZE1000 parts with a ID=0x8 instead of the expected ID=0x0

Applied, thanks.

--xTKfHyrFnSV9DG3y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJShMJ+AAoJELSic+t+oim9jgYP/3Avte624fex/TqBeEU6aO4v
lGVhJ4m0myp6hI+wJvfwpHMrWVQ8Zs6BbwWeCXxCT2dBTPDJSLlCtZQwSyKffPAx
5RXC4UmTh9/4gNsS9vVRhg/yAIW99axRXLnKsUpZd/NI0jnhS8CRofy/NIzrotwz
9v5h9utG11IcC/s0L9AsdKep+WF9HVBvS46xZpuOMktOS319gdtAofltkECihhob
Is0zZhPY1Ynwq5alclL1goDKdBArsDiRzOUgB30xSXUh3qZBwF2bLlidvLvKzlkv
CGAEXnZknYxBHAU0XoIup5zlkyKcbPlWqsJbt3EvWX1HWD1TekpYV671aMNGtwgq
X6dC728JL+qLRfE6jpY884ZdeohEWzyf3qK/qhqBu5IWDIm9+YfRjFUDOIQDgjT/
t3GJx0BrSTK4O96OZkIxs8VsdTiPnlkpSvwe/xeF9/NhJnhRgBbH5vDnjyOFF6QD
yzLYKpujKXb3kQTF4tso7F/nAK0i6cIPpRoUa+EuCuixs0LYNNw6rsKjNBLYekC5
dt+5qh8kve5cacKc9murYjJaUtt33FtyJbfifYkMzOnnqJWN1zwJkf3igUF1HPvI
w6cXh0ZLpkjlYT8/ZsUHrBlPDmb8Iqjfz7Ocycg/rELLAH5C1npruwVzREMsThhd
XCAI/1mUT+SEo9wZcmEf
=Fas/
-----END PGP SIGNATURE-----

--xTKfHyrFnSV9DG3y--
