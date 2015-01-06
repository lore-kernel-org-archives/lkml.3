Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbbAFPfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:35:07 -0500
Received: from down.free-electrons.com ([37.187.137.238]:44831 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755625AbbAFPfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:35:04 -0500
Date: Tue, 6 Jan 2015 16:33:15 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org, shawn.guo@linaro.org,
        kernel@pengutronix.de, Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] dmaengine: mxs-dma: Declare slave capabilities for the
 generic code
Message-ID: <20150106153315.GP7853@lukather>
References: <1419873679-14463-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/NwG7NuG0/W8LcLh"
Content-Disposition: inline
In-Reply-To: <1419873679-14463-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/NwG7NuG0/W8LcLh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 29, 2014 at 03:21:19PM -0200, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>=20
> Since ecc19d17868be9c ("dmaengine: Add a warning for drivers not using the
> generic slave caps retrieval") the following warning is observed:
>=20
> [    0.113023] ------------[ cut here ]------------
> [    0.113053] WARNING: CPU: 0 PID: 1 at drivers/dma/dmaengine.c:830 dma_=
async_device_register+0x2a0/0x4c8()
> [    0.113063] this driver doesn't support generic slave capabilities rep=
orting
>=20
> Declare the slave capabilities to avoid such warning.
>=20
> Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--/NwG7NuG0/W8LcLh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUrAA7AAoJEBx+YmzsjxAgjekP/1owIvaZVaaLQJdTQC8f/0/I
HKZUj5MjGL81Z6ZTiwMqkfAPYCFWroCM2vkWyC0pp/RyXqPzK3NCrUjRmsG9HDxV
y36shy9Fcz/UoYfqpWyDxvuoiB/TXlcy+Kf8Sfo/DUkzLrBTn2a567WxmJ80lyuW
TF/ZbThEbGVk6hMEydNF87WDdjoQocRAK+7gXuWULC17JAHxLlau0SZYYqM72u+Z
HiL4+AqivJa/DcfszzfsngWCilodgS7/hldKhqxpDVbBnrgfA2OMdjFE2unqTZ85
SaMeWzZgAdLYb5hJPO0D8xnd6MNym1dZiLUncEEBEg4B/Z3rKXO8WIZyxL2cnRYz
Xv6ulPr3ocwrOb00smQMZvJiswkIgOw/yqoI8TIMOl/TclBcIrNxfAsHlpqEA+n+
aFjxpNidxUg4f8QjYzeSshV+wm25RGQ2m8XeZ6Pzlcoj88plSNdoQrkecc67U7/a
3yatqw7AOwBUQDZJBR8W/e1U9+AjOelwHu3OfktOEHvbCclP9sUfmkhZ356+o04t
OEoAT4X4fZvMEJfm132xVnKLCILLn6RBOoF6mC8FIq8oosAnms3X8AZGgev5ZZhV
WFRrejLF511rz/SDnXf13Ev2eqluZS0FHeWetHrr2UHeqmnARU7CUo4ST7axeKQt
b8oHTR40h6IhowIfNhs8
=1R5Z
-----END PGP SIGNATURE-----

--/NwG7NuG0/W8LcLh--
