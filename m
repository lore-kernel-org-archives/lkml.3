Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab3JNWx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 18:53:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53073 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757655Ab3JNWxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 18:53:25 -0400
Date: Mon, 14 Oct 2013 17:52:42 -0500
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <balbi@ti.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <rob@landley.net>,
        <davidb@codeaurora.org>, <dwalker@fifo99.com>, <bryanh@codeaurora.org>,
        <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>,
        <grant.likely@linaro.org>, <jackp@codeaurora.org>,
        <mgautam@codeaurora.org>, <dsegal@codeaurora.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 02/13] usb: phy: msm: Move global regulators variables
 to driver state
Message-ID: <20131014225242.GE7446@radagast>
Reply-To: <balbi@ti.com>
References: <1381764280-28420-1-git-send-email-iivanov@mm-sol.com>
 <1381764280-28420-3-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G6nVm6DDWH/FONJq"
Content-Disposition: inline
In-Reply-To: <1381764280-28420-3-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--G6nVm6DDWH/FONJq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 14, 2013 at 06:24:29PM +0300, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>=20
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>

this one looks good.

--=20
balbi

--G6nVm6DDWH/FONJq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSXHW6AAoJEIaOsuA1yqRElToQAJb8gRnuw+fm0fruuY7IUCTp
qPRdgD1QRh2Yh4zGIKtccgWpLD76E30aX+MIzGOk5b3F5EWj+tq9qYv/Wg+lQCig
z+OLI1XPmVz9VLNyGfiF6huNmG2K6BXqNH5bdDOYjv4uC/hxCQlNCq5UfAa8rBAI
CXCOhPQVCEcLmlz4Dyc5u9tCNfr1JRb7DcfAevIewRXu0IFcd3aALm+VEDepEBCB
U8ChPo+kesM79EHIdNBQvu7zEStOpp5IOkKu7uPKDvmae2gSm4AIZFHtCGxMv9LV
MdqiuakvZrk0QMJPgz67fIV4ftAiuUWCqrTHXrktEw8p1Y90NANBWLeFWtXMsJWF
a6zqRofi7dSt/nhnisj87PO41z9c8uSdPuM9YUPdEo/4RkJ59sveMkP3raD5BhsJ
L57705fZSg1yNIHvv5r3SRWOsUkoGm7joPJYLivN5a98Eg050y6/K2VZjusoNXQr
ZNrBDJNAxpl6UG4/iUJhVEr7gmuNCvaIJLw4DCYERjS4i5e1C/VP2waS4gPNLbXR
TphT8pEMwn+oiP5j05kUGFhLIs6EPW/FoILtcagtCq3yK4yZowZhiel1ujywfy7y
bi1m51gk+hA3H7rMU28CJyOiU01Rw7l9Xrd69pZxu9PSPrJgGcmaLbPwSIV7bHGI
iAYASH4PnxMfS/VzY6SO
=R+wL
-----END PGP SIGNATURE-----

--G6nVm6DDWH/FONJq--
