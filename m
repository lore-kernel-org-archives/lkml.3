Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab3GEAPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 20:15:00 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36614 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756976Ab3GEAO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 20:14:58 -0400
Date: Fri, 5 Jul 2013 10:14:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Chen Gang <gang.chen@asianux.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>,
        David Sharp <dhsharp@google.com>, Ingo Molnar <mingo@kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        uml-user <user-mode-linux-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <trivial@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] include/asm-generic/io.h: add dummy fuctions to support
 'COMPILE_TEST' in 'asm-generic'.
Message-Id: <20130705101446.48deb2694f5fcdb060f41e5b@canb.auug.org.au>
In-Reply-To: <51D60D53.7050405@gmail.com>
References: <20130704011221.GA11230@kroah.com>
	<20130704061204.GA12148@kroah.com>
	<51D517A7.6030908@asianux.com>
	<201307041125.15083.arnd@arndb.de>
	<51D60D53.7050405@gmail.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__5_Jul_2013_10_14_46_+1000_kB3i6zl_LFiy4QIC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__5_Jul_2013_10_14_46_+1000_kB3i6zl_LFiy4QIC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 05 Jul 2013 08:03:31 +0800 Chen Gang F T <chen.gang.flying.transfor=
mer@gmail.com> wrote:
>
> When a module select "COMPILE_TEST=3Dy" (e.g with allmodconfig), it has
> right to compile under the architecture which no related HW support.
>=20
> If it can not pass compiling, at least it is not the module's issue,
> neither the architecture's issue.
>=20
> We have to look for who has duty on it. At least now, it seems only
> 'asm-generic' can be qualified to play this unlucky role.

You keep saying this, but others have told you that this is not the
problem.

> Could you provide your suggestions or completions for this issue ?

If something doesn't build for a particular config, then either it needs
to be fixed or excluded from building in that particular config.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__5_Jul_2013_10_14_46_+1000_kB3i6zl_LFiy4QIC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR1g/7AAoJEECxmPOUX5FEIOoP/2upNxgVTxrkcD/WNdhqRgHw
evMRhm5jZFN5jAfRXzdOkv/Xnvhbxjal/y9LTZ4SGB10t9LaJhllHiKmPvrlcuwr
oBshZouX0Heco4vBGsjkYWiXFlV9F5h76diD8yqoIsOqVbzF6vG5mVGte7M2k/uk
kJtwzBiISJcaV7I3ZFPV8Kw9keFB7+4wdzxqsw6qCV5w3UqZLm0mMwfWn1ID7DD/
U8jaGXkpLNPUFucXG1K4HryntrbrBG+wkzzDvoPFOfcxjGilgmbVvmOA4XShkMkz
uAB8H5USuxQpqXMQzRazJS5W3wniOj8gPCd5DTynKF64J/OuAH0SDTrM9+YYUS3u
UdgfDbLSPLtGIrpWTsL/bdwtFdilNUdyp8g/fngpK+Bj1oK2mSYgew36JZqv1AE3
PSzyHvqc0ky8/y+3p4g/uur4DXGq/ywqL9ZJrNIbcfIw9fO6dC1Uq45Spk99W3O8
NpVzTKNNnoHyEEGsNKgJBSUX3eb+66sfLdpiRtMT4otS4OhhR2doGPH3rNw+ai2v
We+hzCTJ+c/gavDVxlKIhTyDjjCHWTP4rhC3O/43O1HWT4vT226hc2WWKz/RRiow
qYggUPaw9PbxzyT24txM5skGP0R0HKz6I381mZ9NeqOsIX6Q89bCw9krrQK1CGOW
ErA2Pqmmys9by0p+gAxt
=fNxR
-----END PGP SIGNATURE-----

--Signature=_Fri__5_Jul_2013_10_14_46_+1000_kB3i6zl_LFiy4QIC--
