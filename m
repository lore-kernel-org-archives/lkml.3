Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbaCJQtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 12:49:13 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45171 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667AbaCJQtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 12:49:11 -0400
Date: Mon, 10 Mar 2014 16:49:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linaro-kernel@lists.linaro.org
Message-ID: <20140310164904.GO28112@sirena.org.uk>
References: <1394468977-23149-1-git-send-email-broonie@kernel.org>
 <20140310163811.GA16697@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0fZDDgbv4XPjhm7m"
Content-Disposition: inline
In-Reply-To: <20140310163811.GA16697@lee--X1>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] mfd: wm5102: Mark register 0x19 readable
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0fZDDgbv4XPjhm7m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 10, 2014 at 04:38:11PM +0000, Lee Jones wrote:

> Can we have a #define for these please?

It'd be nice but you'd need to ask the Wolfson guys to tell us what it's
called, all the information I have is the read in the driver source.
Meanwile we've got a bug.

--0fZDDgbv4XPjhm7m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHez9AAoJELSic+t+oim9ueMP/20Qjmycc0m8FHkL+PJcLNsm
BDgaw1vFVKSXZzPHrKCjuHNKjnlpyrKKlEFHiFXV4p8Ow/dgYuciQOidsIorjrec
rGVJVNbvPR/MvQxuYupHsVitYaN1y41UMw9PDyuLDrjsIIs0KQDcSBuR50mGJRXm
B5mF4z2ECRsnLDAX/Fi4RJ4jbTAbBXDNs7SPF9HCzoSQ7UPvwiibKZseonARUj6E
o5etapQmj2mmGzk4i5qgBpSiib5VsGcDNJ/H5O0e5s1JZrpk9+whl+YLS/43DEgj
WfHXkpw693v96JZmxMWwTk2ZLMOy4eNePgzicBSpiP5WGk0OZN6+ngtTZq1JEigF
QfQ5ZvT9D18tfdZ6I5+zq4tx5bz41JPoJcmPBTPnfRN5MfqGNqxoVosX/8yM5OaG
s8Siq1sOieoOI77M8BFpATo2K4x2grfb5pxkehvmVqNV+jTiOLQfOomTL/MKZV0e
1YyraUFDsgQsKQ+qlcXfNMIelY+XfJOsuKgNSAFFfkhMERkz92O1yqT5c7CHHIYD
lp+BCC5PZ0CVeVUYtrRVLey0qwO3q6BiD/tZpVcGNGJG9nPMV444G2SWDBAcXXRw
7VrfJgtXZ0t4K2pmDg10H6xg43/ueleFSersRjxEdz1pvuSHqpY7QYDEqXzlBCfZ
TzLwgeC2rqs+Fzf7pE9H
=OEAH
-----END PGP SIGNATURE-----

--0fZDDgbv4XPjhm7m--
