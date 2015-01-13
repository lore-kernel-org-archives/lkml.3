Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbbAMLXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 06:23:08 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:60917 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459AbbAMLXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:23:05 -0500
Message-ID: <54B5000F.8030408@ti.com>
Date: Tue, 13 Jan 2015 13:22:55 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH] video: fbdev: omap2: dss: dispc.c:  Remove some unused
 functions
References: <1420126149-27019-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1420126149-27019-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="kj63F3rPpMtD0LpUpJHXREUhaUAa5NA2C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--kj63F3rPpMtD0LpUpJHXREUhaUAa5NA2C
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/01/15 17:29, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> dispc_wb_go() dispc_wb_go_busy() dispc_wb_get_framedone_irq()
> dispc_mgr_get_clock_div() dispc_wb_is_enabled() dispc_wb_enable()
> dispc_wb_setup() dispc_enable_fifomerge() dispc_wb_set_channel_in()
>=20
> This was partially found by using a static code analysis program called=
 cppcheck.
>=20
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital=
=2Ese>
> ---
>  drivers/video/fbdev/omap2/dss/dispc.c |  124 -------------------------=
--------
>  drivers/video/fbdev/omap2/dss/dss.h   |   12 ----
>  2 files changed, 136 deletions(-)

The functions are for DSS's write-back functionality. We're going to
implement that hopefully sometime soon, so I don't want to remove those
functions.

 Tomi



--kj63F3rPpMtD0LpUpJHXREUhaUAa5NA2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtQAPAAoJEPo9qoy8lh71xXAP/R6mRGjCizsEHhHRUPcbSYF0
4DfVaQnO1+95wOAnA5gXkQR4yBVIgaIIPqMoxq9jyu9RKqaJYP4M1rdvTjIJiYEL
2Bb8yHlApfQQ4B5LOXIW6c4+srGwOrAk2lX4yGkfVRS4QhOLjkyHs+TLyNmKHsM3
v1xliHCvkKx3qcxJNSU+DVWhRyrCS3MY0gCyK2/k5gfPwlrCdDmL9WDJYzN/gNMU
svN7s0JhW7SQzicrCmpfK9NkHNcwiQnsRlOiUvrKi1MckpV1K3bvZp6cXXhpTstn
QOn+Nr1vdYBzLevQas917OtAC+Xp5wFYluIJnczJjxjO+3QXeQ2/xdvTmWrm1bu3
UUOwPwpUibwPRAyI+IHBE2cg28RAw592L2qsv74xvY2HXcr5o/gMtxDZr0oqaLXq
SJu+t9JK6EkrYHkwGSxb5MUwtK+uuAs5eFOmLZGEHwmZgoVuZrwQpyVTNF7AwCG/
ay82NgzjLfZgh74N0GD2Acs37fwf4a/miHg4QGpH5LmpZLUOj2ocQOsoN47OoOAR
MnAd37C/7aRjMPPnhYZTq99pe2zZTDZUcKn5aAUk1qD7cST20rZe1NTRnpPHqQ1l
TTjaqzuUNbuIq2ziU+zBLiplKPrfUlWvZk1yrnSlBJoa4fo6cjiZ0n+40vHbFrHk
mM7PfyW4QXTCMLx0k2Ew
=R4vl
-----END PGP SIGNATURE-----

--kj63F3rPpMtD0LpUpJHXREUhaUAa5NA2C--
