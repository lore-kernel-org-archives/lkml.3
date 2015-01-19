Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbbASOtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:49:35 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36432 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbbASOtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:49:33 -0500
Date: Mon, 19 Jan 2015 08:48:28 -0600
From: Felipe Balbi <balbi@ti.com>
To: Sneeker Yeh <sneeker.yeh@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>, Huang Rui <ray.huang@amd.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Andy Green <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
Subject: Re: [PATCH v2 1/5] usb: dwc3: add Fujitsu Specific Glue layer
Message-ID: <20150119144828.GE20386@saruman>
Reply-To: <balbi@ti.com>
References: <1421654209-6486-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
 <1421654209-6486-2-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BZaMRJmqxGScZ8Mx"
Content-Disposition: inline
In-Reply-To: <1421654209-6486-2-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--BZaMRJmqxGScZ8Mx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 19, 2015 at 03:56:45PM +0800, Sneeker Yeh wrote:
> This patch adds support for Synopsis DesignWare USB3 IP Core found
> on Fujitsu Socs.
>=20
> Signed-off-by: Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>

if this is moved after patch 3, you don't need to patch it again to add
the quirk ;-)

--=20
balbi

--BZaMRJmqxGScZ8Mx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUvRk8AAoJEIaOsuA1yqREvMcQAKU0ZjgqEA7hIh9IU2MnVi2H
yv6qyMTdcnI+hD4LQIZJirsLwWeoRw/8nHDLvi2w5D3zhSVp5uh5TmbRjh0d0X3x
XIb5vNooZm0QezHnINTwfWV3bD20GP3czdEwntu8ymFXo87U0/7+1D2TunpfP1Qm
qrmVlXXXHE3baF2Xnveadbfzja1oB7RUDXhTaImK4oIqqO03YRIp+iaJrloLwcSy
aaLddlfNfpupD3yHfasSCtR5X+ktAoOGxzqRTS3J5tZ/aky2/ATqSD4/SDJP6S/R
9Nudb67FkKEI6I2bWi4B4Bm+dufLgnkdZb9+t7QixIo0yxabBm3d/KLcurtijURF
0+CNck4fLwxN/0nAGKppOyBRTkV1wyLr5WhgEgUqimtFjwbM0Pmu0oXcdq72i4IW
79ZKfc5qOUw+ICGSETjOe3GeQTYcCqnjkrspWCmN+pvoc0sxCBzb/CvOw9ARZUE4
29oErmaSAROE6ONMLr1cDDOiW89WaXkYkXpm1FrVwPDHzPAj+25B3ykggjIXGjTJ
fvzqddD6wGwlHzezbCnZDxv/GpeF4Kc1RGyJ4+9fiVC4QRL56kQRLeohCcH/605r
LGszV8JYURl5RS9SSYb060Z1bB+cqPUDrSMJH0i9XTriCpbJdTbnadganeL11fHa
43nqUD17w6iFpzHOdfTb
=v5/u
-----END PGP SIGNATURE-----

--BZaMRJmqxGScZ8Mx--
