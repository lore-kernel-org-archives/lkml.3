Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759610Ab3IDTPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 15:15:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54417 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3IDTPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 15:15:15 -0400
Date: Wed, 4 Sep 2013 20:14:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-spi@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20130904191447.GZ3084@sirena.org.uk>
References: <1378291063-5723-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rMBvpMIlSQ3hWZ0K"
Content-Disposition: inline
In-Reply-To: <1378291063-5723-1-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/pxa2xx: check status register as well to determine
 if the device is off
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rMBvpMIlSQ3hWZ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 04, 2013 at 01:37:43PM +0300, Mika Westerberg wrote:
> The current interrupt handler calls pm_runtime_suspended() to check if the
> device is suspended or not. However, runtime PM status of the device is
> only set to suspended once all PM runtime suspend hooks have executed.

Applied, thanks.

--rMBvpMIlSQ3hWZ0K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSJ4akAAoJELSic+t+oim9/S0QAJIwESmn2bXSm3s18UVKdl9f
MWxBTf+Ggx3wpaEBWFfp7qqFjdsCRw2VWVGxi2AJeO8pZ0/AM3w6knlDF0oCbZjP
KjWQLiwnTFREraCHEVrJImCuWi1Q3n2TX7DaaAEecfw8aR1+rXSiaK7ECYDncB6w
NmYiiiu+rHxQP4/wJJiCh+OJkgzjZFnAEcmmUy0W0z8i+hMwykMpcJM0KbdBt4pU
aItnPDebVUqDMurX4dLWzAQtvrCPiwzG/DfBs7T8rMSwdJt1kYGnj9IklhHftkxc
EikbVPtNeSpVOziQjoa3xEy41QHwm1LMBSyzyCkfh9d9TVN0vN/fl7IdZtIWhrvF
muQu5Zcrk+9AorgdI1cgINKrm9d1eOU6pekKU02wnuqk/rVTqpBuQm5Ers/Hysfp
uht9R4AMMnmXCQa7vj3wrgoQ1Xg+FsUsXMx61v4JnDgL/MsTQ2oa82ae/pDj+4yc
TaR5Boi8w3E/9lbC+wnF9uSagosTVDvpS1g/7BNLnIq8bC7boTVlAyCkyYHCyw69
7iByTxCMOStk0WBziOJ1KSAUuyxkns6p8XpFungCCuRLKXAVE/o3vFRKc1eeswxX
WPecBnvKTv6nzcXk6sFU4iBg6yuq+kJVxI3R0xrGwBlgSTjBSa39JfNJz1KC+xh3
UMtDuWAGf2hV3B8ZzJBM
=pxDb
-----END PGP SIGNATURE-----

--rMBvpMIlSQ3hWZ0K--
