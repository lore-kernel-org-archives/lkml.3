Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab3EGKpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 06:45:46 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44095 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485Ab3EGKpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 06:45:44 -0400
Date: Tue, 7 May 2013 11:45:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: gg@slimlogic.co.uk, myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        balbi@ti.com, ldewangan@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net, ruchika@ti.com,
        tony@atomide.com, sameo@linux.intel.com
Message-ID: <20130507104502.GQ7478@sirena.org.uk>
References: <1362662506-14823-4-git-send-email-kishon@ti.com>
 <1367846225-15685-1-git-send-email-kishon@ti.com>
 <20130506144010.GF13472@opensource.wolfsonmicro.com>
 <51888D55.3090907@ti.com>
 <20130507075824.GM7478@sirena.org.uk>
 <5188CD9C.6010602@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V2tfspbppmK1TQo2"
Content-Disposition: inline
In-Reply-To: <5188CD9C.6010602@ti.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4] extcon: Palmas Extcon Driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V2tfspbppmK1TQo2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 07, 2013 at 03:17:08PM +0530, Kishon Vijay Abraham I wrote:
> On Tuesday 07 May 2013 01:28 PM, Mark Brown wrote:

> >>The platform can provide it's own vbus control in which case this is
> >>not needed.

> >So why is there no interaction with this external VBUS control and how
> >does the driver distinguish between that and an error getting the
> >regulator?

> The platform specifies if it provides its own VBUS control by the dt
> property ti,no_control_vbus. So the driver will give an error only
> when *ti,no_control_vbus* is not set. Graeme?

That doesn't answer the question about why there's no interaction with
the external control...

--V2tfspbppmK1TQo2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRiNsrAAoJELSic+t+oim9qssP/3toUma31SzGARXn8T40l8xy
sKVqci35ErrhapClrJUupVjmd7fOGaTrY86AF+ZHisKjwFc6HYjvGF4BfqAxjVtv
/u12U7xN6e16lsj3coH8l3BdYo1LLDHaixZMlRAZ9+Z2i5CGShij5KzfDjA2nVGe
De1s96eTnbi8yV9eceFpcSqsHhlxEOUugmlgbv3ZMCczOfVIdVBMxz5y89J2Jdjf
D4ePYT7KsH/uJpx6BwWjnja2j2fu0gyyqWte2niWf+lfhXCwNf9n8Ed9RCQcED8e
1+6D1UL/dHFruc+LGlHwQrHzxRlmNha5Ug22DEmCTFHIvJ0W3oqA5GpaCgccNfWL
xE3ELvcZzqSvQKOnuAynRO5MFb5KvbwSVOBQPnMBpcQrTFIr4gqxaL7/bTmy2P7Z
P07G35MpGooqp3fdJXFcpG9BEKEwXnGdJstC5NeWIyLR5+mcBBCONcz6lqQktlel
9OFc4gv/rivjr1rJxuOWXZqmELJ38SjNAjWQLVq2RzfZsIDcL+ic5HYtvseThOoL
LN3kOBIH6MnQUqr6UWWoyDRvfP4ew6xFUbMTtA0Zdg3dB4b2DzLxsgJWWebJifeq
Vm3rJTu9aZL+1Nyyg+fv2RGGv5vmYRI5repayHIYW0f69r15yfu0UxeuxekjkI/7
iOboRMf+NLENGsHkzQme
=jwqy
-----END PGP SIGNATURE-----

--V2tfspbppmK1TQo2--
