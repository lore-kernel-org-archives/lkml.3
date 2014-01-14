Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbaANIE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 03:04:57 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:54040 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbaANIE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 03:04:56 -0500
Message-ID: <52D4EF9A.5010105@ti.com>
Date: Tue, 14 Jan 2014 10:04:42 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
CC: <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <plagnioj@jcrosoft.com>
Subject: Re: [PATCH v6] video: add OpenCores VGA/LCD framebuffer driver
References: <1389641890-2679-1-git-send-email-stefan.kristiansson@saunalahti.fi>
In-Reply-To: <1389641890-2679-1-git-send-email-stefan.kristiansson@saunalahti.fi>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="obCTjJqutDqeLQwniLxnaadUfEh9f8rNp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--obCTjJqutDqeLQwniLxnaadUfEh9f8rNp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-01-13 21:38, Stefan Kristiansson wrote:
> This adds support for the VGA/LCD core available from OpenCores:
> http://opencores.org/project,vga_lcd
>=20
> The driver have been tested together with both OpenRISC and
> ARM (socfpga) processors.
>=20
> Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>

I'll queue this for 3.14.

 Tomi



--obCTjJqutDqeLQwniLxnaadUfEh9f8rNp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS1O+aAAoJEPo9qoy8lh71ZFYP/iB9TEgV2YC/dxuF26XAD98S
cA4ewEIYt6uHiFPbkpebqCN7hu00q0HAlzHVsKk/uRUE6lefPlspNam+OSmK+laA
yf2e/PjsG/yHQJIXcFdEzr8zj58F9qjO9RrLchgtlX7f9YSh3bL/A8bvT1NuR2UH
a6t9qjrTu9I8EKd1bDFLKBcD5QBIk+xp9Zfsp2Zh2m0vDPJNH0ZD5UuqQgEvHVlR
x9XF6NbEJksTw+LIC9Zx3VIhFIREPT9x2uWX5Em/OQIMBqE41wJM4UA3Lc2ie/ZF
QE2klMa1uyhdkUfjHZaaIIFlZcG1MVSFZGIwZhqMQktHs7nLLSiFLNzBNjUC5cl5
SZ+bJ4hJwJmcs/0LKqQ4a88rxXsJVwqtquTFZBnGpPH9+JzckpnpFp+ByKpLbqjh
Ws9vsEIjkyQd9B/wW3jJhg9q4l2fUpYZlbFhrONrNq/OePXFI87hTzsIWfjRfxL/
4EyyMhDkImSAG49rVknOVPdD73f+Yd6DRKd+FvKQswT0fuAxBCzvnvZfOrVy6AG0
KqD1RL8MiWLU7/ueX6tXpaDhNVdTtLA8JJokxL5/4LVGWRj47Qz7tEi9QrhY/I4l
8x5BXPd1cfXDvFVT5pK2wEC4HPn5cp5S4VaNfR7z4IN77sfaTTLu65zkWr4rLvs5
mhryH3Xof6CiWUW2Gy0B
=4T7Y
-----END PGP SIGNATURE-----

--obCTjJqutDqeLQwniLxnaadUfEh9f8rNp--
