Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab3GXMjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 08:39:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41938 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab3GXMjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 08:39:15 -0400
Date: Wed, 24 Jul 2013 15:39:12 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v2 3/7] usb: phy: msm: Move regulator usage to managed
 resource allocation
Message-ID: <20130724123912.GI17962@radagast>
Reply-To: <balbi@ti.com>
References: <1373384833-18077-1-git-send-email-iivanov@mm-sol.com>
 <1373384833-18077-4-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Re2uCLPLNzqOLVJA"
Content-Disposition: inline
In-Reply-To: <1373384833-18077-4-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Re2uCLPLNzqOLVJA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 09, 2013 at 06:47:09PM +0300, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>=20
> This patch move global regulators variables to driver state
> structire and move allocation of the regulators to be devm managed.

split into two patches please. One for moving the global regulators into
your structure and a separate patch to move to devm_*

--=20
balbi

--Re2uCLPLNzqOLVJA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR78rvAAoJEIaOsuA1yqRESlMP/3C9NBp4z7O5LfTT+E7eFY3T
RUXCycYrpBKO+PhClrooj0q0ueskJBg//Lv0SX3XVhj7U/2LKExgm2hZzSDF2MHd
W0WTw3kwwJhL9KSiJEPe2YfhXesfFJN5ZBEo9i/0gS+eDwNYWTfyZ0zhQr9bCbap
MWroaRoR2+b5uhAGRULVnTQqXFadroYU7bSAFjuWlolF7ugbaFkxDrUa4JgwkNNc
GxExKOQizExmBzlKta9uCVshaoFJIkQOQ9eeMvYiR8RHpdj++bkNziTZfilkLHgJ
GiuzKvkjKh6yJdWTGZs3bPRdFiTLTT6vytI0fZEZyFK/EQEDShz9KWV7rUrc3mCD
ox2Gk6/JVnBwB5jiVVHQTNF0GWtvDbldArjX1exxN16gwc+YluytKpSNYKkoRUzV
/F/Uo+FGhQGwzS3cuDfsoyfURd6VZLJHEWScw5f2b/59feDo+V7MnPhV/SBsL+zl
gUAjom3V0qwTz2BwCbgmlPf6aSunGUaJh1TEeOjoBrKtUBn/pRx5PXO4jwEL3aXv
1jfAUHtYQqnNzyFVmjXNmV+Y1js/9ohZV7rqngQfw6jMMr6aNErPjMgk+Oy+M6mm
H5LQunJAV9KZV5CmDNbAQp8YPlMpznEZ+HqUsNmJgiyfpQHTgFX4xaKKvElYD6EG
RqgKDltiHHdTCtRXxPW/
=osPg
-----END PGP SIGNATURE-----

--Re2uCLPLNzqOLVJA--
