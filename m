Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab3GATL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 15:11:29 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54577 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab3GATL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 15:11:28 -0400
Date: Mon, 1 Jul 2013 20:11:22 +0100
From: Mark Brown <broonie@kernel.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        Ryan Mallon <rmallon@gmail.com>,
        "mika.westerberg@iki.fi" <mika.westerberg@iki.fi>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Message-ID: <20130701191122.GN27646@sirena.org.uk>
References: <201306281143.35130.hartleys@visionengravers.com>
 <20130701102757.GF27646@sirena.org.uk>
 <ADE657CA350FB648AAC2C43247A983F0021DAC38FFB9@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YqRRwTcmsyYCeoLs"
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0021DAC38FFB9@AUSP01VMBX24.collaborationhost.net>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/8] spi: spi-ep93xx: always handle transfer specific
 settings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YqRRwTcmsyYCeoLs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 01, 2013 at 01:15:40PM -0500, H Hartley Sweeten wrote:
> On Monday, July 01, 2013 3:28 AM, Mark Brown wrote:

> > Applied, thanks.

> I was going to redo this series based on the comments I have received
> so far. Did you already apply this one? Should I push it to the front of my
> patchset?

That's what I said.  You shouldn't resend it at all, you should base
your updates off the relevant topic branch.

--YqRRwTcmsyYCeoLs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0dRXAAoJELSic+t+oim94WsP+QFmdF95A3xx3vo2zfKVD26W
nyV3mmMakxxLe2NII/dlCPmnFuc+S1bwtqXqA6c3R54G/kr3t9dNEMsPn69Q9Woj
4YUJzOfPT/rKWVCa0c3aAB7GG34A8WO4417nLsT3Z6rgAZxgSalRBWSAwOsrySAB
AFOB4wzYgjih2qJ5LSpB+g7P7G5zk9UK2tRQ+X1WNrYsvIPh5YjjMArBlRxH6q9f
6D2wmEdF8gmWrajj5vGhDxEq/MWnAplArOq1IUirtxZ4iePnH3hv7l+OQglwQlJi
fJggsKzkJJp6r27VmvMRxhmEI+vaaFw3tm8zl09JUmydSD8T02vsgIk2pKl1iOFE
vEmcC6YPEFUc8SrmVWF1TLgGInx9S6J8C6FN01HSPlYCH/lSgvLOIC/IqagiNWLX
DFteDGSZFItVl51qJvL1KQwMw54n7RpN2+BzuG3OTveaHXVWYsPRdY6nx74XsrXY
INyC9zGoZNn71E/04ET8VJaG7oybYoujySDa2+OEf5KQXcX6l8rHWNFMW2441ECE
f3SwZip9EhAW1la3E9l7X/TpZNGBymi/Z/LV15I8LC+8lOpoJAcggmNfmvIBas+R
hqd3GhLxDS///unCGO05ku2LyFWqBPVctyQLYhtnq0RPEONQIrWv2fLVs+zZfJ0y
d+JvO8lBgaBG8TadYS4J
=s85i
-----END PGP SIGNATURE-----

--YqRRwTcmsyYCeoLs--
