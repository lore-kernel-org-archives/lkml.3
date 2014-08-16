Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbaHPVhl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 17:37:41 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38919 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbaHPVhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 17:37:38 -0400
Date: Sat, 16 Aug 2014 16:21:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20140816152144.GT28623@sirena.org.uk>
References: <d35c656e50eb7cc951499f13ef339d6aa1a23deb.1407930755.git.michal.simek@xilinx.com>
 <20140813123343.GR17528@sirena.org.uk>
 <b172f93e-b2fb-4cf4-a2de-d2ca62cdb83f@BN1BFFO11FD016.protection.gbl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/7+LvQqw8N5lf/3J"
Content-Disposition: inline
In-Reply-To: <b172f93e-b2fb-4cf4-a2de-d2ca62cdb83f@BN1BFFO11FD016.protection.gbl>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 216.80.70.240
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] spi: xilinx: Remove .owner field for driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/7+LvQqw8N5lf/3J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 13, 2014 at 03:21:29PM +0200, Michal Simek wrote:
> On 08/13/2014 02:33 PM, Mark Brown wrote:

> > Would it not be better to do this as a tree wide or at least subsystem
> > wide sweep with something like cocinelle?

> Feel free to use cocinelle for fixing this everywhere.
> For me was just easier to fix all xilinx drivers to ensure
> that none else will copy it for new drivers.

I'd expect people would be more likely to copy a random driver for the
subsystem they're working with than specifically a Xilinx driver...

--/7+LvQqw8N5lf/3J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT73cFAAoJELSic+t+oim9/q4P/jiZkU4mlsfHeDEbr0JXZ5Ho
Y880d/pDNzCzwICdh0IGJoVpVHWnze5eRkbQs2L1SsUaenfo8jwIAceHlE2Kzbuy
8Q7Ty1Wm+FhAsdqmrznFnxfP3+nvukC+nUpo7DSOkmXIE8k7jgwbBhkOEfiattU3
sX7fvJ+goqDyQYU4ujF1VJx7FirZwF/i/bL6T/jP1Gu0zqEMjsoMzlrqSg4JsdTH
cKzTLh27ScjOMdAvkKBFUjaLd2RR7smchX9JsjvFcHkW6OMrloZQ+rGrppiqNkU9
2nutm4IA7/aHEJ330X/fHQ/CV2Ds+kPeovIu1sxzsBcdQv3jQPfcrtmnFus1cFen
uUElkzpDBwG2s30SbgKBvxBcob3U4apMe8TplUQvjb/9ubUHmKSvrotnQ/sj3GQy
SongF9IHk0Z/+LGlTVH9EArzzX2XaChp0NhTE/OV1gb+6cmsSNRK5i1DaOxDtVEV
pMauVbRu4Ui8akSxMiicQoEil8ClNrfz1fo50lOeOtLemUjHzLnmKUXhIGD2XfOt
k8r5OEo82U5xlPt19fflmYJZt5zQHdTUd2zuKvjykhLo/LGC+ZVKE/gDQqLkFM6f
3gZiA7NYzXziaXDA/FWl2tmKgRTsHlRT6V7V/We0Dl8Nb1iNqE9PVLJHZmfDvcSm
5PcgIz58slOP8XS+bU1X
=775s
-----END PGP SIGNATURE-----

--/7+LvQqw8N5lf/3J--
