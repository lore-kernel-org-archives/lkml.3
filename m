Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3HVE4B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 00:56:01 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58190 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab3HVEz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 00:55:59 -0400
Date: Thu, 22 Aug 2013 14:55:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Richard Weinberger <richard@nod.at>
Cc: linux-arch@vger.kernel.org, mmarek@suse.cz, geert@linux-m68k.org,
        ralf@linux-mips.org, lethal@linux-sh.org, jdike@addtoit.com,
        gxt@mprc.pku.edu.cn, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-mips@linux-mips.org, linux-sh@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net,
        Ramkumar Ramachandra <artagnon@gmail.com>
Subject: Re: [PATCH 1/8] um: Create defconfigs for i386 and x86_64
Message-Id: <20130822145549.7d2de2bd1209fdc850df3198@canb.auug.org.au>
In-Reply-To: <1377073172-3662-2-git-send-email-richard@nod.at>
References: <1377073172-3662-1-git-send-email-richard@nod.at>
	<1377073172-3662-2-git-send-email-richard@nod.at>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__22_Aug_2013_14_55_49_+1000_BCiP2jO/bmXN.v6F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Aug_2013_14_55_49_+1000_BCiP2jO/bmXN.v6F
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Richard,

On Wed, 21 Aug 2013 10:19:25 +0200 Richard Weinberger <richard@nod.at> wrot=
e:
>
> Instead of having one defconfig for both i386 and x86_64
> we have now two.
> This is the first step to get rid of SUBARCH.
>=20
> This patch is based on: https://lkml.org/lkml/2013/7/4/396
>=20
> Cc: Ramkumar Ramachandra <artagnon@gmail.com>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/um/configs/i386_defconfig   | 954 +++++++++++++++++++++++++++++++++=
++++++
>  arch/um/configs/x86_64_defconfig | 943 +++++++++++++++++++++++++++++++++=
+++++
>  2 files changed, 1897 insertions(+)
>  create mode 100644 arch/um/configs/i386_defconfig
>  create mode 100644 arch/um/configs/x86_64_defconfig

Can these still work if put through "make savedefconfig" like other
architectures defconfig files?  I did a test and they produce files that
are only 74-75 lines long and the resulting files produced the
same .config when used in place of their originals.  But I only did that
test on an X86_64 host, so I just don't know if there is some strangeness
of um that would stop us using them.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__22_Aug_2013_14_55_49_+1000_BCiP2jO/bmXN.v6F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSFZnVAAoJEECxmPOUX5FECykQAKVdAw7YgUXXddRw5aV5pmAy
NbV0hO6Ier1fY06b+DTdFHXEokRtDxQBqLzxS3DjjQK4c8qjyiwpdJOu7PM//wxv
NRKtSrI1S6idf0bJJ+Z4n9t+FxlE41bxusf7/mUt6E4s8HFwYvGgpZ8/QUuPLGqY
mocdz9cxpqfJehtiC8zG7BBH/Lw+y3LyXf12Eyjq0IH41qPICl+sX0D0M/tRCdhI
gr2lGiq/N8KbtT86RnMI1n82D3JlM6wFgjt7OTozNgeHnYFOrW82LDWQFfstWuqg
D4X2sGShjq1T6dKXDTtAKAE/BsmQ75UVSCfCJz2HV92KUH/heBs0g2uU2gnGREv/
5dSRMCsSeRaKPOZCUQR3gll43u/Es90algPNEPQc3fwpataeQu0qeZxGrDm+6j48
Qt9P20WJVWd/yF8QRsM0IwgFXuHJQdzvHz4dm6NJdRNRCgllT/rL3AjkcnUmD/jV
uSXGD+WHgky45KIL3jofpZNNmllUn3KLJJN8AS45oZqBWoIRRAQv19287SnMUNav
kq0ThN7zXMV5bS2xb1t1CHnL5ir/6xoVow8P/d+0To6vQFJhGjlnm2YwXDx0qRqs
aNPVSiS+STbr915+8jObTSLF9zqEpXgw14B6uL0Zn+tnlMXYKy/CvO66iM9qdutj
qQDs44nuuEim20i4E0EX
=mHOY
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Aug_2013_14_55_49_+1000_BCiP2jO/bmXN.v6F--
