Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbaEOQNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:13:37 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36058 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411AbaEOQNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:13:34 -0400
Date: Thu, 15 May 2014 11:13:23 -0500
From: Felipe Balbi <balbi@ti.com>
To: =?utf-8?B?6buD5L+K56W6?= <steve.huang@climax.com.tw>
CC: Mark Jackson <mpfj-list@newflow.co.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: AM335x host only USB
Message-ID: <20140515161323.GG7360@saruman.home>
Reply-To: <balbi@ti.com>
References: <528DE96A.6080903@newflow.co.uk>
 <CAF3EQkSrpf-9Ezf5Y7htfaQAEfN9PDV=CUxS_h9peKjawDhUSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vJguvTgX93MxBIIe"
Content-Disposition: inline
In-Reply-To: <CAF3EQkSrpf-9Ezf5Y7htfaQAEfN9PDV=CUxS_h9peKjawDhUSw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--vJguvTgX93MxBIIe
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, May 15, 2014 at 03:23:14PM +0800, =E9=BB=83=E4=BF=8A=E7=A5=BA wrote:
> Dear all,
>=20
> Is any update here?
> I'm looking forward for your reply, thanks.
>=20
> Steve
>=20
>=20
>=20
> 2013-11-21 19:07 GMT+08:00 Mark Jackson <mpfj-list@newflow.co.uk>:
>=20
> > We have a custom AM335x CPU board with a type A connector, which is
> > intended
> > to be run in host-only mode.
> >
> > Using Linus' latest git, I can compile a part-working kernel that can
> > detect
> > an (internal?) usb hub, but is unable to see any devices connected to i=
t.
> >
> > Here's a snippet from my boot log:-
> >
> > Starting kernel ...
> >
> > [    0.000000] Booting Linux on physical CPU 0x0
> > [    0.000000] Linux version 3.12.0-10713-gf9a173a-dirty

pretty old kernel, friend. You know we can't really support you on such
an old kernel, right ?

In any case, try to backport commits:

943c13971c08ddeb06f4cb9dea1addb76f6b4423
2df6761e5eca9a810050a15062ae8abce1bbae41

and see what happens. I'm assuming you didn't ground ID pin, since
you're using a standard A receptacle. I suggest hardwiring it to ground
anyway.

--=20
balbi

--vJguvTgX93MxBIIe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTdOeiAAoJEIaOsuA1yqRE0NcQALMRMMQ29B8TK2Pi9VH1Te6H
kGtt+5cZz/o6nRKpiRmzcHSeLGegZRmmMqLczI+8LzLyvGjJqyFI+g+YUJDTACRo
CvR9qA3WW1tJXHRr1j7uvthUlFuWNeD9Ra8hAv6dnTGrw2JB0pQCfZwIVOVzhdqh
7acjZoV6nar2l9rY8pbBjtNa+zBhEXjkt4g1uRYRtPVwBge3Blo+9kYv4bWhhqme
94x6eqI287Kr/EzzgpIgoFr4Q+nlOQFIM23pSjHw8WQLHPJAjBgqFUqQdcYce+eW
xjFLQSdRey+wxcasfGc9+TrDTt9+lFURiHN4Ie+6ARPYbdwGgatPH3sS+O4IPCuX
UpXWZWMvX9o/sOCTZYNDR5H94IHBVpyEk/rG2fq0335mQCBsislT8EhGEmjtmK2B
WdSEaSssqKYOZxYsoj+qQ3dq9+5WDEXsvc+ISi84Y3+qdIbB+GCD0UXgUqciYCpw
GuMSawk/QqnPF+qRyTqom48pyCajqFFXiJqbsoor6WIhsUcyFFpZ0joindLzvQfk
mCHANKtIxTDcuDxXMqvw7+cMys54qCW71OgvDIAhJkdZBReQh6O07c2lI2A45cv6
WvjkgRsa9HMPflXzJaQKJiCzEcu9rOAZinJmvAwR3ZTaQMNXz+EUD4Rd+jz4KcEV
L9onSlrnoylIbLysE+lv
=avHa
-----END PGP SIGNATURE-----

--vJguvTgX93MxBIIe--
