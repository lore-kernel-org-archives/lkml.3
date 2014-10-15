Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbaJOQ4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 12:56:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52764 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbaJOQ4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 12:56:14 -0400
Date: Wed, 15 Oct 2014 11:55:02 -0500
From: Felipe Balbi <balbi@ti.com>
To: Johan Hovold <johan@kernel.org>
CC: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Andrew Morton <akpm@linux-foundation.org>, Felipe Balbi <balbi@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Colin Foe-Parker <colin.foeparker@logicpd.com>, <nsekhar@ti.com>,
        <t-kristo@ti.com>, <j-keerthy@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/12] rtc: omap: fixes and power-off feature
Message-ID: <20141015165452.GB15770@saruman>
Reply-To: <balbi@ti.com>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/Uq4LBwYP4y1W6pO"
Content-Disposition: inline
In-Reply-To: <1412881594-25678-1-git-send-email-johan@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--/Uq4LBwYP4y1W6pO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 09, 2014 at 09:06:22PM +0200, Johan Hovold wrote:
> This series fixes a few issues with the omap rtc-driver, cleans up a bit
> and finally adds support for the PMIC control feature found in some
> revisions of this RTC IP block.
>=20
> Ultimately, this allows for powering off the Beaglebone and waking it up
> again on RTC alarms.
>=20
> I noticed yesterday that Lokesh Vutla recently posted some patches to
> add regulator support to this driver. [1] While that series has some
> issues that needs to be addressed, I still think it could be a good idea
> to rebase my pmic_power_en patch on top of it as it adds some long
> overdue device abstraction. That would be needed anyway in order to
> support the new power-off infrastructure that's in the pipe in a clean
> way. [2]
>=20
> So my suggestion is to merge the first seven patches, rebase Lokesh
> series on top of that, and then I rebase my final five patches on top
> of that in turn. Hopefully, the new power-off handler call chain will
> have stabilised by then.

BTW, how do you test this series ?

--=20
balbi

--/Uq4LBwYP4y1W6pO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUPqbmAAoJEIaOsuA1yqREmVgQAKjVt1z/XvKk5bIVglQNVmtG
CpBtbKrVwb5I72/ZDpXSgYb8GkW7vULXXZWZeSXz/EEQ9wSL07B8dr+6/mhXgVk8
/nCgUJjMv6FLr82F1XKsVZ8ZfYO9pIk9zc2UQUCtXiqRu+rNueFHAPRAuZ+fYDnO
HXE8D2IOSfQGF2QSAgeYD5LxdFQiLBsHauUl1usavlgyJDD5cPIhxug6IEJSCdfM
BmanVWCS8gl2s3Q5PyTAb7nBlXc6ZXdgqJnpWvqmoMN9HYGLK8RcMspEZD04wcIe
OINRDf825X40TrjkRuvbmqBlV9flHxbjd0LokSpE6Uy0MM3GCdSL8JbvoDbFstzD
rybdJZqLqAmAWvjDtQe1RieIhK78Y698nDIsxIvMZkP/fI1G4oBLnttnZKxISC5G
g3AfM3m0xLC8+xIlZ9/2MkkPKofEz+g+dUI9ik42AS6+H2QxfkKQ5HQn9k5EeuXH
w6VbAs3xMIEq/q3MvnZ1bxk6cNDYfH1jyIzEhCyrH5l1nPco9CCMawUTTa5FqEGc
bnqE8O/BB617AZwDOOkKPS2q5Drey8nzrGeaFkrKwJcnLyxJZJCyLWwqiv0I+Ktn
+1wMWA8MGLX2bHiC2xerUCBU2ON22h4uXdtMaXByiZ6hVp17kt5nh8UOp890b5Y8
MXVuBtgOgDFBZeHVlEtR
=Es/r
-----END PGP SIGNATURE-----

--/Uq4LBwYP4y1W6pO--
