Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaHJBVi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 21:21:38 -0400
Received: from ozlabs.org ([103.22.144.67]:52008 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbaHJBVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 21:21:37 -0400
Date: Sun, 10 Aug 2014 11:21:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>, YoungJun Cho <yj44.cho@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        satoru takeuchi <satoru.takeuchi@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>, stable <stable@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 3.16 00/17] 3.16.1-stable review
Message-ID: <20140810112127.60b195b7@canb.auug.org.au>
In-Reply-To: <CA+55aFw=1YEfa+J5xLMbSycT4YBvEmgbDGN62nD1AL9-q1NPoA@mail.gmail.com>
References: <20140808213457.511493898@linuxfoundation.org>
	<53E57279.1030106@roeck-us.net>
	<20140809034911.GA2348@kroah.com>
	<20140809034950.GB2348@kroah.com>
	<53E5A0D1.10507@roeck-us.net>
	<20140809141609.GA21639@kroah.com>
	<53E63871.5040504@roeck-us.net>
	<CA+55aFwFMFgj2PqftqZLntjYkbm+pG8adJPMO+sD9=U67WOYkg@mail.gmail.com>
	<53E65747.9070108@roeck-us.net>
	<CA+55aFw=1YEfa+J5xLMbSycT4YBvEmgbDGN62nD1AL9-q1NPoA@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Sw.ZgDSXTB7Y4E6XVjLO=jw"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Sw.ZgDSXTB7Y4E6XVjLO=jw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Sat, 9 Aug 2014 10:43:51 -0700 Linus Torvalds <torvalds@linux-foundation=
.org> wrote:
>
> On Sat, Aug 9, 2014 at 10:15 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > ERROR (phandle_references): Reference to non-existent node or label
> > "disp_pd"
> >
> > ERROR: Input tree has errors, aborting (use -f to force output)
> > make[1]: *** [arch/arm/boot/dts/exynos5420-arndale-octa.dtb] Error 2
>=20
> Ok, so it's something else that was apparently known about in -next,
> but not mentioned when pushing to me. Oh well.
>=20
> The new disp_dt use was added by commit 5a8da524049c ("ARM: dts:
> exynos5420: add dsi node"), while commit d51cad7df871 ("ARM: dts:
> remove display power domain for exynos5420") removed the node.
>
> I'll leave it broken until the ARM people get around to fixing it.
> Likely by just removing the disp_dt line from the dsi node, but I'll
> let the proper people sort it out.

Yeah, that's the correct fix (it was even tested).  Olof has the patch
for you.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Sw.ZgDSXTB7Y4E6XVjLO=jw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT5skcAAoJEMDTa8Ir7ZwVKuUP/1kMxL+RFuBbwXe+kenGjjO3
taXDleTfshjE4TZ7wBnOPQA686guJaVo7b+Jbm3pz+DPggM7YzyMnqsP3V+TKGN7
Tj6Bf7D0N7dM65OPJkMYWQWG/56kd4Yf8Gft8FTftWjHlbk23uz8Au18yrke+DW4
tPaGKqunoBOkSNxzDGc+xRcszW64L0ZXrhpGHyy2LRIr34lVJfTXf7zR5X6uuLht
tIN/UHQBl7jCp5lkdE4LlHO8IZUm03yXYoExFV1IMF1ohHasXWib9EkGVjgDNGYy
xiWWsFJ7xVO7IEA/vV+e397DpYD76wgYp4wU6RAJ/1azvZrzYZVDCbmzHj0d6Yyp
lr+mj5BJ14b7wY8A3iUgdYzNmQcIVuYNkMpfNxGdDbeb1755BU7LSJX2YiF0lhTG
yZCRf8rb17XAzOzOojaWb8R95W0o6uwVnzGOhlZJsue0WWmkw1LqzH+hb3vsRVz1
Xe9/qMuIfJmkl4ukYQhqo5zRXWhZCSGDtWu7E1+Ek5joQkme+NeFaY9N6e8zTt9U
1zGAnzmDQl3yujgrlvg42Tsm38q0pqhJf4+/KQLEziDsnm6vCebCAkQkMAPpOzbj
Z0UJdj/LDRrWdQhK4Q6sKztAR8u8tW2HtqBXH99tNLtt/2C/hUWTAQ9wGeKNtfPe
HRTCalkbR0TIIpzUprIr
=fY6d
-----END PGP SIGNATURE-----

--Sig_/Sw.ZgDSXTB7Y4E6XVjLO=jw--
