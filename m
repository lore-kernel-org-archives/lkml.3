Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab3IWTdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 15:33:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46057 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207Ab3IWTdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 15:33:07 -0400
Date: Mon, 23 Sep 2013 14:32:51 -0500
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <balbi@ti.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>,
        <gregkh@linuxfoundation.org>, <grant.likely@linaro.org>,
        <idos@codeaurora.org>, <mgautam@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v5 2/3] usb: phy: Add Qualcomm SS-USB and HS-USB drivers
 for DW PHY's
Message-ID: <20130923193251.GP30811@radagast>
Reply-To: <balbi@ti.com>
References: <1377091786-5613-1-git-send-email-iivanov@mm-sol.com>
 <1377091786-5613-3-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sk71+Upln2BLuDmg"
Content-Disposition: inline
In-Reply-To: <1377091786-5613-3-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sk71+Upln2BLuDmg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Aug 21, 2013 at 04:29:45PM +0300, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>=20
> These drivers handles control and configuration of the HS
> and SS USB PHY transceivers. They are part of the driver
> which manage Synopsys DesignWare USB3 controller stack
> inside Qualcomm SoC's.
>=20
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>

I can take this one if DT folks agree with bindings proposed on previous
patch.

--=20
balbi

--Sk71+Upln2BLuDmg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSQJdjAAoJEIaOsuA1yqREvbAP/0M8TMSx2bqjHn7K/wUowbP6
00piB7uQ8xkarDOba0Xo4Dmb45F6SlXwuQLbsKRHgu16vyWdR9lNwrNiHutj1PqK
VNnBs4UYidpi/DmoAiAztYMzGTvyjr8XjDDuUzQxmRdt6LGpCyIcDeNYLU8tQr+b
ZDohRNmQvImWj8nNIaSk4Je32LcCJ8EQY+rEcAIMukBQMhiz63SQ9AVySInXFQSf
fSakwe3MVDYTG3bzmADbCqGhQmYTb28Jox+uBcL6UsMUZR87RKho9QQKCP2eu8E3
lfgcQmKEqIHUoyFXUjijifPRSY+2+V3+3dcJB3ZoX1yoKTnDv91BCLtJ9zXzx+86
3EG+l/ANNaVsFYuQQpj/aYoDzS8qchz1znhV+HRuomn1Frs0saw4I8SwvUAf+Sp1
kfGO+lo2hhHuR4/cHGc5QJlgMjsvD4HDQgcN1tThikmOnbTma4r3F2L8FCjr6aRt
BHybwhqfl+yJR9fVqKRBYAWMOH1xqE1e+eHn2D3eSl3V6boueo1RUHl3nF9YCL8W
EF17FzND58bm2YCh3Kpn3ZU939zNBetKwLsFapIo6GDYQFSuxlFtWz2w1V5LKtS7
0g3679pGRNWgwMCeE6GTV6/u96zxqlB0q5RrR+3Eb+dgerUXT5mueCP+aJX9O/Dh
lhBDU0eiX8XYvPrneJpS
=pvDZ
-----END PGP SIGNATURE-----

--Sk71+Upln2BLuDmg--
