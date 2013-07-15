Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab3GOJ7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 05:59:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36434 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696Ab3GOJ7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 05:59:36 -0400
Date: Mon, 15 Jul 2013 12:59:04 +0300
From: Felipe Balbi <balbi@ti.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Yuan-Hsin Chen <yhchen@faraday-tech.com>, Felipe Balbi <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: fotg210-udc: Remove bogus __init/__exit
 annotations
Message-ID: <20130715095903.GD14330@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1373492716-14684-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Hf61M2y+wYpnELGG"
Content-Disposition: inline
In-Reply-To: <1373492716-14684-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Hf61M2y+wYpnELGG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 10, 2013 at 11:45:16PM +0200, Geert Uytterhoeven wrote:
> When builtin (CONFIG_USB_FOTG210_UDC=3Dy):
>=20
>   LD      drivers/usb/gadget/built-in.o
> WARNING: drivers/usb/gadget/built-in.o(.data+0xbf8): Section mismatch in =
reference from the variable fotg210_driver to the function .init.text:fotg2=
10_udc_probe()
> The variable fotg210_driver references
> the function __init fotg210_udc_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variabl=
e:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
>=20
>   LD      drivers/usb/built-in.o
> WARNING: drivers/usb/built-in.o(.data+0x14684): Section mismatch in refer=
ence from the variable fotg210_driver to the function .init.text:fotg210_ud=
c_probe()
> The variable fotg210_driver references
> the function __init fotg210_udc_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variabl=
e:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
>=20
>   LD      drivers/built-in.o
> WARNING: drivers/built-in.o(.data+0x8b0c8): Section mismatch in reference=
 from the variable fotg210_driver to the function .init.text:fotg210_udc_pr=
obe()
> The variable fotg210_driver references
> the function __init fotg210_udc_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variabl=
e:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
>=20
>   CHK     include/generated/uapi/linux/version.h
>   LINK    vmlinux
>   LD      vmlinux.o
>   MODPOST vmlinux.o
> WARNING: vmlinux.o(.data+0xc6730): Section mismatch in reference from the=
 variable fotg210_driver to the function .init.text:fotg210_udc_probe()
> The variable fotg210_driver references
> the function __init fotg210_udc_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variabl=
e:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
>=20
>   GEN     .version
>   CHK     include/generated/compile.h
>   UPD     include/generated/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
> `.exit.text' referenced in section `.data' of drivers/built-in.o: defined=
 in discarded section `.exit.text' of drivers/built-in.o
> make[3]: *** [vmlinux] Error 1
>=20
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

has already being sent before. Sorry

--=20
balbi

--Hf61M2y+wYpnELGG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR48fnAAoJEIaOsuA1yqRE+EsQAIBS1E2g/2grzsKjigNCZKEM
qzeKYFkq9hmBO4pXzcwh4bD7o8DnIsmo83DG6uvt3LeKdeYn8EWDh2edY2mdXeVZ
Z7ebS3FDTjnKVq6NjvWaopqYw/UkBdljwrt8DmDFnJgbznFCwA7H2DdTz672ABUN
369fFw3DC19EOsnJNFAK6k0NEjL8BWxLw79DYevoy/2UoWb66spD+Hdy0+VYVhne
oJKA8ymPmsjkGXh4pCu1vX4owIsCLxcWiO2F7cPG8vnzoGkeMt2lW1FKA4LssgmA
euRMorcmJ5rkJLgCoXJKy0OVnTB+m+YpWUsnExTGurht3HIJW4IYqkOHORnkvaBE
3DbHmk9HBzcsLGD5ImGg43/08m2oZM233wVB8pvtdhyInG5kPYa1Qnm59CSsKXwZ
Zzd94H8JwV11qDQB9UzuAJN9UQLr/DnzcnBjwRT1rsOXhuiCFEJfuTgWAMGmjPKu
/fCQaVPE305MyWj+ghVEgKBq5pYXBSs0Kt9wgKp3IOCef4nTryYZTaU8dQXoPFTF
ndWgZYLPpCo/KoAUzVgt/9Oa0GJ3eEj7TrKlUbu9hMXw581dVzZ1FkXAPBG8YbSD
mUE4lUmGTyrxnXyE/UeSR/CYR9fOnpL483BZUJ1oy7avlAm8jEpE5IQDSRR/NmJJ
wcIBewCzcCz+VXd4NB5R
=Gfoc
-----END PGP SIGNATURE-----

--Hf61M2y+wYpnELGG--
