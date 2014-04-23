Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbaDWNQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:16:27 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57470 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755574AbaDWNPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:15:06 -0400
Date: Wed, 23 Apr 2014 15:11:42 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, devicetree@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>, andriy.shevchenko@intel.com,
        linux-kernel@vger.kernel.org, zhuzhenhua@allwinnertech.com,
        shuge@allwinnertech.com, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH v6 6/8] ARM: sun6i: Sort the NMI node by physical address
Message-ID: <20140423131142.GR24905@lukather>
References: <1397724379-15398-1-git-send-email-maxime.ripard@free-electrons.com>
 <1397724379-15398-7-git-send-email-maxime.ripard@free-electrons.com>
 <201404231439.26549.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DzFMwNuU1QL7hgxO"
Content-Disposition: inline
In-Reply-To: <201404231439.26549.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DzFMwNuU1QL7hgxO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 23, 2014 at 02:39:26PM +0200, Arnd Bergmann wrote:
> On Thursday 17 April 2014, Maxime Ripard wrote:
> > The DT are supposed to be ordered by physical address. Move the NMI nod=
e where
> > it belongs.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>=20
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Thanks!

Just applied.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--DzFMwNuU1QL7hgxO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTV7wOAAoJEBx+YmzsjxAgnIwP/RoS5ePrSE58YIbkgXI9bw/a
XOVHEk5vul8XGhOAUp3FL1O2Ux19wk+VGmUzXOH426tXJn7FBmrJiKZuBt7ulAwh
j7kUKtHRV6zvkHcNnRStruCY8zSTxHo7DfgPGWCDJ7B6jUOQHk27ftOOWDZYGoLZ
MQmEukdSVvSIgNpZ09zpHrUwrvDFYPnLak1eKBV1sHb8o3BGk2aexRDNZZ/OU4ut
3+346wgHBp5In1q1HrrNAn+gtXHDTWyWgzf5PXdCnqMJFLzVfG/xAAk6Ktoco1SJ
81m9sot+r67bHSc4edHhMp2CjPz0XVbWE/O2lifcBIOCGOhYasPCaBrlrIg1Qmim
1O0plBUJKsZ/41tDH/LuK+fbyYLY7LBes7dUojCl0r/X8s+gHEE8WEdda+C1jPez
QH15fBbALtrr5gtHDzW62hlOzBiwpgE1DZ8wvcpsI5QKm1dCCj0ajF6Nowx9bUis
PcJDjiKDT4r5GShTtRQesQde5sze7tkoDYmL/dYr9qq3Gu7x+VMVR8UH9C0rPm+Q
k+XBg/oKCdEvGOSqLOrYpIUaUuoiJ9mrKzuoFnQrLEXBV5/nIaCUu0F9y7D2ls07
Zw17eslEBJt0Xk1YnS6BHUX4d4Pn/9sxH56rYh9Hg7jasOnWkecvXJe8/IB1eTuS
n7dprVEfVDhtTonxqQz8
=lqrT
-----END PGP SIGNATURE-----

--DzFMwNuU1QL7hgxO--
