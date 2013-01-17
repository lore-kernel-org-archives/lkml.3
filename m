Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab3AQLvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 06:51:09 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:43704 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab3AQLvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 06:51:07 -0500
Date: Thu, 17 Jan 2013 13:50:46 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>,
        <kishon@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <linux@arm.linux.org.uk>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 22/22] mdf: omap-usb-host: get rid of build warning
Message-ID: <20130117115046.GI18978@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358422231-24736-1-git-send-email-rogerq@ti.com>
 <1358422231-24736-23-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4BlIp4fARb6QCoOq"
Content-Disposition: inline
In-Reply-To: <1358422231-24736-23-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--4BlIp4fARb6QCoOq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 17, 2013 at 01:30:31PM +0200, Roger Quadros wrote:
> Fixes the below build warning when driver is built-in.
>=20
> drivers/mfd/omap-usb-host.c:750:12: warning:
> =E2=80=98usbhs_omap_remove=E2=80=99 defined but not used [-Wunused-functi=
on]
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

should this go to stable too ?

(though it's not really a bug, so doesn't really matter, I guess).

--=20
balbi

--4BlIp4fARb6QCoOq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ9+WVAAoJEIaOsuA1yqRE6IgP/is9vOuPObO3UUmVhnkF+bZl
LiBEqtYfcmhRDNyWSgAoDJN6+tpeO86k7SFv4ZBS3kco78MY6lFO3uDLoUtIRonO
wvg0gBBA7VW8VdEjH83Ww550y8Jldu1TS2wbXvXJA0zesDRVChwWxG/Oai6ew1+e
pNqdImy7WIg7Vyz/f1Mn4051nkfd1/9jLL8YsV+1V4TsmpMD2DRmiXdj6EqAYE5g
hWCMe03ZrWUiOlQjTk1vfvzGqBxrOLwyFNHaLwrTJtCa2aScPXd/x08hTmbXC2ww
V1K0knOTw7PdwvLgqH6TvJ+8L0fTZvEkVf/SO0psyqK1CXCZgBg0agWZOvN+oaCl
ezSAXWvBfkbGYxmOo32koMbTKxzQPz+IT2xsJi1c4yRiuNXxjH2xYudft2frzu1O
PyWSvXi3SiVkiyEFtzQZQHdCj1hpW7FdvmqRVQcp87BjWxV+csVGrsPaskab1wop
uasqo6X5d/ThpOyRBGjDvpof8UQLu9/yclVXY4vmwLmH6lyaMvd9MhjfPC3KdCVf
T1lvg5rMFBy36XlBWpDMywWPQOKy17Nqnx6cGCpopP7wHBMTLK5p/hjNvxyOfFUw
zfXn6KrDyfOtRLuPjUi4KufWAkTm66cwoslvpzNY0gWI4wjy3SCittEp8YdDn6qk
iqzHIDcQP+DKLr3Z1hKp
=ShIq
-----END PGP SIGNATURE-----

--4BlIp4fARb6QCoOq--
