Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbbAMNPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 08:15:42 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:55642 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbbAMNPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 08:15:40 -0500
Message-ID: <54B51A75.1000308@ti.com>
Date: Tue, 13 Jan 2015 15:15:33 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Colin King <colin.king@canonical.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] static code analysis from cppcheck reports:
References: <1421076472-7101-1-git-send-email-colin.king@canonical.com>
In-Reply-To: <1421076472-7101-1-git-send-email-colin.king@canonical.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="oFQ2TwE9RKDtGAaFAKopuMvtLdjlCFsdI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--oFQ2TwE9RKDtGAaFAKopuMvtLdjlCFsdI
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/01/15 17:27, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>=20
> [drivers/video/fbdev/broadsheetfb.c:673]:
>   (error) Memory leak: sector_buffer
>=20
> sector_buffer is not being kfree'd on each call to
> broadsheet_spiflash_rewrite_sector(), so free it.
>=20
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/video/fbdev/broadsheetfb.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

Thanks, I've queued this for 3.19 fbdev fixes.

 Tomi




--oFQ2TwE9RKDtGAaFAKopuMvtLdjlCFsdI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtRp1AAoJEPo9qoy8lh7167YP/i6owjTNe0G0pykrUv5euit8
QY3Pof8rK+xGMntBix2cw4/1Qp6pbFzLacy8/DM6lpVsI77EUOn9WjOIOYDi8TO0
R5DINFJABy4ZAQ/6VScsxLXpe45W0NWiloz8rw+vNcJAj4KWrKyalttkJqQSygHt
qUMSL7nFKFnzFdJuX2WUbSkIp6kF25hmhRGepsNGerFm4fWkvhHB2OB6PjuZAAr4
ehSIWU5h6vRT1Zm/KWAz74ZGMfIHgO01NTp/seVcx4QsXZBJ0QvrI0q69XTMYEy2
gZLJbY2E+c/gvtENiYBF7uDzD3atp0SK9uxun+VmG5SwsrXChmkmV5mfPenJf+Qp
0J92fYt9w3cpK5Xe0XCiaU72Vea5U0yzHFgT30bbyBB9TWTZ97xBDZIF8ku0k+fG
kZ+4HF4D8GJC2PwPhw72onviXSg+iWIYPIvR999CvNT3Oza2XR5pAlIjO6y20vPb
O/OXBEgIq/DS6hopcf1BYuIshZmTNwtm+3uNOfU/zLAE8JKg9i8NGTNIrxaabQZB
zOqz39xiixiudwYdyBWuxUAM7KOu+74/fFjVVSFWfJ61uemvKCvCW8AhpTzDfnAf
4Hxh4MpzEZ2sE6N89wYVH0fK2Y8Iug/1cwUstS+y0FfITWLiKIu72XPLeFAeRZA0
Cq0AGWfdLrT8MDZNJNki
=cBQH
-----END PGP SIGNATURE-----

--oFQ2TwE9RKDtGAaFAKopuMvtLdjlCFsdI--
