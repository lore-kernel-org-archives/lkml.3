Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934752AbaGYRv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:51:59 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54998 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbaGYRv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:51:57 -0400
Date: Fri, 25 Jul 2014 18:51:35 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        "milo.kim@ti.com" <milo.kim@ti.com>,
        "support.opensource@diasemi.com" <support.opensource@diasemi.com>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140725175135.GD17528@sirena.org.uk>
References: <1405333997-28764-1-git-send-email-ldewangan@nvidia.com>
 <20140714115718.GA18724@opensource.wolfsonmicro.com>
 <20140714180114.GJ6800@sirena.org.uk>
 <53D0D5B5.6010904@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YQQMu+1WUtOZ6W1X"
Content-Disposition: inline
In-Reply-To: <53D0D5B5.6010904@nvidia.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: drivers: fix return value of get_mode callback
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YQQMu+1WUtOZ6W1X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 24, 2014 at 03:15:25PM +0530, Laxman Dewangan wrote:
> On Monday 14 July 2014 11:31 PM, Mark Brown wrote:
> >On Mon, Jul 14, 2014 at 12:57:18PM +0100, Charles Keepax wrote:
> >>On Mon, Jul 14, 2014 at 04:03:17PM +0530, Laxman Dewangan wrote:

> >It's because it's returning something defined as a bitmask, though since
> >we don't even have enough modes for 8 bits that's not really a strong
> >reason and we should just be returning an error code as everyone is
> >clearly already assuming we do.

> Just to confirm, do you want to change the return type of get_mode() to
> "int" instead of
> unsigned int? And then return proper error type?

Yes.

--YQQMu+1WUtOZ6W1X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT0pkkAAoJELSic+t+oim9zx8P/irDhhCrKwgyRQ739M5ivsCs
2dKSMo7OSzOtavNBKwwWDfu0Eg9V1dvzRdoK/E6kqsseCqsgEmbNZt3Hbqniwh/Z
ac+ntuN2f4FA4YwJ3OO6U+PYgXsvlspiKYLud+UqSfL2ZMFR+81ssU6WJs3RnRFd
zZ5Am5eG2EObozTWV9LwMZ1D7BKb6H6FITJ3ZzvMRh1DHOvRq8RKN39bqOyFd6BY
3DmfHTeKgz3ZD6m42+RuxWNWLkFl/NW155BlItJ0rbQTNJ4y0PbdWdhimXtg84F0
ZeWFHSMwhSalkbm4r28MALr+mK1Ih+C68nLsLCn0mb/C7tleJk9uWEUqGizbwLD1
2ADbWphU5mN78ZtAWBYQLQJY2lrTXIHUs+ODD+336gE1FT7RHg2wFX1i16NUBGmX
D3/2bRjbShATdknUBcHn7f/4IKK7i9k9A2o2ODlTHAJCAcvKYnz+FGGHOnkLUhYH
dzFaeR5qeS4ZvGJu9/vx5q0bEqgiY9Ux7Pvz+uisZAHRYvFn27PFgJeOKqh8AYFo
VkQkEp7TXV0j25yXGD5JfCNQEl6hbjW/W6r1qT7oyxyCzodyXO/256O17tvcnb+2
a3PMZPqppWfuIy4npLtYdIz/p2pG5ofkxIHVnt5MwSzvoKINM6t5MiQ3KRT44Zsj
F5hULT0A083iCSyxxFvE
=i/74
-----END PGP SIGNATURE-----

--YQQMu+1WUtOZ6W1X--
