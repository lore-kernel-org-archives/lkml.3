Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762617Ab3IEAlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 20:41:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34382 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758175Ab3IEAlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 20:41:09 -0400
Date: Thu, 5 Sep 2013 10:41:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [GIT PULL] x86/asmlinkage changes for v3.12
Message-Id: <20130905104105.69ffbcad99d88ebdc3e79661@canb.auug.org.au>
In-Reply-To: <CA+55aFxVv==DC0JdS87V+cPr-twN+TujYg5XmgHOjJOAkZ4xwQ@mail.gmail.com>
References: <20130903143921.GA28290@gmail.com>
	<CA+55aFxVv==DC0JdS87V+cPr-twN+TujYg5XmgHOjJOAkZ4xwQ@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Sep_2013_10_41_05_+1000_0H7r3sCZw_6E/1Xf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Sep_2013_10_41_05_+1000_0H7r3sCZw_6E/1Xf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 4 Sep 2013 08:58:25 -0700 Linus Torvalds <torvalds@linux-foundation=
.org> wrote:
>
> On Tue, Sep 3, 2013 at 7:39 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Please pull the latest x86-asmlinkage-for-linus git tree from:
>=20
> Grr. This one seems to introduce this annoying warning:
>=20
> arch/x86/kernel/paravirt.c:66:0: warning: "DEF_NATIVE" redefined
> [enabled by default]
>  #define DEF_NATIVE(ops, name, code)     \
>  ^
> In file included from
> /home/torvalds/v2.6/linux/arch/x86/include/asm/ptrace.h:65:0,
>                  from
> /home/torvalds/v2.6/linux/arch/x86/include/asm/alternative.h:8,
>                  from
> /home/torvalds/v2.6/linux/arch/x86/include/asm/bitops.h:16,
>                  from include/linux/bitops.h:22,
>                  from include/linux/kernel.h:10,
>                  from include/linux/cache.h:4,
>                  from include/linux/time.h:4,
>                  from include/linux/stat.h:18,
>                  from include/linux/module.h:10,
>                  from arch/x86/kernel/paravirt.c:22:
> /home/torvalds/v2.6/linux/arch/x86/include/asm/paravirt_types.h:389:0:
> note: this is the location of the previous definition
>  #define DEF_NATIVE(ops, name, code)      \
>  ^

See thread here: https://lkml.org/lkml/2013/8/19/12

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__5_Sep_2013_10_41_05_+1000_0H7r3sCZw_6E/1Xf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSJ9MiAAoJEECxmPOUX5FEg3gP/Al7dEcR401lwuBK9TwR4ckM
eEa+2j0Va3J1j2EoqVHhepNBafkXfSbut091YzsiK+1TZRv6G6my6Urk11Nh9dmX
PQEt3ZOzklEBP+PjZtzNmKfGVV6fwhyM3D6By6d9OqTYjzOtmOhrPIVtYZBA3WR/
jpz9/CKNIm+CKM6mVDy4tIwp9/sdNjDpO/VkPWClabZy7K585a11UZmRdcacFLsA
pGr2gYFeZUov2EhPS28PcdA3el9LNAP3beFNUl8EBe/6K973KXM0OkVtIhkfAA/i
0IZYulAzpxGP3dyHXFCZEV7WzfS6ApybosXc63RO6+7FhFbBgQwG3aM+nUEz5XTv
Nn0jxzV+dsPrATV3AtpVRgpH6UXhBdMgOnRExQYPfMa0p1WAJ7xKvTUGd3EBGmAu
8CV1VjpPL+Yv6Rcfb2IHeLuPt64knJIl/geSbxQ9fUZA0D/xODQl8KHJ5EdCasWn
lnMHHUIDYAUHxLCmpxp6wJ6ycuyMLtxy1WJhTftBnww2FnrdTKPqKxyiHwVJUuyC
QRML2SAaKe0yqiqxNu3XoEmbNxgMCuE9QbElt1ayigD6jjkwJiEjFZaoDSIW1jMu
4icSZLB7WVDtgsIw9ZWhCxfh2xL3yTrI4xJdqJ+dPsIe67KnAo4sXrAGBl39U+o8
uOZRxwIlxnqG+Wghaxvz
=GNFm
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Sep_2013_10_41_05_+1000_0H7r3sCZw_6E/1Xf--
