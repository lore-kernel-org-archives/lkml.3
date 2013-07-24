Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab3GXMXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 08:23:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47303 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab3GXMXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 08:23:48 -0400
Date: Wed, 24 Jul 2013 15:23:09 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <linux-arm-msm@vger.kernel.org>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] usb: phy: msm: Move mach dependent code to platform
 data
Message-ID: <20130724122309.GD17962@radagast>
Reply-To: <balbi@ti.com>
References: <1372087664-26396-1-git-send-email-iivanov@mm-sol.com>
 <1372087664-26396-2-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mR8QP4gmHujQHb1c"
Content-Disposition: inline
In-Reply-To: <1372087664-26396-2-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--mR8QP4gmHujQHb1c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 24, 2013 at 06:27:38PM +0300, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>=20
> This patch fix compilation error and is an intermediate step
> before the addition of DeviceTree support for newer targets.
> Fix suggested here: https://lkml.org/lkml/2013/6/19/381
>=20
> Cc: David Brown <davidb@codeaurora.org>
> Cc: Daniel Walker <dwalker@fifo99.com>
> Cc: Bryan Huntsman <bryanh@codeaurora.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
>=20
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>

I need Acks

--=20
balbi

--mR8QP4gmHujQHb1c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR78ctAAoJEIaOsuA1yqREyfYP/394WcISJ9uD8VSm9WbupLSN
E2fYAxNXL8C2jsYfg3241/xNj2OzaffLzyMBHOAhtL97SBjs2KY6s0DCMvx7w/Ug
WTRilAFKhmJNfr+CkYoJ9Z1XFiMgWd4zeuqfwJebwM2qFSDGRpeZ/M5VqoNerDlT
SHNZjM5tdpjt/p5YPjQN6lxuZg0HePk4gKuvuYI64+0sA5gfUqz3cG2Wsx5J9n2d
TqcorlY/yK/ybMRIL0md9U5WD4t5ni6seHqKV/F3mBkTBTnwp6hWbkopOXjIDHkk
wnwPawbV37+SqH54jqsA3iaaPPMb4LxY8CEDw5oUKK3ZldtLDDgFsPLC+NiqL03N
XGg+z9oCKKirt7WYnYJjZnVQHGybi4A0x+re6Z8eo0QoaQQV9AyIBab4WLBlK8vM
Zqm3X2kPXTsW2nOLxYpR1TDV/1YSiHe8MeY5UjnHmqIcJcnCuy78yXicS0zpNYaC
y9fp/4dsKLQ0SfiOos0wVHTichX964TVy6Quje3W7zctVx6cPpgte+OlRm2C7tlC
l3pL4pFeUXuwo/1/8WyODlMXjd41NVo6Kzk16fNsIL2KF0meJOb3zWknVXWr2CFZ
XaWRbm2Dvl0UDbMDNtw2TIblrVvipEVM7eP/ieV3ZnUgsXHxex5tsnMjmhj4RmSj
1gL1tZ4uuxBCqOVeMT/6
=FjDQ
-----END PGP SIGNATURE-----

--mR8QP4gmHujQHb1c--
