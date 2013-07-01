Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab3GAIqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:46:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34366 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab3GAIqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:46:46 -0400
Date: Mon, 1 Jul 2013 09:46:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Chao Xie <cxie4@marvell.com>
Cc: Axel Lin <axel.lin@ingics.com>, Yi Zhang <yizhang@marvell.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20130701084620.GU27646@sirena.org.uk>
References: <1372426354.28529.1.camel@phoenix>
 <20130628135022.GJ27646@sirena.org.uk>
 <AAD1C6EB06EE3649B35B7E026785068D2581736992@SC-VEXCH2.marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="drH2ShMMYOwzF+Tg"
Content-Disposition: inline
In-Reply-To: <AAD1C6EB06EE3649B35B7E026785068D2581736992@SC-VEXCH2.marvell.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: 88pm800: Add missing config.of_node
 setting for regulator register
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--drH2ShMMYOwzF+Tg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 30, 2013 at 07:14:55PM -0700, Chao Xie wrote:

Please fix your mailer to word wrap within paragraphs.

> I have seen that mfd: 88pm800: add regulator sub device is already
> merged into Linux-next. So you mean that I need wait for 3.11 to
> release, then resubmit the regulator patch?

Yes, that should be fine.

--drH2ShMMYOwzF+Tg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0UHZAAoJELSic+t+oim9XtcP/jtM7fWvVCdeas4JiaaUJR0j
9KvU+TUSnFI4pEpT3/AyEbpesIeHJgxsLf9UbDIqCgnr1q1mRfkypHXRH0xLNFKu
sj6t5E84HY/mPhJT41dcVRt3nGCcriTIDQewIvh6oqkE9W5z06sVMUa96I3p0Auu
2zlIkf+zL483m+LMGgtalVuyH0qcVZvYoUvl4vmofPMT1X0auiGK2RzNqwaWjofS
cv+fE22lx691hq0LanXBZP+sDjwOKziiqKT8MGXthm6HFNOBoBFBQvHxfHbmZTuA
oIay48jOqo4VySHXqoBs+YaevoBxusqPlr0HTL1E5ct2ai96chO2BbxoQQObTKsB
Y7WPWPj8X3O3wpALQzkWZhe52Pgr1o8c8ucDvt+1iX46VNnErQOPkQdonpUw6oFj
oC//dLCeXJ7WIuc0YPvFmzFREDEFezoIT/O8jq5Hitr8mMrp0AeYTQs7RONQOjy2
RXPwz10EjycbBxlFSE7q4y5vdNe/GUfDWynjYvB7Hi7KxyudFAujMQw8eGrA+uv7
VidcR1+LXiqUUB9Y4xcDhN+2ChOv0yVPw6EievPBzeONpz7mRPZftxkLvMmZYldU
GYQBEoI8sS0IPFJVl5tBzpg7wq4Bb55mqrLfkTNH/bbuPvzxLTwmDHEMMv0IdJ2u
aABAX+fLko1SNJkURsZT
=D8XY
-----END PGP SIGNATURE-----

--drH2ShMMYOwzF+Tg--
