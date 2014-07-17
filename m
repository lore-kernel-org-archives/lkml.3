Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265AbaGQNuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:50:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43673 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932219AbaGQNuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:50:04 -0400
Date: Thu, 17 Jul 2014 15:45:52 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/14] AT91: PIT: Cleanups and move to
 drivers/clocksource
Message-ID: <20140717134552.GE20328@lukather>
References: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140710075105.GA27469@lukather>
 <20140717095020.GB20328@lukather>
 <53C7A61C.7030704@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0H629O+sVkh21xTi"
Content-Disposition: inline
In-Reply-To: <53C7A61C.7030704@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0H629O+sVkh21xTi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 17, 2014 at 12:31:56PM +0200, Daniel Lezcano wrote:
> On 07/17/2014 11:50 AM, Maxime Ripard wrote:
> >On Thu, Jul 10, 2014 at 09:51:05AM +0200, Maxime Ripard wrote:
> >>Hi Daniel,
> >>
> >>On Tue, Jul 01, 2014 at 11:33:13AM +0200, Maxime Ripard wrote:
> >>>Hi everyone,
> >>>
> >>>This series cleans up the PIT driver in order for it to not depend on
> >>>anything in mach-at91 anymore, and in the end move it out of
> >>>mach-at91.
> >>>
> >>>Along the way, these patches also do a bit of cleanup.
> >>>
> >>>This has been tested on a G45-EK without DT and an Xplained with DT.
> >>>
> >>
> >>Even though most of this patches are not clocksource related, it would
> >>be great if we could at least get an acked-by on the last patch that
> >>moves the driver to drivers/clocksource, since it pretty much becomes
> >>your burden :)
> >
> >Ping?
>=20
> Hi,
>=20
> I am in vacation right now. I will review the patches in the next two day=
s.

Oh sorry then, enjoy your vacations :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--0H629O+sVkh21xTi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTx9OQAAoJEBx+YmzsjxAg1m8P/0phcNbWmnGBHC7RtoGV/X4t
Rx2d/VkjFefW4nig4+ZMm/TyKy9SnZD30qcDmbXl1BLUSDgjxs4xfA/OGY2pE/Za
8WT29REUEIGjfoJPa9pXTdw1rc+I1cPKvHrawiXTE7ITjbQy/P4+t2PUGgRF7c2I
OVd5UkBT49Q1Ujsxxi8rgTNDa6bqrmo0XSEexHjheVHenl7Vfi5kHOkHgWC9eISc
UDwq7mpnhhaGuGSfCbXLUqjs0L/NO8s5Z3/hCuUn0wZm1SL/rFFlJodhVAj/yVSN
YellZAKC2Z+6viuQJt1MfA8h55jSiFQAWSEXN+fvA8QpWEX7nEaqVz2ZCwszZTPF
KsEMESf4aIUuihZrY4XLW8+Cyr9PyLJfrSRmQC/PCZ8+NkOZywmVil/r0lXGbnRW
Y7z0pKZr+xVzb/8y0pxfjJrAdodFQf/tmyeduY3df4W9BfKCq0P2H5pJGLkPw/do
8Wx0xTRDuzBRdIzK3uYoBdOgq+eOzERu3VqZ3sO96WLCbeYPBTt5n/ZNEx4WBS3S
8OqDiMGseEiEfl53VXdQj3aJWKtpPTesH8lgndt7ME93Sgp04zrB1kpltS6qy2A6
qL6AMfR/rF/sCDRxAJTRz7r9MsIJuKptUh25DJingz4ntIyVUc7ctSc1Gu+vuNgt
jsy6IcjoRqi8rvzptdkF
=t4Gn
-----END PGP SIGNATURE-----

--0H629O+sVkh21xTi--
