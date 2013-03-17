Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab3CQTdm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 15:33:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48739 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801Ab3CQTdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 15:33:39 -0400
Date: Sun, 17 Mar 2013 21:33:21 +0200
From: Felipe Balbi <balbi@ti.com>
To: Dongsheng Song <dongsheng.song@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Linux 3.8.3
Message-ID: <20130317193321.GA15102@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130314184702.GA17860@kroah.com>
 <CAE8XmWoYXyNFQ14e6X+2rkWQyRA=kSdc4J+DNu2Sv+6e9rvZRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <CAE8XmWoYXyNFQ14e6X+2rkWQyRA=kSdc4J+DNu2Sv+6e9rvZRg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Mar 17, 2013 at 10:00:08PM +0800, Dongsheng Song wrote:
> On Fri, Mar 15, 2013 at 2:47 AM, Greg KH <gregkh@linuxfoundation.org> wro=
te:
> >
> > I'm announcing the release of the 3.8.3 kernel.
> >
> > All users of the 3.8 kernel series must upgrade.
> >
> > The updated 3.8.y git tree can be found at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le.git linux-3.8.y
> > and can be browsed at the normal kernel.org git web browser:
> >         http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable=
=2Egit;a=3Dsummary
> >
> > thanks,
> >
> > greg k-h
>=20
> Hi,
>=20
> =E2=80=9Cmake ARCH=3Darm menuconfig=E2=80=9D  no complains,  but "make AR=
CH=3Darm
> CROSS_COMPILE=3Darm-linux-gnueabihf-" failed:
>=20
> $ make ARCH=3Darm CROSS_COMPILE=3Darm-linux-gnueabihf-
>   CHK     include/generated/uapi/linux/version.h
>   CHK     include/generated/utsrelease.h
> make[1]: `include/generated/mach-types.h' is up to date.
>   CALL    scripts/checksyscalls.sh
>   CHK     include/generated/compile.h
>   CHK     kernel/config_data.h
>   Kernel: arch/arm/boot/Image is ready
>   Kernel: arch/arm/boot/zImage is ready
>   Building modules, stage 2.
>   MODPOST 1904 modules
> ERROR: "flush_tlb_kernel_range" [drivers/staging/zsmalloc/zsmalloc.ko]
> undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
>=20
> Please find the attachment with .config.gz file.

linux-arm-kernel might have more information about this.

--=20
balbi

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRRhqBAAoJEIaOsuA1yqREqcgQAKTTuiLLEBs7Q7swrcOtDRD4
IoV/M576Cjn1b1yOSXA1zZyIm5So7V4/CnS+dHfGjavQU4/U1Pg2Dno+++Uo8gtH
bIP0pRGa6b9FgjVtPvA8qqSkFu92VYHd+jZv/w+xTaCHKDR3WjBWp2CIQ9LhmhyH
MmCxZS8ell7lqrXypjypg2hBFNUMyx5umhVLsrY1rHyqTczjgB6+Gi8e7obXlYlC
weoYsVluKZIWk3HTJZKmSK6v4T0VAW1yHq3tMD3SVSpFNDWDBylg1uRrQoC1KQY/
pq93z7ucD4fxdQSALwdc8Js5RJBP/aGC7CNCKO2Pv5/zDYKOxtjMuBoapE9C8f9O
YDEfN1LllrZSZB8R9yhoWL8MKBiboBBHJJIEiw9A+7sque/IFergk2BO3NntMaBv
4SEeKLxZTXJ7tUbi8Mj4OXEIsxKm2nbwlkwnQEZeNLWSJ9oqkh7UosY6M+9bmeFu
vCiWETqVyOlsAkaRIzB303/W7pBXqeBe6hLJWXWm/jMceWZgTeHjidSraJKDGlVj
QxKbTenWdb8ySUuAPYU+Vb9cD77kRtCv4DpbRbqCF4DlXdAci02fpGXB5wNhPTJu
+Zc/TWjFxhdC5WWLk552QmLzIMy/dDheXXM9tFau+zbHJ02pKOKuRIM5PpsAlJOv
z5BwC8UfBW/byJnWZe9h
=TYmR
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
