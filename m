Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696AbaDVPAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:00:30 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57794 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756668AbaDVPAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:00:21 -0400
Date: Tue, 22 Apr 2014 09:57:45 -0500
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v6 03/19] usb: phy: msm: Move global regulators variables
 to driver state
Message-ID: <20140422145745.GJ5524@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
 <1398158438-21579-4-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HTLCc13+3hfAZ6SL"
Content-Disposition: inline
In-Reply-To: <1398158438-21579-4-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HTLCc13+3hfAZ6SL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2014 at 12:20:22PM +0300, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

#define ENOLOG		ENOCOMMIT

return -ENOLOG;

--=20
balbi

--HTLCc13+3hfAZ6SL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTVoNpAAoJEIaOsuA1yqREov4P/1VciJBCzc6wK9culOhN5gDs
4qroDXMwvAxO8JbhPpoozdicLJBT+nWB49kJhWE+v4t5LKAeKg8C3DzoSgQG81hG
TaaCN04NKbEbeTTD0TDWm3MkpwF+QBLd89/g2DPaxxcn/Nb6RBK4u1/Gvu959deK
u6cnewtJlqowbc1oWNdlEcG19Uzn1oQOMMF3g09mHuqe6JHlM1IbFcbKOy3aKn1R
FOQiLsYmkCNpXDTYJh46iSd5ApTz9fKqsMGV0Bg/YEvIjT+8G+hWzyBnDFWWovDt
oWxrI4Bvxp9IyxbQTezIHsbjgox8Y+kZ256VVmcZMgNdqz1NMXMr0LQDgB54dp0a
Y5rgaf172sRtwfr/kXYCl0/r+H/xPsCanWDs8NIqPsloGtDgnrZLxcyL8uVdjVL1
FU1cMyeWUxHeS0JvItRapFSu7XIu518lXeqXJDaicKlQtwBMW4Kjq7C5HUBBU0Yl
aE7IxJWQ73zUIjfhtElPIi7qGAEw19VhSd1nlI8t+SnHC02Sg88A7fKInTUONGCU
+fgt6stnlBFqtdiATQWIjc/z/ZVWyVOxipu7buW2/JU88qH01ySadH2iIJTr9dcu
7o5qzSevegwDW8hyhroPmGy+GEq0xC7estfAPP3mjaMCEQB0jExQLSaZ9nLpNteA
HuSOa3VdP1d2HJAXhyNP
=kpbd
-----END PGP SIGNATURE-----

--HTLCc13+3hfAZ6SL--
