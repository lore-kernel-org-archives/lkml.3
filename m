Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491AbaEPI5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:57:12 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43321 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbaEPI5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:57:10 -0400
Message-ID: <5375D2CE.5050801@ti.com>
Date: Fri, 16 May 2014 11:56:46 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>, <linux-omap@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Peter Griffin <peter.griffin@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] video: omap: delete support for early fbmem allocation
References: <1399675964-22917-1-git-send-email-aaro.koskinen@iki.fi>
In-Reply-To: <1399675964-22917-1-git-send-email-aaro.koskinen@iki.fi>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="KaMSlFi1wJVMETsvD2u2U0qkFGoSeRd5t"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--KaMSlFi1wJVMETsvD2u2U0qkFGoSeRd5t
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/05/14 01:52, Aaro Koskinen wrote:
> Commit 1e434f9318efc3dddc0c0b8d2071712668154c2b (OMAPFB: remove early m=
em
> alloc from old omapfb) deleted the support for early fbmem allocation
> from the platform code, but some code still remains in the driver side.=

> Delete this code now, as it repotedly causes build issues on !MMU.
>=20
> The patch was tested on Amstrad E3 and Nokia 770 and framebuffer
> functionality is not affected.
>=20
> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>

Thanks, queued for 3.16.

 Tomi



--KaMSlFi1wJVMETsvD2u2U0qkFGoSeRd5t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTddLOAAoJEPo9qoy8lh71JycP/jh4fkLxmePYwOo202X7RepU
FezY93PiyngWt6uP3c2GzcwbW5tX6Y3ujMtAXTVJ32swRqCPoeDF/TV4qq1yesIr
Kog+w109gwV9pFVTR6vupriNjYRUGUIneK2IMdlxd4K/y5mxAGQyN0V0yIepZKv0
e5eLJSdH31MVlFBM3w4bKQTJaXXR62t9kmsbxXDEYpHDyGQmpfqbKUVn2KXOAgC0
dUKwzC9SJfN8Sobr3M1gf6LAECfHd8L7mham5FDfwh29Q/8IMFGtBopsN1hfSN/v
q09Mu6bFxvMaeTVsHhRuvaGgIBJjQ/thM1gxF278Onn+S5M8iG//nangjVGA3wnA
caB6ztM8NJiRfBQINbqgcbPPxGV0wxvjYHwZ25PB4YclTQX+czXuk5C1Ac3J8gjo
oFTsPqMw+muK7dAfAxyZNI/iXgppXBRnTluRA2jhSQBI0uUYPprmjpFDRZ4911Fo
z6PfV1M1ooz8QXgKkSpWGvl3zufwVCibWVA+Aw6SCQygT8CJKl8ZXi5D65cDQq4b
3919zNtOCcvbL15kMYMVOJvrTPNjuaXy5fUubYLQDX7B+kPGKkN8jJ9wQRa9dqH1
LDaAdzn9dGBuxZN5oFTAnf9KvS6w+IQkM0NRjv85USYJ5rJsQm2US8zWDrhZgKbl
G1boRxGLu7MoRl34NHRN
=01QK
-----END PGP SIGNATURE-----

--KaMSlFi1wJVMETsvD2u2U0qkFGoSeRd5t--
