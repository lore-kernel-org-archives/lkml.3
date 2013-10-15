Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854Ab3JOLzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 07:55:08 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48462 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506Ab3JOLzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 07:55:05 -0400
Date: Tue, 15 Oct 2013 06:54:54 -0500
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <tony@atomide.com>, <balbi@ti.com>, <kishon@ti.com>, <rob@landley.net>,
        <ijc+devicetree@hellion.org.uk>, <swarren@wwwdotorg.org>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 2/2] phy: omap-usb2: Adapt phy-omap-usb2 for AM437x
Message-ID: <20131015115454.GC11380@radagast>
Reply-To: <balbi@ti.com>
References: <1381833463-12149-1-git-send-email-george.cherian@ti.com>
 <1381833463-12149-3-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KDt/GgjP6HVcx58l"
Content-Disposition: inline
In-Reply-To: <1381833463-12149-3-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--KDt/GgjP6HVcx58l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 15, 2013 at 04:07:43PM +0530, George Cherian wrote:
> This patch adds a compatible for AM437x "ti,am43xx-usb2" to
> reuse the same phy-omap-usb2 driver.
>=20
> Also updated the documentation to add the new compatible.
>=20
> Signed-off-by: George Cherian <george.cherian@ti.com>

I commented on oldler series, sorry. Same comments are still valid
though.

--=20
balbi

--KDt/GgjP6HVcx58l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSXS0NAAoJEIaOsuA1yqREFF8P/1ethL17+sRiRjHyf84IMVDf
r5lS2WUG3pumYR41jTtczbypN8S6HpR9akyXuYjMNjOJAh0+ONBBf6jJY1FLk21K
Pv2QscDP8+H56A7WyjxVo+PFsEeQAPQlcxmOi07G8zS4b9zmZ/OKpYGIg2UEvuM6
tqll6urWtv1SMXYUHX1K3iI2d77NW4F3qIEPtYVmADBPXFGJevq/XvXXAKBe7UVu
K2nnwZrVwsM9gE/35R2NrfauMKEL/hp/dhOAX1IBUxcNDwaITFf5tsEJ6mHJWL5H
6050y3AKgVbU4FZx9oXJF5ZV68y2KCjDTqql9optRlFju3ruAzyH8iyVOIMBLNs2
l2jfWXmDWwnOOziKurLP3IG07htm5hpoaY4T1yxBNdfWXWc33UGtbU2R1yX/phRZ
iJMQuxwaCIb7xtydWI7B3RgiAECb5RZ1Bh/sIq5cPXQuzXTNmL8YdOH3wLGBuqnf
Q4X3MhhklqiSgaem+GLNe346Wvj1t0BIor/LgOU5rWkQP/zpY68Z96kdSLKWR56g
CWWt2iqj4DLDo4qslx0kZEhCc/c6N2+D+axMtRNO0KgD5s90HmysjMzlXEGHr0NW
udVaCL7Dsdus8807iCQLQOftmjEA24BlnfyUjHG85Ut5kl19wxcOLTlGhIMlIgkm
kMsXRdYmOs1Q7h5RI+V+
=FBM2
-----END PGP SIGNATURE-----

--KDt/GgjP6HVcx58l--
