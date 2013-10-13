Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab3JMQ7w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 12:59:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:10052 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249Ab3JMQ7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 12:59:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,486,1378882800"; 
   d="asc'?scan'208";a="307253693"
Date: Sun, 13 Oct 2013 21:37:06 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] dma: pl330: Support per channel irq allocation
Message-ID: <20131013160706.GO2954@intel.com>
References: <08a752258a021feb91eba25eafd28ea2bacf72e4.1380523844.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CXFpZVxO6m2Ol4tQ"
Content-Disposition: inline
In-Reply-To: <08a752258a021feb91eba25eafd28ea2bacf72e4.1380523844.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CXFpZVxO6m2Ol4tQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 30, 2013 at 08:50:48AM +0200, Michal Simek wrote:
> Some pl330 have per channel irq and it is necessary
> to allocate all of them. Loop over irq assigned for this
> device to support these pl330 IPs.
>=20
> For example this IP is available on Xilinx Zynq platform.
>=20
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

Applied, thanks

~Vinod

--CXFpZVxO6m2Ol4tQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJSWsUqAAoJEHwUBw8lI4NHvPcP/i4l2nYrllvERjffhDVVq9rK
ADxp5eW0jRR6T9Z0rNJl2N0TTyv/Gp9l3bRHMP/EJV9Cm1oSVXY2ZSUftugb5WZ/
sSq/8l6HJADcY87gbUryiplwvLp1d3amiud4DBhxs8F4OUnSMtcGOpcvUWvK5UGD
mOpt5i0kmCDiZXfk/feO+Wf1CfFCC0soZJnE2RYsLOV5wRbDqMtwf1HfoiqxjnqZ
Qb3WDXLqqx3xLe0ilw5Y1TBBd595iCTqCvGFu0C8UZjrO292OJfLFO0uGHN2xvzW
J+xL9FEYu838c7pMRsUkbId+5oTEGBJIJJsP+1vUUquCJFX0vwO1OKmsI2htZ3AL
pKpVzV0HnNsJ/q6JNPkz69qUWGy4MWlU9LiaG4cd+PKQI+AOGK/wNawgYJ9Kb09g
4cIIKBy3x8VeYrZiDDhtWbe/axioQXb4rxcXdaLDSVbF8/IeJy+WIMP/5XBh5Q6h
6QDrb7+PtCOWIumG6TPD94iSFLtJJdCWJIXErnduLMp/+zXZm6HMwEQJTMbqRBBu
eD1B1/88Kj3ONMC5ehXBodlMY7AxOam3HPBcuFYOffEi8XGOJLww5lU+sexFlhLc
426aeCh/NLIVb/LIuxw/pDiK9ZpJhTrMpdCW7nPsP1LLFeJcuMepgzibiIJsXwr3
9KJW5eAYK92+HqU2ZSOt
=5bbt
-----END PGP SIGNATURE-----

--CXFpZVxO6m2Ol4tQ--
