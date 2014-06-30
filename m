Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbaF3RaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 13:30:19 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34420 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910AbaF3RaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 13:30:16 -0400
Date: Mon, 30 Jun 2014 12:30:06 -0500
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <balbi@ti.com>, <zonque@gmail.com>, <b-liu@ti.com>
Subject: Re: [PATCH v6 0/5] Add support for SW babble Control
Message-ID: <20140630173006.GJ31442@saruman.home>
Reply-To: <balbi@ti.com>
References: <1401096012-6895-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4vpci17Ql0Nrbul2"
Content-Disposition: inline
In-Reply-To: <1401096012-6895-1-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--4vpci17Ql0Nrbul2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, May 26, 2014 at 02:50:07PM +0530, George Cherian wrote:
> Series add support for SW babble control logic found in=20
> new silicon versions of AM335x. Runtime differentiation of
> silicon version is done by checking the BABBLE_CTL register.
> For newer silicon the register default value read is 0x4 and
> for older versions its 0x0.
>=20
> Patch 1 -> Handle Babble only if MUSB is in HOST mode
> Patch 2 -> Convert recover work to delayed work.
> Patch 3 -> usb_phy_vbus_(off/_on) are NOPs for am335x PHY
> 	   so use usb_phy(_shutdown/_init) in musb_platform_reset()
> Patch 4 -> Add return value for musb_platform_reset() in prepration
> 	   to support SW babble_ctrl
> Patch 5 -> Add and Enable sw babble control for newer silicon
>=20
> v5 -> v6 : Squash patch 5 and 6 form v5 to avoid build warnings.
>=20
> v4 -> v5 : Added a debug print before resetting MUSB.
> 	   changed a musb_readb to dsps_readb introduced in Patch#5 of v4.
>=20
> v3 -> v4 : Fixes an issue in gagdet mode - BUS RESET should not
> 	   be handled as a BABBLE. Added a check for the same.(Patch #1)
> 	   Enable sw babble control properly (Patch #6)
> 	   =09
> v2 -> v3 : Modify musb_platform_reset() to return zero on success.

this series doesn't apply anymore, can you please rebase on top of my
testing/next which I just pushed ?

Thank you

ps: while doing that, please also add Bin's Tested-by which he has
already given ;-)

--=20
balbi

--4vpci17Ql0Nrbul2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTsZ6eAAoJEIaOsuA1yqREVXEP/1anrliI2p2peyaa23JHqzqH
m+HTnfr3ygM1LrU9bQzkFjtDKda+VgtZ1V8vpHSNWvTJIJPQ6btOWHQU6sOWvcmX
/CMI3djYgSd6sjS47HctU88pitMVfbjwfWYp0nrKRSKoqwpKc3RDxu6BmSfghtGv
8iB3VxCNVMzFgoWJCCzzi9zLcRqdFJw0dGBuTq7u+Fk1uPm+YbfJw1ljDN+2jqsS
wELTGTLn//JvXTzC4moIEm1CjBPyFVkDXA9FC26abzSKlijILWIgU5N7qSZGX/GF
ponFCY4IdqLjKubL/UVbk/YPJrNH7KfukQiGMhcnWx2qoQjRm15y/G/FcW/b/sj3
bMqqwvhcG7tEzAFpuK8JHzaGhGH1054xoKVE+2XRCIG1Fn3vF+NqLdt5rhztd5N0
2To6izEUXRSSrqsG6yGM6xo1GXyX6D3JmjsmFWdMyOhbJ9hudsGb8x4fXS2jG7We
Wr2gzpK5kUbG/Sg67NYLYgnvlX23xP/URuxXDt/hlCU5471QO6D02EaEebuC1ib9
/ArZM0H6eqOTKut9Sz6UkazeK4AwCfTIGUO1lf4yncYofukTTLo5hBcZjIqWicQi
YTa43PhhlLIROTBovOR7207ZeVYm3lbr45/4UDcqNGVEZnPy9jyVkRGQghJt4EZJ
o2jkjMKeLNy5yNcIRC7M
=XoGo
-----END PGP SIGNATURE-----

--4vpci17Ql0Nrbul2--
