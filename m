Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaHSOOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 10:14:30 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51955 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbaHSOO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 10:14:28 -0400
Date: Tue, 19 Aug 2014 09:14:23 -0500
From: Felipe Balbi <balbi@ti.com>
To: "Chen, Alvin" <alvin.chen@intel.com>
CC: Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Boon Leong Ong <boon.leong.ong@intel.com>
Subject: Re: [PATCH] USB: pch_udc: Add support for Intel Quark X1000 USB
 gadget device
Message-ID: <20140819141423.GB16085@saruman.home>
Reply-To: <balbi@ti.com>
References: <1407175207-23260-1-git-send-email-alvin.chen@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H+4ONPRPur6+Ovig"
Content-Disposition: inline
In-Reply-To: <1407175207-23260-1-git-send-email-alvin.chen@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--H+4ONPRPur6+Ovig
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 04, 2014 at 11:00:07AM -0700, Chen, Alvin wrote:
> From: "Alvin (Weike) Chen" <alvin.chen@intel.com>
>=20
> Hi,
> Intel Quark X1000 consists of one USB gadget device which can be PCI enum=
erated.=20
> pch_udc layer doesn't support it. Thus, we add support for Intel Quark X1=
000 USB
> gadget device as well.

where is the patch ?

--=20
balbi

--H+4ONPRPur6+Ovig
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT81u/AAoJEIaOsuA1yqREXOAP/30K7xi7fsyBtUgBWbQqImJQ
KzfIf7DJCMrRHa/bEeV9z+engz2ig7PY0vkhoHHrOaaIpywDHik75ysHmI4HxJPs
TP5UohjRfr1rukBSJyfjrp0QlDOZvoA6mBjlds5e7vXk5/miLlOeVHnaUwmSq/DU
5zoQT7iwUkfNLKJtxCs3ZOULXNbzzTerBzDydkfcXMeIeLIQEdSB/jJMSm3SMn7V
uwCvOMWK7IeruoZCILHM/bcinUhkSlOjiojnLvP+Sm31pTBrGkzM+QAsgMxSAnOl
0wNRMq+x63d9GaT240Bwgz1opGxmtWuueKLqfwhjtysZpj8oAKHaPkTBTXabTWEy
xwI79OuGXuDr3FIAM4Ow6qVb3glL+T+45gIyRv57DT45V9KUV57mcGkSKzOBHvG8
3Ni120fC88M+ZuVoWGKp4MRAByoh0L6MGpzRqfiMetVX6QPYrlNjAZHOKs2zOLUz
LuTKe5YAmbqw1cox95akOLHtHnlDmI1HP26yEH2ty/f/Hoe7Q08K2iKJ5dhdAKEo
KV8ARCVghDY9P480eIf2waDLC0n5SPx4Es4T+XWCurtcmNaRdaQQ1fcbh5MigFQ8
tuwyKIcG486zv5Vv0BEwfX+xCOJinQr4MurPIEVTDoajHu00XnvwiedaG3nIpO0d
/IF4nswzX10w+8cX8IKL
=j01f
-----END PGP SIGNATURE-----

--H+4ONPRPur6+Ovig--
