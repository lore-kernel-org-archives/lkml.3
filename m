Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab3AUSmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 13:42:20 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:54203 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab3AUSmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 13:42:19 -0500
Date: Mon, 21 Jan 2013 20:41:38 +0200
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arm@kernel.org>, Felipe Balbi <balbi@ti.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 12/15] USB: gadget/freescale: disable non-multiplatform
 drivers
Message-ID: <20130121184138.GB10106@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
 <1358788568-11137-13-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Content-Disposition: inline
In-Reply-To: <1358788568-11137-13-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jan 21, 2013 at 05:16:05PM +0000, Arnd Bergmann wrote:
> Both the fsl_mxc gadget and the imx_udc gadget drivers fail to build
> without the mach/hardware.h file that is not available when building
> for multiplatform. Let's disable these drivers for v3.8 in combination
> with CONFIG_ARCH_MULTIPLATFORM, and fix them properly in v3.9 unless
> someone has an better solution.
>=20
> Without this patch, building allyesconfig results in:
>=20
> drivers/usb/gadget/fsl_mxc_udc.c:21:27: fatal error: mach/hardware.h: No =
such file or directory
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-usb@vger.kernel.org

NAK, I prefer to see a real fix for the problem (which in fact is
already in my fixes branch).

Next time, before enabling something by default, check that
allyesconfig, allmodconfig and allnoconfig builds fine, please.

--=20
balbi

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ/YviAAoJEIaOsuA1yqRENAIP/jTKidIGyfJoyGOH/PFtHwPm
wM+wVmS9U53pn/2iQgfLHZFkdJZDedzb44yYv5UGGTzJM/yCP+vdbWOVfBMfpoGi
uvnH6HJuPhoTfHH9q0S7qeSTe5fJXagDXQp+R1G2FXV6xJc1PLP83Lp7FgfzxSZY
Xc20il5UW4Ag+6w7WgYoTanY+oHp3duwMoFCF7kEdokZm9HLIwVlgacqEAkGyGIP
gs7wT5vQN/0XamgYHGAZJr0Mbq4GM/vKrR0s8IdzlcIGrOAwHXowhJ3gg/i+gW5A
JRGOa8xsJ2FIUOt07Ck4BxduTYSGloXcmMM7EIJPppiEjtght3ZWyYuNjAdDd4Ro
V2Z5rtanp8veNNuj0pQrWJEvOAO4TsKJ2O3NtJABC3XFRfp4nwDHTFbT3mEaQ8LM
9OIn4chtDZmKz5FL4s+ysCjcLxowuf/jgXMqc9VJ+b9C9gxjDJ/Rn0RMtauGrm4M
AEt2piwKD6kC8hDHQOFVvnpR15VagMh2LWypfI0PbLGVaAXLfldThq99k2LsUXHU
f7SApsi2MbGmtiqw08myilPav9iWhTm8HL6SZL1g0hAKm4gByc1vEWVY4Hqyy9ie
fGhKWLoZh1g32YqBopTwU/dsNQTu8W8x8aV3/BrDEIOJQfieOEXHanMq3tO7oeu7
MRE+4DX4A5BL1tbZcuPk
=Bhzy
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--
