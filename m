Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771Ab3KZXIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 18:08:13 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60982 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757048Ab3KZXIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 18:08:10 -0500
Date: Tue, 26 Nov 2013 17:07:38 -0600
From: Felipe Balbi <balbi@ti.com>
To: Chao Xu <caesarxuchao@gmail.com>
CC: <linux-omap@vger.kernel.org>, <santosh.shilimkar@ti.com>,
        <khilman@deeprootsystems.com>, <linus.walleij@linaro.org>,
        <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>, <balbi@ti.com>
Subject: Re: [PATCH V2] gpio: omap: refresh patch "be more aggressive with
 pm_runtime" against v3.12-rc5
Message-ID: <20131126230738.GA17630@saruman.home>
Reply-To: <balbi@ti.com>
References: <1385506004-14943-1-git-send-email-caesarxuchao@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <1385506004-14943-1-git-send-email-caesarxuchao@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 26, 2013 at 04:46:44PM -0600, Chao Xu wrote:
> From: Felipe Balbi <balbi@ti.com>
>=20
> try to keep gpio block suspended as much as possible.
>=20
> Tested with pandaboard and a sysfs exported gpio.
>=20
> Signed-off-by: Felipe Balbi <balbi at ti.com>
>=20
> [caesarxuchao@gmail.com : Refreshed against v3.12-rc5, and added
> revision check to enable aggressive pm_runtime on OMAP4-only. Because
> am33xx_gpio_sysc.idlemodes seems to be wrongly marked as
> SIDLE_SMART_WKUP, which might cause missed interrupts with this patch.
> Tested on Pandaboard rev A2.]

Based on a quick look, it looks good to my eyes. Didn't test on any HW
though.

Signed-of-by: Felipe Balbi <balbi@ti.com>

> Signed-off-by: Chao Xu <caesarxuchao@gmail.com>

--=20
balbi

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSlSm6AAoJEIaOsuA1yqREFT0P/R6DiXKM67aDgakCXG+BAE/h
ZHBhGPy7ZaV18CpLxmyHmU9rtnH5vt9+8Qf23pEaICxcoK2DCBz4NmmR5wMpicZo
WrTcFoZd6SMxQU36IjQqQkjXiBxg3RkJK4lNWxTqzq40VI/NrbfdRWDDd4KoJg4M
09yvqbe310vZAMdff6SbPabE7Rsxsak8eAawQRw+Q6LcclZi6hCYeB7S2gFgug3q
cmIAHKUbMDoKKrSc0tDPONh8WS/8ZdNymS9mKO7+Sm5OASF68jhuQo7fSampMDYv
0GgZ96ZjBWyLaiuB5e3Pa0dYU1ZANLqfAFXwMNN1BNOBJUXecdgYf4XeC4Qft6Q5
zB34hbAgAztb2pWzi2rELSxWLVjR+apHL7U2I3Q20ohQD/BPUn+GoscgRnb/Xxoq
J6QUYsd58XlxKM4/X9N0Z0RKz6qr87T1mhrysWWzaP96mcqkxsTIk/R0VXBjLkBO
5WfdIEcc8r7U+r6IlX+kDA4AndJvhnfavKsVqNNtu2HppTFDd4kqMLWRLuTRptPv
/ORSWTki04JC2uAw6jpImHgHzZVnWjis1P/Fc+Mj2iTJODGTVyG3JKyUS3dHbffy
PhrlH8FBIrHt8p5yb0mS5Y3SAAcsFP4/cvdfEms8rBn6VCRa+a24UC5py1/rKl96
WBoqDAW6XnyRigTYttS5
=/KHo
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
