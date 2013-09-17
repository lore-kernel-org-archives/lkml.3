Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab3IQH4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 03:56:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:40796 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab3IQH4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 03:56:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,921,1371106800"; 
   d="asc'?scan'208";a="379358164"
Date: Tue, 17 Sep 2013 12:37:09 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Michal Simek <monstr@monstr.eu>
Cc: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] dma: pl330: Simplify irq allocation
Message-ID: <20130917070708.GS17188@intel.com>
References: <7a8e72582d8f4262a70bb9b7050fb6cb3be15578.1378305608.git.michal.simek@xilinx.com>
 <20130912134208.GE17188@intel.com>
 <5232DBED.5060903@monstr.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UfEAyuTBtIjiZzX6"
Content-Disposition: inline
In-Reply-To: <5232DBED.5060903@monstr.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UfEAyuTBtIjiZzX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 13, 2013 at 11:33:33AM +0200, Michal Simek wrote:
> On 09/12/2013 03:42 PM, Vinod Koul wrote:
> > On Wed, Sep 04, 2013 at 04:40:17PM +0200, Michal Simek wrote:
> >> Use devm_request_irq function.
> >=20
> > Applied, thanks
>=20
> Thanks. I have one change in my tree which I would like to get to the mai=
nline
> but it will need more interaction with others pl330 users.
> It is about adding support for interrupt per channel feature.
> For our case we have 8 channels and every channel has specific interrupt
> + we have one abort IRQ.
>=20
> Based on the binding and Linux code two changes are necessary.
> 1. Extend AMBA_NR_IRQS because we have 9 IRQs
> 2. Driver change which is just register irqs when they are available.
>=20
> Are these two changes OK for you?
Sure lets review them.

~Vinod
--=20

--UfEAyuTBtIjiZzX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJSN/+cAAoJEHwUBw8lI4NHDZEP/07xZ67XSPfkzKwXoeFknF+F
1x3Le3aDhKqnyhrfU2+JtLoRKX1ncWBbn3wZsx29FKyUIeE3AekN/j2COmL9UR/h
dYOwqMNdpMsNNdJw7lmtzU/9+mBoeSXcv75aDw7sl2KABbqxIhdF8U8c5iBCQaEP
FV1ciM3H3ouiGNx8/DzMkEBtPFLMIgX30B9nChrzKW+xu6XbfxDKIvQujHCNzTxf
pSWg08QliNQaATqZuD96minhqDSWq9wnbaf6DgbFTZbZvbDCVQ7mhZgRxHHO0RNf
SoTOwTRgAwUbz9FT8hxf79lyDhFyO57OM0OHkYHXgd2xULqVqWtUBXi2ZoFQvG/5
+vFHfTRLdeJAQfaKPOuptGMaWdCL9TMYO9E4RSZ5fSQcPcwLynyRt9DYj488Ghml
Co9rd7GE2WaXL8dbUgjt6bWXnWSj4quvcJxq/McvlIOAnaJHOBe+KZOSDKL865Bx
rH4WmMBsqOi77TM9rbBLByV334JipNRdtd1VXf2cUIfgzxgm+oD35Olq8PQ5D4Z1
bSewOuzPAQnYg2q0emrsQt0+EifXHPORhbcoUFf6FhhNJZ535+L/WQrN3+Ev9rSn
j52aFHEHppFd6WeRYtPYTqy1VwZhICM/yvWZq1coH27OV/4m0zyFddWHdXyHE29E
k1xbquVEdmKXd/MjZKAg
=YStJ
-----END PGP SIGNATURE-----

--UfEAyuTBtIjiZzX6--
