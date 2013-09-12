Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab3ILOaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:30:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:47420 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770Ab3ILOaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:30:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,891,1371106800"; 
   d="asc'?scan'208";a="400633945"
Date: Thu, 12 Sep 2013 19:12:09 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] dma: pl330: Simplify irq allocation
Message-ID: <20130912134208.GE17188@intel.com>
References: <7a8e72582d8f4262a70bb9b7050fb6cb3be15578.1378305608.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="98e8jtXdkpgskNou"
Content-Disposition: inline
In-Reply-To: <7a8e72582d8f4262a70bb9b7050fb6cb3be15578.1378305608.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--98e8jtXdkpgskNou
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 04, 2013 at 04:40:17PM +0200, Michal Simek wrote:
> Use devm_request_irq function.

Applied, thanks

~Vinod

--98e8jtXdkpgskNou
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJSMcSwAAoJEHwUBw8lI4NH3T0QAMCHKvzae0fRLZlv/XiLB0bS
G6BxiIi7pk67r3ohOeBE9QqPVVfn5zI5hLti33A7B+kQMs4MVwN18p6xZz8jhafh
sEPALxZXfSVB5VAPRQ5y9etinPSGedbi7CeYXKn3OrQwsvqhFkty7SPbn/pFn5wl
ur6zw0Z6LuRB4D+MoeAx6i83jWM3q/QVQYz7TT4eNGfhKYUbt4QFL6b8u4me8lBi
Qxwmf8DlW1vbGPkRBPu1Vy77PxwmP7DoJuUzyaY8pURjPXzaULIKO26NxVe6MN+1
khyFSnEzNTaKIDDoc5qmq2H7yCgIt+oPJt89AkkN8nj9+DbBBOw/c7Hvb1XNKKyv
Mj70S45IewA7j5SagFVqDlujSjanx8ssNnqvAxoBPwpSmaDRFhm61Vv6w8Nso24f
u6AnWHnIAKq2cHO2wpdyn3z36+26vDcWbMdKjjRXSbTWwLe+CbK7rE5lEA3EvhYg
sByTNIuwt1atZfxs+WZtPOD/EV9ORYEUYVNVrwjEjvPX5+lJkkFN+qt/Ir/GXV+r
xOTDqcdYplzmGqH2GOdgtnFkpJ4uk4aHYI7FZQEX8aGHUfMSUpXyz8x/PJLUfiYm
rcNAY9dnJd6ZMyy87wulQvJ+2zVYU/WOq3Ctyjcz+EPhpILzli8+0kGclTN7u5aB
R0xMShp+lTRQ6+/9YdEE
=cSop
-----END PGP SIGNATURE-----

--98e8jtXdkpgskNou--
