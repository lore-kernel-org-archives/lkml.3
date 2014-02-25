Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750774AbaBYFCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 00:02:48 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:41714 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaBYFCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 00:02:46 -0500
Date: Mon, 24 Feb 2014 23:00:53 -0600
From: Felipe Balbi <balbi@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: Felipe Balbi <balbi@ti.com>, Andy Gross <agross@codeaurora.org>,
        <devicetree@vger.kernel.org>, Vinod Koul <vinod.koul@intel.com>,
        <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Patch v7 2/2] dmaengine: add Qualcomm BAM dma driver
Message-ID: <20140225050053.GA15411@saruman.home>
Reply-To: <balbi@ti.com>
References: <1393283500-18599-1-git-send-email-agross@codeaurora.org>
 <1393283500-18599-3-git-send-email-agross@codeaurora.org>
 <20140225000913.GA10801@saruman.home>
 <20140225030459.GN25940@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <20140225030459.GN25940@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 25, 2014 at 12:05:00PM +0900, Mark Brown wrote:
> On Mon, Feb 24, 2014 at 06:09:13PM -0600, Felipe Balbi wrote:
>=20
> > > +	depends on ARCH_QCOM || (COMPILE_TEST && OF && ARM)
>=20
> > do you really want to make it depend on ARM even when COMPILE_TEST=3Dy ?
>=20
> writel_relaxed() is unfortunately not generally available so it'd fail
> to build on platforms like x86.

bummer

--=20
balbi

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTDCOFAAoJEIaOsuA1yqRErRYP/j3hbkX09e6dLlK2Gw08v8Fg
I0NdDr+beRSC40bauUAYH9EEOQ9vMDXMpM6rZm0ZWTcG/gpaQFbKPN3R53Q/ptFC
BLZ6DH1t92jqkFuue24l4LRRAC/NGzr9CsXBcIdYYV48pnSQiS5RUC6Ke8M+loB0
O1cxa+Mi4YxO8XZB+lnngKCcxr9cLhl1ovH2ji1N6klLbIl36WGM4w5l9pGeuGOf
uyK0BHkQ8M50sKfeOwgSzPK9Zf51VPNW3eB9/xeb//P4dsQW56YwoHCuFr2C99tX
k+Tf7FIwGr3DUNOz5JmorW3Uft4nmJrwes1bf6COYVuovyZb4IiQpzppquWra6yS
1NAqg9FxyK/8WbqcJiNmcXq6TkEpBwvmchEeZvtTskPxnssdbrscPuQLGraE64A+
jk5il4cU+RNZgZ8ecaweVkGVZbopWK7uKPvCzhXBlf13Kbcp+iI/Az619EDudMlo
idmHFtDV1ITgexPUjFgIHALhkdzKhijBXeVEJWQao+bGOSs8exNq24ksAIemZpDF
bhk1WBqHPMHvVFWBZXLSFQ1sJJskW6LDYMKjDM7+DbqSpIx1iOi57ZygUhfSspj0
fITJe5WFOWyZ4YmfxU9KtGWgMPx3PGen/iaZm+Eze+mwQfBW/e+Zo7LeBAmHVdLA
WIpHemjcMgw3yYKVDKUU
=G9vX
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
