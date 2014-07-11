Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbaGKC1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 22:27:54 -0400
Received: from mail-yk0-f176.google.com ([209.85.160.176]:62539 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaGKC1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 22:27:53 -0400
Date: Thu, 10 Jul 2014 23:26:54 -0300
From: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] staging/solo6x10: SOLO6X10 should select
 BITREVERSE
Message-ID: <20140710232654.30f116e7@pirotess.bf.iodev.co.uk>
In-Reply-To: <1404637121-1253-1-git-send-email-geert@linux-m68k.org>
References: <1404637121-1253-1-git-send-email-geert@linux-m68k.org>
Organization: Bluecherry
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/6oAjylnzeVJ8Iwq36VL6.Un"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/6oAjylnzeVJ8Iwq36VL6.Un
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun,  6 Jul 2014 10:58:41 +0200
Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> If CONFIG_SOLO6X10=3Dy, but CONFIG_BITREVERSE=3Dm:
>=20
>     drivers/built-in.o: In function `solo_osd_print':
>     (.text+0x1c7a1f): undefined reference to `byte_rev_table'
>     make: *** [vmlinux] Error 1
>=20
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/staging/media/solo6x10/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/staging/media/solo6x10/Kconfig
> b/drivers/staging/media/solo6x10/Kconfig index
> 6a1906fa1117..1ce2819efcb4 100644 ---
> a/drivers/staging/media/solo6x10/Kconfig +++
> b/drivers/staging/media/solo6x10/Kconfig @@ -1,6 +1,7 @@
>  config SOLO6X10
>  	tristate "Bluecherry / Softlogic 6x10 capture cards
> (MPEG-4/H.264)" depends on PCI && VIDEO_DEV && SND && I2C
> +	select BITREVERSE
>  	select FONT_SUPPORT
>  	select FONT_8x16
>  	select VIDEOBUF2_DMA_SG

Signed-off-by: Ismael Luceno <ismael.luceno@corp.bluecherry.net>

--Sig_/6oAjylnzeVJ8Iwq36VL6.Un
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJTv0tuAAoJEBrCLcBAAV+G+m4H+waEfOYkZhwcuFnI+NyR1l1z
fbVNn+jg5Vm2pR4kOpGO6l5y01vD3MLciYgWo6jxDNaHRMdTfflrPa1GG2d6jCzM
AnFVYxSemrG2Dsz92W/bTUMYd+PhHw1cq2ViKwrT0wUKw7rlnNRo1Qdso8caxgf4
nYo7n/SFliuJoriGZMO3/p+nczTHYn2E98DAx6ti5Uj1ZPkTbovY0WMuoSnfNcYj
V3oZVJJYnxnDxkxNXNuP1ugg0beTdE+OIKEhU4c2T3k+UQ8luccbN+Z3un2nlHxS
qBA7pglF7Y+MWLAmRSdU8cIq4L1CWkegdjkBXl5hl/6LnVVRKWDocaD4q+V77N8=
=jZIq
-----END PGP SIGNATURE-----

--Sig_/6oAjylnzeVJ8Iwq36VL6.Un--
