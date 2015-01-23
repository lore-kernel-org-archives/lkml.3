Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbbAWTyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 14:54:33 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:53630 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbbAWTyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 14:54:31 -0500
Date: Fri, 23 Jan 2015 13:53:40 -0600
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: perf not capturing stack traces
Message-ID: <20150123195340.GF26557@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
References: <20150123195128.GE26557@saruman.tx.rr.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mrJd9p1Ce66CJMxE"
Content-Disposition: inline
In-Reply-To: <20150123195128.GE26557@saruman.tx.rr.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--mrJd9p1Ce66CJMxE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jan 23, 2015 at 01:51:28PM -0600, Felipe Balbi wrote:
> Hi,
>=20
> I'm using v3.19-rc5 on an ARM Cortex A9 board. Unfortunately, perf is
> not able to capture any stack traces even though I CONFIG_STACKTRACE,
> CONFIG_FRAME_POINTER and CONFIG_ARM_UNWIND all enabled.
>=20
> I wonder if anybody else is facing similar issues.
>=20
> Here's console grab:

perf features:

Auto-detecting system features:
=2E..                         dwarf: [ on  ]
=2E..                         glibc: [ on  ]
=2E..                          gtk2: [ OFF ]
=2E..                      libaudit: [ on  ]
=2E..                        libbfd: [ on  ]
=2E..                        libelf: [ on  ]
=2E..                       libnuma: [ OFF ]
=2E..                       libperl: [ on  ]
=2E..                     libpython: [ on  ]
=2E..                      libslang: [ on  ]
=2E..                     libunwind: [ on  ]
=2E..            libdw-dwarf-unwind: [ on  ]
=2E..                          zlib: [ on  ]
=2E..     DWARF post unwind library: libunwind

--=20
balbi

--mrJd9p1Ce66CJMxE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUwqbEAAoJEIaOsuA1yqRE70gP/ik1JTbPVYndFobQxC3v3KbJ
xpdH0eBR8NeUIEfpqlpe86mQcc9WX+V3LZ6CZlt5VlIgMKP28pHIwwsW0clYQYfn
nkIMIrjFbL1mm+sLm9HlRKUynafogNnElo2Wij/M0UlcjsxHVhX+M/IZ5LHx4i+j
VpQlB9evH2oCG03S63BOL8az8vdqZyZ6uV1yvM4YT2xPVnIZSNIBWxDsWZHEnvFb
7A2RECvDj9I2dluUK/a5ZW1X1rAh/3JCOZJ92SFAjCLupoARwjzUco7IwfOsxzf1
lDjxzM7a2uLNcQ8dprpqoFw/uaegNV7UwuMaW9HpQk1xeqadn7tdgzfuodmY0qMd
qIkWVmJLZZbUz9HRTHNDFw3OtUiwZ7p4QniPxHBVGa78ocm8H/v+41I9AraQrpKs
w0wieC+wD8Ix5wuKcxQNLZm4nWvslr3Qx1rDo7urEGnLGHxOhETSrk3CIOjgfY9b
JsimGjuTPvT1IjKJczjLgFtioRASKIClEqnL39gzA7sn1IHVN/MUb4bEFQNc495z
W00n4Yb9z7UaHk7eKUE/WdZXix1hd2qpd3SXmQAmC975R7gtFIKc1FGnFrGMhon4
cN9BK/Rn+tgL9ZcJwbOeBCjGHfHVcId1ikNCphtVhJkUylZ3EYy8j+vr4jDqwxlz
DTRfnUd+tPhxg+9slYwf
=izn+
-----END PGP SIGNATURE-----

--mrJd9p1Ce66CJMxE--
