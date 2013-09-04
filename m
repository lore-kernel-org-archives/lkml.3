Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab3IDSDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:03:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53116 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab3IDSDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:03:46 -0400
Date: Wed, 4 Sep 2013 19:03:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>, gg@slimlogic.co.uk,
        Sascha Hauer <s.hauer@pengutronix.de>, marek.vasut@gmail.com,
        Nancy.Chen@freescale.com
Message-ID: <20130904180319.GW3084@sirena.org.uk>
References: <1378276263-10735-1-git-send-email-sachin.kamat@linaro.org>
 <1378276263-10735-7-git-send-email-sachin.kamat@linaro.org>
 <5227355C.1020205@ti.com>
 <CAK9yfHxyyZ8WGL8Q4cJ7Y=LcJ2dkeZamXydnMYS4uOj-cmU_Dg@mail.gmail.com>
 <522760C9.8040201@ti.com>
 <CAK9yfHzq5isoj0bv405DNF_E=u0nKBBVscbcuoHT-8PxVaserA@mail.gmail.com>
 <5227674A.9020005@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HBXo5IaYAxUG7vuS"
Content-Disposition: inline
In-Reply-To: <5227674A.9020005@ti.com>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 7/7] regulator: ti-abb: Use devm_regulator_register
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HBXo5IaYAxUG7vuS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 04, 2013 at 12:00:58PM -0500, Nishanth Menon wrote:

> > As I mentioned earlier generally when you do these kind of
> > conversions, most of the trivial
> > clean-ups are also done along with it. Probably you would have
> > appreciated a mention about
> > this in the commit log too.

> yes, adding to commit log might have helped me. thanks for the cleanup
> as well.

Indeed, that is good practice - either submit the changes separately or
mention all of them in the changelog.

--HBXo5IaYAxUG7vuS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSJ3XkAAoJELSic+t+oim9xyUP/3w+HNb758/C0A2ihDMaz7Eb
HSKTbt0EGwoULbJ7Y7hj4XKceeDm7T4v4RxodGVYzhiAc335Q5Ld2e+eALVTpjl9
d7I97j2nR05bNDFWi/M4JE5n9KM4ZCtmC51jcNf4pI8Qn8tjLIKMHkfIYtEFTopd
SYNH3/XDUzsFv7+gv+TKVr3DGcNgHB1/dmLzXF+Y9r0M1o85TC+BmzA/0iFfrTar
4aw3QB1XyI+5NJMMEcBnRrCGupbvzdta0sdRg+eZdYYdAFPWKnRCY0RN+6kcAlnK
pNXm/K7Mlhhgc9rAg0OwEr7KuiCbwzi0jzs+qY4ZuUT5b3TqAhr7uOBcaSOOVerv
fYilw5rl4N1vm+IPcB5LftClgpUeO2QOk38FnUiiFw7jSCq5yhkNV0dUTtafbuQl
wHCXMBWtWwL+Gnhl/yOUj+d0e1CsVlm5cIjCFLIqjPDxyJP86aVCfV30b7d+fQUH
liSDGcUP8zW5dUJLlZz6p/4ZkSfSmH6amz3ASubDqb6f0PKQ8kmhgTVMoaP3pGVh
7bpP7ZlyR9e+ZBFoJ9FcbxmRZSZ4uydG37y2B1shEhwJMP0BYSFCc9PXy+f+etJO
okEIG/Vsi7VqTgwDcVjKzwrc6SW8gwmm10qzOB/EnX3T9g8dhpooWUyOAKnJ5Fn8
L2EtFvPktRjRZBuGD13N
=w1I0
-----END PGP SIGNATURE-----

--HBXo5IaYAxUG7vuS--
