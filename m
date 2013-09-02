Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab3IBHRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 03:17:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:25005 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757181Ab3IBHRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 03:17:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1005,1367996400"; 
   d="asc'?scan'208";a="389825674"
Date: Mon, 2 Sep 2013 12:00:59 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Dan Williams <djbw@fb.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pch_dma: Add MODULE_DEVICE_TABLE
Message-ID: <20130902063059.GI7376@intel.com>
References: <1378076526.25743.55.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4ZLFUWh1odzi/v6L"
Content-Disposition: inline
In-Reply-To: <1378076526.25743.55.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4ZLFUWh1odzi/v6L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 02, 2013 at 12:02:06AM +0100, Ben Hutchings wrote:
> pch_dma currently isn't auto-loaded if built as a module.

Applied, thanks

~Vinod

--4ZLFUWh1odzi/v6L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJSJDCjAAoJEHwUBw8lI4NHf1kQAJbKMh/icgMoAq/5cgC2duVJ
0DF6H2naHX4S3j7RrkQG2BgtprT3BqpHq9JqozTla1ePXPJGteBdxXBSHZ1mUes/
5WbThuUNwz6wJcr1e6QGJGQtj6z2RxZyUCSe74gSJ8oto7SWIvBWNuQSwFhVdhr8
OTc/rTP+8kkiCye6QwMgwESwLYgiQ0Tug8wD1R31eXBnfwWLtlLyyGu7QRRbRBmv
qZxBOXQfbSfRfMYzELD0EZLzn4kavsYcxE0Rl2f9GhSDa7SPdYEFa+zaPkninsSM
o3ozszN/WscBUflcRMwHtV/7qtxvsUelTBjyMPrUKyk/3mm3jqRKpY2rHCs+7GXl
XjfyY45BTIvZPixWqCDkNaj++RVbHbv7m42hvrZTuJN7gCnA1JGoR0TRK56qmOZr
Ije18PHBOSCO3Jc6msgZhWLZRxokqC2FlKniNSHGYz7JAJQPQEhkr+hYuMDllOBL
z+nfPWi92qJdt9XaLUEqSF++yOn2IeXSuIsiaFq2tTFKPv2ZUqiKSDONNriuW/gG
VT7PJ3PsAflhdaroLDPS4SwDVgtItbWYAsfQ3Q3PcL3w/aN1QlNdfQ8npCL6uHA/
Ls/S+SqO2qrwdZhzTvQ7hLXZVdwBZhkBVZ2VV6QOt5DH13XrUZBKQvlwxFuxtTaB
V5PjcWr06RcPX45aem0h
=C8qV
-----END PGP SIGNATURE-----

--4ZLFUWh1odzi/v6L--
