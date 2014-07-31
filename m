Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaGaUuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 16:50:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39011 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751656AbaGaUuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 16:50:06 -0400
Date: Thu, 31 Jul 2014 19:37:30 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dmaengine@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        laurent.pinchart@ideasonboard.com, ludovic.desroches@atmel.com,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] Documentation: dmaengine: Add a documentation for the
 dma controller API
Message-ID: <20140731173730.GH3952@lukather>
References: <1406736193-26685-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140730160607.GM8181@intel.com>
 <20140731074440.GY3952@lukather>
 <53DA3A48.8070900@metafoo.de>
 <20140731161331.GD3952@lukather>
 <53DA74B3.6060502@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Xp2nimoPFnvF0aLh"
Content-Disposition: inline
In-Reply-To: <53DA74B3.6060502@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Xp2nimoPFnvF0aLh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 31, 2014 at 06:54:11PM +0200, Lars-Peter Clausen wrote:
> On 07/31/2014 06:13 PM, Maxime Ripard wrote:
> [...]
> > From what you're saying, and judging from the drivers that already
> >implement it, can't it be moved directly to the framework itself ?
> >
>=20
> What exactly do you mean by moving it directly to the framework? The
> slave_caps API is part of the DMAengine framework.

Not its implementation, which is defined by each and every driver,
while the behaviour of device_slave_caps is rather generic.

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Xp2nimoPFnvF0aLh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT2n7aAAoJEBx+YmzsjxAglmsP/RPWmmHFfHtnkMHr46IyMl4D
UZUG6BRHG561DQnnINsH5Sjhw+ZIXR9//Ein9AHkVTmQ8f9yvD4uFtHBv/BDlbiF
eW9MSM7JbjD+mDMW/k7yJkKNUVFm1WVl9ijrMJFoLZzY2PTGFCx2qBohn1LIIbnn
oWum+Gw86WTbH8+Rxjl4o6eHt45DQjArF8MCfazbSrK62O6UnIGgmRr4swtbDqoz
JykAJjwNcCCz3sHTK940rrbNPq2yF8WwE/h1xzBaYf6s3rWBu+RUV53s+mp/fV0H
hKVkUENsTyDsrr10F/uRWP9hhghALg1sbSqgnSQjniS3pzLK1UBCpArAq/rAGcaH
QOQLVB/CpFLLGWb6E+fJm3bN68Qprdfjc48iK5PSp+5DbeiDyIU5WIdNQkMRwbUK
MA99jItE/Jlc0kBMf6Ff5l/9CbJPPJOpOkOXEDTv9eHKigKBTkQ6a+1/YmhWQ/u1
Fd+MWjpH/jS3HaeC56DkV8TywVI0m+huHQ68tjgTBuBcBcCxgmw8UXjgoE2MxMjX
lSuzBPtaZLfFsbkRzt43F8DPb7bZR0RbpxSH+2vg5eLkrwMnYoiOkOtNbPtVoAUi
TWo9d1uQys5ugti57dulJWwQU7H0J+N0jZeGVVXVrxTHxKRBw4IK4c8hn3Dyoz4T
AMRubG4n5icLnHkDYw9Q
=NIGH
-----END PGP SIGNATURE-----

--Xp2nimoPFnvF0aLh--
