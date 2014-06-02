Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbaFBJkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 05:40:05 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38246 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752976AbaFBJkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 05:40:04 -0400
Date: Mon, 2 Jun 2014 11:39:44 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org
Subject: Re: [PATCH 1/1] pinctrl: sunxi: Fix potential null pointer
 dereference
Message-ID: <20140602093944.GA27722@lukather>
References: <1401445252-21413-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <1401445252-21413-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2014 at 03:50:52PM +0530, Sachin Kamat wrote:
> kzalloc can fail. Add a null check to avoid null pointer
> dereference error while accessing the pointer later.
>=20
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTjEZgAAoJEBx+YmzsjxAg0lwQAIfuOt+dLpGtDXM28wcpf+LZ
JNgHnMMzafW40iReGG9CN8fHflPaCMCAZoSMrUZEPz7+qj3TUeT3iFw2FbeSB1po
KPJSXrYutqMJ6U5rdx2qifiWuf/Hl0XXAb6KSbBQl2Wg1pv7AlmYOekdDnouGOWv
3t9JUY9m5F6WpJeGDVCM0XP2d/CK3zC+DLMZYuPhI2Y2QZu1wDnhWGpohVQnWhPb
87KsA3MHqo6sq80cywcqqFsgk9dR/uaFfqiTps8VAUu1qQzXRgJM7gl2NFYCGXPD
lv3G5jNpG0356KFo3jUa4Nn1bhTXfpjka3yu3Tq8YBWI9tYMyHB1dPoXveQl/7G/
AhRInHC9lTog+SZ9nK2IS6nUjOQUk0gBGVDglSHYw6CzqohsokNJPdtr3irDhyNR
f2FdbYhsmpS0L41pSlyvcJR3Yex+MEQ8ilrVneP/1dvyx3GAAwfJycPKb+I89+Jw
UXgC25H4fclEZP3DklnorkZ1klmwOnJ1cjA2q/pCM0LfLORlxqpivvV4x1L2ISdQ
EHwpe1EtPwy+8friE5A2Q2Nqu9ptoaEd3I+1pk4HQSRjHkSe/NzQTwP+4RgwAXCM
wKaM9LwbNnZ1GBEKTgmoVjaQutWlVGA8p/Dv2oqbuA/B6kh2LDt+Hq/KagCxAr6k
aNnmp9PdyfH8Q1hSHNlT
=2BZJ
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
