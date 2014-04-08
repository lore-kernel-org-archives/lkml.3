Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbaDHIaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 04:30:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51573 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755407AbaDHIaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 04:30:05 -0400
Date: Tue, 8 Apr 2014 10:28:17 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, andriy.shevchenko@intel.com
Subject: Re: [PATCH v5 0/7] Add support for the Allwinner A31 DMA Controller
Message-ID: <20140408082817.GA28585@lukather>
References: <1394723659-4995-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <1394723659-4995-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Dan, Vinod,

On Thu, Mar 13, 2014 at 04:14:12PM +0100, Maxime Ripard wrote:
> Hi,
>=20
> This patchset adds support for the DMA controller found in the
> Allwinner A31 and A23 SoCs.
>=20
> This has been tested using the newly introduced SPI driver on an A31
> EVK. Support for DMA-driven SPI transfers will be the subject of
> another patch serie.
>=20
> Thanks,
> Maxime

I first sent this patch set a month and a half ago, and since then
never had *any* comment from you. It seems like it has reached the
point where people start to be happy about it, how can we move
forward?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTQ7MhAAoJEBx+YmzsjxAg03AP+QFuLGoYHoJ1yNKIXKRFZPFw
GjaKDiwc8ofla+PPublNCt7WnmVD+wsT4qVZBJb08LRKNK0vpP4aTU8Kgd0z9wMg
MFBPWxhbf1QJksu8Mmb7IHnOFblarhJ5YHcHbBKCZo3ZTj1wHV7voqWtvcarf5ZR
X+Nz32SPSutpQAlXTyEjQKbBMVcd8aYFoM+Qy+LBc5hY1SgwKflLxLXPYIfTSkL7
eNrMGviYdyalCkl/X8Hqpk8M++AbIfpD9TTT+JpPTTIiGqtYAjn3vS9nUPwY/MA7
HeVHCtjiMhdMFH0HR1PJnySq7bvpJLpKRoOOH7BxmYP3XcsZHhRHe/Q+AXv/0adC
sPDDAw+gPjI5OvLiJPSuQWu3GavlCmn2/DleW21j3bHcksiIL0iiuClICEKKdfZD
GiEm8E+dn129IE3SdQpv8oYgwfCd8ltPqNOxvLnLGspJqxQX1E5s/oc9HeWOwlEf
VbeQ+pDi/bEjfbPZRAchxVIKmZ15b9cxCjcMSJ19xzv2G+xhXCzUFJHr/Omx578A
/xqooXLmhP6/QQasghcf/aI5Y1gpqJr3ONQXbvMmFCORxaVrTjvSY/deF3a1gzj4
YnVdPT8YUv6MlZY26tntafQNXoms67HD7YRSfi9vu1edt4o/7uuDraXLKW+Q/PS2
PWb2yLusfR1PeK37FFvn
=+Aqp
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
