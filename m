Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab3GRIIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 04:08:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58211 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755625Ab3GRIIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 04:08:31 -0400
Date: Thu, 18 Jul 2013 11:08:23 +0300
From: Felipe Balbi <balbi@ti.com>
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
CC: <jic23@cam.ac.uk>, <linux-iio@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <koen@dominion.thruhere.net>
Subject: Re: [PATCH 05/21] iio: input: am335x_adc: Add continuous mode to adc
Message-ID: <20130718080823.GB11251@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
 <1374082010-28095-6-git-send-email-zubair.lutfullah@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HG+GLK89HZ1zG0kk"
Content-Disposition: inline
In-Reply-To: <1374082010-28095-6-git-send-email-zubair.lutfullah@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HG+GLK89HZ1zG0kk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jul 17, 2013 at 06:26:34PM +0100, Zubair Lutfullah wrote:
> Main patch. Adds continuous sampling support for the driver
>=20
> The IRQs are changed in the TSC drivers as they are shared with
> the ADC IRQ lines.
>=20
> This patch is based on work in the 3.2 tree by TI
> Original Author is Patil Rachna
>=20
> Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>

to me this patch looks incorrect. IIO framework provides a generic ring
buffer implementation which could be used for continuous mode. Adding
driver specific attributes isn't very nice IMO.

--=20
balbi

--HG+GLK89HZ1zG0kk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR56J3AAoJEIaOsuA1yqRER10P/3LR6XQMMELc0CSBIUVxJarV
FasaTZ9VdRP6CbPQ985wf7fZw7j1N6OSukdvlrOIYzZqG7TaF8AARNpeLZl2JQd/
CeF9ilbz98b7jC+h61Y5EFKXcRTCp+HRh7f49MYH7Kcast7QknETADN854NTYNMS
qBqqmxLvRXZOMyMdoJ6zNwgjDziQZaW+z0xJ8OeJnD0q0jc5SSg46it9MfHEv6Yf
9oBQ0xAjUhtm0iWg0KZwm64bsHQ+F1SbtL/j04hqGMKmczHW5BfJPTg5QmxtVrpv
7sspXza3dNturIhvoMWah2dxg5CQScTZPyCG8E+ti7Pot2thXhGyXzcqwCd90/3O
mJ3JIn1zf9qhYB+VdpEW8nslqa0G/PAJZpLCtKzVPn2YBVKxLo3mqxHizLtRZb+9
aorlPQsPybKaISRZPv4zPETgFEGsxRMx4v6QlBwedgjw0ZqTOQcqzXgiyRDfbLmN
NBKpJifKaKhNrE22N+Pq5kKI9NFfCodQtc+AY97SKWs9dxm3pslzza5Kgk3WQ62u
KZ4IO9ezjpD+VJp1PlwIkDKt8nd5hPcIbDl7izB1oUb9H8HHxN0YolHwvLxmMxXW
FylTB4ILeXG9sY59oI2RN6aNs4Lnc14UkA+W+upLtCU+Tc6mZ45LjThiJ0wqO4Dx
nalYEjThI+4LUz/7jSD3
=TUXm
-----END PGP SIGNATURE-----

--HG+GLK89HZ1zG0kk--
