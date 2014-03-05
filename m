Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbaCECrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 21:47:14 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55841 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbaCECrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 21:47:13 -0500
Date: Wed, 5 Mar 2014 10:03:26 +0800
From: Mark Brown <broonie@kernel.org>
To: Nenghua Cao <nhcao@marvell.com>
Cc: Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140305020326.GT13126@sirena.org.uk>
References: <1392806653-29604-1-git-send-email-nhcao@marvell.com>
 <5305BBA6.3070105@marvell.com>
 <20140220085500.GX2669@sirena.org.uk>
 <5305F08F.8040008@marvell.com>
 <20140220134203.GA12197@sirena.org.uk>
 <53145D05.60207@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6axCafNXXMM8qu6Q"
Content-Disposition: inline
In-Reply-To: <53145D05.60207@marvell.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] driver: regmap: add regmap_parse_val api
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6axCafNXXMM8qu6Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 03, 2014 at 06:44:21PM +0800, Nenghua Cao wrote:

>       Do you have any comments about these two patches? Thanks!

I've not looked at it yet, please don't nag - one of the reasons it got
bumped down my priority list is that you nagged previously.  I tend to
do this partly as a function of looking at the nag making me feel like I
looked at the code and partly as a deliberate method for discouraging
nags.

Looking at this I do also notice that you didn't use a subject line
matching the style for the subsystem which means it's going to be less
likely to be looked at.  Patches that aren't for subsystems I maintain
tend to get a lower priority.

--6axCafNXXMM8qu6Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTFoXrAAoJELSic+t+oim94K0P/1x/S7NckG7AZ/sU60bXRvS4
Lp/sc30tPjeJUPloZMsQ07Q4lJJbkwYOioFTIMm5wbbwGHNNCHZe7B3NHLakaaIa
KRZBVah3Qsxapbi+xidKOZP62X/bFiwXzMOcFntGkumLmtoI7YXDp4F09EvesQZD
EKMe0HlmxadZduOrAfz4TOmPRK04e4PaaJOzQNHYTtbFvCmuZHDtxK+FKyJJT8DW
nzFJmScXwHHYkerbT2Uy+ERh87iDN9E5a0pfF+cVs4KzhCoaI4oC0S1zyzsmk3Ay
B4uI9LybVSzJK5WTylUG6peg5UE82DNT8EFeFBtlk80W2Zc/okmOsvUkx2wC/Xsn
IZB9ViIsu1tm/pbU/4iRrU4qlDX/T1X9qAb/LN5G4yrmsMnkqHZ/eTKRMplqblTd
MJcLaxtyNFepW2yBBI7uQb4vhWe7VSY4PjZ3OCum/z9QjzsGYmekRLosW9mvixFH
F8daR4RCsRk41/+PfC3eM9le11Ey638YJiamFFmjQJFp+cXf6TRU/4JC17MwUMQX
RQGzqV2L0Gu2S8wfjiHECxKquQHhL2CidkpuGQCSrv8BAFAs9Po6xZNK/D2UDuns
eSjgGnoVCEd+paxqWunc8fyM1qX5A1/buEsmFumQjhbUFl0nITnvM06M66JQTPb1
eSOdg9nM1MLn/Gi8XbpV
=QrAp
-----END PGP SIGNATURE-----

--6axCafNXXMM8qu6Q--
