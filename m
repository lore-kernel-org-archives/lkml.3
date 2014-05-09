Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbaEIL1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 07:27:30 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39117 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbaEIL13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 07:27:29 -0400
Date: Fri, 9 May 2014 12:27:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Chiau Ee Chew <chiau.ee.chew@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>
Message-ID: <20140509112712.GL12304@sirena.org.uk>
References: <1399559431-2065-1-git-send-email-mika.westerberg@linux.intel.com>
 <20140509103315.GJ12304@sirena.org.uk>
 <20140509112105.GS3722@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aaL8sFpsRKk5R4SN"
Content-Disposition: inline
In-Reply-To: <20140509112105.GS3722@lahna.fi.intel.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/pxa2xx: Prevent DMA from transferring too many bytes
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aaL8sFpsRKk5R4SN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 09, 2014 at 02:21:05PM +0300, Mika Westerberg wrote:
> On Fri, May 09, 2014 at 11:33:15AM +0100, Mark Brown wrote:

> > Is this definitely the case for all of the IPs using this driver?  It
> > seems like something which might have been present in actual PXA
> > implemenetations but got fixed in later revisons used with x86.  Equally
> > well the current code is clearly broken either way so I'm not sure that
> > problems with older systems should be a barrier to merging the patch but
> > it seems better to check.

> This code came with x86 LPSS implementation originally. The PXA one,
> which lives in a different file (spi-pxa2xx-pxadma.c) didn't have any
> such checks AFAIK.

OK, that should be fine then.  The PXA platforms should be being
converted over to use this file as part of the dmaengine transition on
that platform so we can't assume it's Intel specific even though it was
originally written for x86.

--aaL8sFpsRKk5R4SN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTbLuMAAoJELSic+t+oim96xwQAI/C8uzyyNVFFc9scb0AkZTJ
DdX/hV2R/crrwIaXWGROI+Xt7treqoMQ7Ac3MwMhdJe8KptYaYCyKkX2Wz0+UQOD
V0756VBsFrRFyLQpkgHU8a0ujZrnXOSpF6NXUTYW5isEoUJfMQHYcgRiRlrB4IyC
x2UG8ZBELVwGjKjK3iY42YG7IrmLQhNLlwRfqSgpg/Z8xFew/jOmm0L9EFXrIJga
OKkkyjF/ml8L4PnlB5trdWc2iDcQZYRNyNfA5gcB5BM9mnnX329A8WTFf+nTQksF
xqH5I4lpAUVg9d3fbM7W8SqrLH9XEdSGir6IgvJPetvkHulCrNVLzx16MVnZ7z3/
fEndPAgJ1y48e7E8NeaDrUYkqUSQEOHPPXbbBr8RUB56IwOcVkQn33U4GLNvq6v6
/f4eT2/eHkALyYGIl04WsfKjju0pA+TBmp2mHi0yqGUyRH7h9bGQ9AXHKZ8c1ux6
SSjHRlloFrxrSNkOfVCVbu6tRf9JQU9ZnGH9W1yxoDW4l53lXM2LXvs+lX9CxVnX
n/cMWiCyQbBTldPxSyIB0N98rIg7bgZDMpyAoYsSuJpo5cwpbMr1A1BpMKlR4hGx
CuNPZcseKMicYiWgGdu6NvH5hjQcxu060zuvVPjP/LdzaDoTdU+R8OTjkhaDrTbD
RdBBxMXh59FTCuYWtYpA
=CCEW
-----END PGP SIGNATURE-----

--aaL8sFpsRKk5R4SN--
