Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab3BEJki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:40:38 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42274 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842Ab3BEJkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:40:36 -0500
Date: Tue, 5 Feb 2013 11:40:22 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 28/30] ARM: OMAP3: overo: Adapt to ehci-omap changes
Message-ID: <20130205094022.GK32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <1359372631-8180-29-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x/TyKPcLwmKZr+b7"
Content-Disposition: inline
In-Reply-To: <1359372631-8180-29-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--x/TyKPcLwmKZr+b7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 01:30:29PM +0200, Roger Quadros wrote:
> Add platform device for 'nop-usb-xceiv'. This will be used as a
> PHY for HS USB Port 2, so provide binding information for it.
>=20
> Model RESET for HS USB Port 2 as GPIO fixed regulator and link
> it to the 'nop-usb-xceiv' PHY.
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--x/TyKPcLwmKZr+b7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRENOGAAoJEIaOsuA1yqREisUP/3KU1ATkxKtw/7L7H5JrRBVJ
T1yk/xldsAjTrseQM4GYRhvMAR/e9wHuhZpL0nnQp5W2FfTmZYRo3IyZhIG8kdsP
28C9FYqqOOFbvQIjqA/o4NY7zJ/jZ+AB15ZFJVGPaE5B9eTchIVv0dhpi0KhYqio
Wt4cF7KWzFnoDDBGeXINUQ5PRqNJZx0CF4j0Nvmc/doxPel16wpObDGwxRA8MFYP
6rLVhtg2dpb3gasEacWd1edjJnxp/hKetFFQA2XZdVHr7jTZA8x63D7SWNAO6nIV
dGU5jfEUrBHGKJjUYNMsRVLPUCJG3WkZInkQ13uEEm5FaN3VsRAqzVo7njoeJD4j
EmdcUckahuB9GOzFXCAiStwhunTDSgHM8NhLEG6Ny3XQhL/QThVK1b9fhDXjSiNG
dzKB9wAa9Zher01YMxQzaKILpeMF1rn69h7eJ+Ii8dVhq/A361mYIP8nYWFFeQfJ
MzIMasMU9k2wA/XyeJ5G5dqGipql6DizRD/fq59y31K2q67SdYGxGsQdeCuM4SxQ
9lKYb86SI0N/XxlO/mHj0NklLcbrrNvgfuHlTK7IHUGj6ze7LZ5brZysiwN9pEip
l6nU19WTpKbk/YVFRz4Cev8OLc2OXO738y3rWqPgJ982vKJF8Dui3ymSO8M99NFy
4XNIbh+jNUFgUGe5ROGI
=Oxo8
-----END PGP SIGNATURE-----

--x/TyKPcLwmKZr+b7--
