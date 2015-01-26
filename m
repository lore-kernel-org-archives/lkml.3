Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbbAZTYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 14:24:03 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35073 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466AbbAZTX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 14:23:58 -0500
Date: Mon, 26 Jan 2015 19:23:51 +0000
From: Mark Brown <broonie@kernel.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Message-ID: <20150126192351.GI21293@sirena.org.uk>
References: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
 <1422029330-10971-3-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="BPjCafsbA2ap7OrL"
Content-Disposition: inline
In-Reply-To: <1422029330-10971-3-git-send-email-ricardo.ribalda@gmail.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 02/18] spi/xilinx: Support for spi mode LOOP
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BPjCafsbA2ap7OrL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 23, 2015 at 05:08:34PM +0100, Ricardo Ribalda Delgado wrote:
> Hardware supports LOOP mode. Support it also in the driver.

Applied, thanks.

--BPjCafsbA2ap7OrL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUxpRHAAoJECTWi3JdVIfQ8k8H/jeMgzAyGYU02wsTpmaTrZDB
7tPIcOaTM6wb4mKieQ0BPkiS056baEt/sEvXmD0BDLx9j0lzh2ngZ0+OgobArc3f
YdSmoMmghDWm+ZLs8RyfLgD5kZY1oa8CDdiR5ZpAbgTLAzblnUJ8zY2ewgxec5M0
GayfI1cKu3CwmoZvmmigQ70c0OnTZbPgKAFGrQK64aid7VT09ETreKD5ODaqnyfX
PVEFo556Nck/SN5X0IPMBMlKGsCYTwN0KlWZ9sbM6d4VBD80dX1b9KA5qTcbA6/X
wHLri3rLfJ4+IMKEPgaGBPdMfVfgrxzsWGn9tp8kXK8YM5Rc7kFUrBncJlkp1Ts=
=aG2v
-----END PGP SIGNATURE-----

--BPjCafsbA2ap7OrL--
