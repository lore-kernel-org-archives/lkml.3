Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759671Ab3GZU2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:28:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40342 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290Ab3GZU22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:28:28 -0400
Date: Fri, 26 Jul 2013 23:28:20 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v2 3/7] usb: phy: msm: Move regulator usage to managed
 resource allocation
Message-ID: <20130726202820.GA14077@radagast>
Reply-To: <balbi@ti.com>
References: <1373384833-18077-1-git-send-email-iivanov@mm-sol.com>
 <1373384833-18077-4-git-send-email-iivanov@mm-sol.com>
 <20130724123912.GI17962@radagast>
 <1374759788.1956.31.camel@iivanov-dev.int.mm-sol.com>
 <1374841894.1956.42.camel@iivanov-dev.int.mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <1374841894.1956.42.camel@iivanov-dev.int.mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 26, 2013 at 03:31:34PM +0300, Ivan T. Ivanov wrote:
>=20
> Hi Felipe,=20
>=20
> On Thu, 2013-07-25 at 16:43 +0300, Ivan T. Ivanov wrote:
> > On Wed, 2013-07-24 at 15:39 +0300, Felipe Balbi wrote:
> > > On Tue, Jul 09, 2013 at 06:47:09PM +0300, Ivan T. Ivanov wrote:
> > > > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > > >=20
> > > > This patch move global regulators variables to driver state
> > > > structire and move allocation of the regulators to be devm managed.
> > >=20
> > > split into two patches please. One for moving the global regulators i=
nto
> > > your structure and a separate patch to move to devm_*
> > >=20
>=20
> Would you accept patch which convert all resources allocation to devm_
> variants in single patch or you prefer separate patches for memory,=20
> clocks, regulators and irq?

devm_* all over the place should be fine ;-)

--=20
balbi

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR8tvkAAoJEIaOsuA1yqRES48QAIbnFYowgOb4IJJN8NwCD6EU
XOUlDNh8P/36u34TPdAy+O8W3aliIdTvgRyVwECYtpLPeown6WNs9Nl1yQYv+X8n
TsZwlMVPOEZXqq+yaMtDmhNUXx60Ml+yGqz6ptqO7G7aokFuI2qnIJZoOBCIzxp6
mNI4WaFDP5nm6LrnbfRuN2CpEJooLzx6ZSO9vf209zZkXSsjS4IfoyJyHJAwdenA
IDa+8xcvH1SY02Aw10vPLHULtNTNue93b7Yt38R9VZ9p+lGrK4CzoKyAVrtzI+MG
rVs2wnG9m6oDNbNNgQxkLpL9QScAP4xh8Q1omqXWYg1vmk2QNfMaoMuS43dPJCcN
nv7Z/gtFeQgHF9t7dKvNZ9GD7sdis9BTYeoTH02C8S0dtE6HOPm/Y1PrFhtjozy1
MI1nVVlPbCAglfAJt5+FIjTUtHe6g7JPoEi/CTukkzuDmKLPnY+jeWB7nCgWcLyA
79CfApt/nQkPtpi5Vq0+vOWso3NAP6eRFzwRSvXy0+nNtvRwhC8Dq5UUhm0GE91a
ou00ga1NiaBoAZVH8DfP0g3oBRkZMdZGZbWSAJeHxMHLB/7cPZl6FSi1046cVjCi
3UnRtVbmw3njFJaQU+71i45xuedu5Rl/TbwOEXZudcvu9herCga0vOj8zj3JsFQa
y8j/U/aUow9YtpEC4zy/
=edVJ
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
