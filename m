Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab3CNN6D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 09:58:03 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36456 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755882Ab3CNN6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 09:58:00 -0400
Date: Thu, 14 Mar 2013 15:57:42 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <s-guiriec@ti.com>,
        <gg@slimlogic.co.uk>, <sameo@linux.intel.com>,
        <broonie@opensource.wolfsonmicro.com>, <ldewangan@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <ruchika@ti.com>
Subject: Re: [PATCH v2 4/4] usb: musb: omap2430: replace *_* with *-* in
 property names
Message-ID: <20130314135742.GF26080@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1362662506-14823-1-git-send-email-kishon@ti.com>
 <1362662506-14823-5-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4VrXvz3cwkc87Wze"
Content-Disposition: inline
In-Reply-To: <1362662506-14823-5-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--4VrXvz3cwkc87Wze
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 07, 2013 at 06:51:46PM +0530, Kishon Vijay Abraham I wrote:
> No functional change. Replace *_* with *-* in property names of otg to
> follow the general convention.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

this has been pending for quite a while, since nobody complained, I'm
taking it for v3.10.

--=20
balbi

--4VrXvz3cwkc87Wze
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRQddWAAoJEIaOsuA1yqREUx4P/jiUDagiitaJugX66ZENCc/6
MFRz3US0AGr4hzlIwPnxqET3+a90K5c1vZhBODnKHKVEs7qzt4acirzDgxEAwQl6
ER1UievNA6Rc+63GUQb0Mt7DUE0dfcGQcPA4ryM6MNUoSqLKS54Knev66bt2meIH
lcQP1TTB+bgPn7PmBhqSMGiScQiVT0TzTIH3o72imNZQ2CmmIa8brjXtG+VEjE53
7WWhImoWmsm1ye2uKhFm6V05yyzQIYjgD3wz/NeDJN6BkxaoBYr6KABku76T+4G7
BoLgmSPvCQHe4L+V3G8BgbkuJ3ZLkP+htCQSnowO+jMl1XwmlYSR1VhTUjpNZqgE
XG1Kf9SOb/13v1yo+3e/Rt7n1JBk5Gce8qyIuTYL8FYX8IXLat0OA8KeFNZntAPJ
2693mLjNK6a1iRhyiZivtNu6ZntzgySbvWlKv+BIazY8BwMmdW6CVKeZu0AiLZfd
WqMd9QeKldJTQQtCu3h/9NFfgprt/jzivIB37bHxkVmEBQE6YMYD9HQkAzhjjRsJ
FQHX1I+gmjjuRzc/DsOpTZN5ssbxx9QkaDVh5RUWx+XDCRQT03T1DUDOvxoV5s9b
hxMLdSQPDSSIrsNr8JTrPpp0N0EAAB6mOJe4ZUla1sqA4RMDDpZhmZGgL60i8749
eJ2fSjdNZCrAJp23p+D6
=rpAI
-----END PGP SIGNATURE-----

--4VrXvz3cwkc87Wze--
