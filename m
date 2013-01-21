Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab3AUSvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 13:51:10 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51883 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab3AUSvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 13:51:09 -0500
Date: Mon, 21 Jan 2013 20:50:45 +0200
From: Felipe Balbi <balbi@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 29/33] usb: Convert to devm_ioremap_resource()
Message-ID: <20130121185045.GD10106@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
 <1358762966-20791-30-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ylS2wUBXLOxYXZFQ"
Content-Disposition: inline
In-Reply-To: <1358762966-20791-30-git-send-email-thierry.reding@avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ylS2wUBXLOxYXZFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 21, 2013 at 11:09:22AM +0100, Thierry Reding wrote:
> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
>=20
> devm_ioremap_resource() provides its own error messages so all explicit
> error messages can be removed from the failure code paths.
>=20
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: linux-usb@vger.kernel.org

For drivers/usb/renenas, drivers/usb/otg, drivers/usb/phy,
drivers/usb/musb and drivers/usb/gadget:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--ylS2wUBXLOxYXZFQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ/Y4FAAoJEIaOsuA1yqRE6JgP/38INvyZHVh8bsMeAYCsRvZu
cjtZIUKo/vc9iRRvwW/vkPFJaNopWqLAuJxOHAe/gdZNAw/DeVKqq46O5P4DkBr9
olqBtEhrbvEu/wrbdgWZxVGvRe0drZO8a5I9y8sMDaN0UO7z8aULRx0IoaUotW4v
75lvQRBgo3vk2gGQfMK0WOi5UQw5BJCA0oPhFFAL/7n1tm+kP6nA3R1UdbkUwzi8
jMZfxvxh7GqFWVtY/ahRZxjyWAkrrdmDaI09yGV2apVvslaIc4rLPifNYET1V0M7
nBZ3sXsCrBwHvHhLLdO7Rqk86n+xQLPKhViDTc/aywL13eqfhHDun/94bejsi6Vk
b4Nuy8GvUNKRydcjARnmyey8gLVwMOiXDKY86ZeRL5nkmwYsDPXAqEVUFEG/4IRp
e7TonbsZe/mc1RhOI0McSsR08P7UdMJl5V+QoeYDybZkKXGduYcOkigZQSOp8vZY
LAg3YNZy/msOmTre7mT6HIz4WMbJiFcN5vhqpHeMix4rpeSyUGFh3KfmMvba3oU3
5EuLFo64P0rmYTsnEQkam8OFnUEavwvjqUB7GUHaTfo4IyZhxQgkIh+whYSLWwRT
sSfHJXHiBDK8cGQXjnSnVqVd5CR8+TwZ/jVLJP6RvMDbwgAUF9S15OeHik1ixiiJ
2GpuK6nRqcFrS6S96rPo
=pYIw
-----END PGP SIGNATURE-----

--ylS2wUBXLOxYXZFQ--
