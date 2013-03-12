Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab3CLMdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 08:33:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41527 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab3CLMdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 08:33:23 -0400
Date: Tue, 12 Mar 2013 23:33:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: James Hogan <james.hogan@imgtec.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-next@vger.kernel.org
Subject: Re: [RFC -next] linux/linkage.h: fix symbol prefix handling
Message-Id: <20130312233300.9d86d47bb5369923ad520a21@canb.auug.org.au>
In-Reply-To: <87ppz5usts.fsf@rustcorp.com.au>
References: <1362656642-2693-1-git-send-email-james.hogan@imgtec.com>
	<87sj46wyf2.fsf@rustcorp.com.au>
	<5139AC39.90805@imgtec.com>
	<874ngiwije.fsf@rustcorp.com.au>
	<20130311230731.0c610d86569d09f6e23b8e61@canb.auug.org.au>
	<87ppz5usts.fsf@rustcorp.com.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__12_Mar_2013_23_33_00_+1100_DFkOzlM2uo73ZOmL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Mar_2013_23_33_00_+1100_DFkOzlM2uo73ZOmL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Looks partly better.   You seem to be using
CONFIG_SYMBOL_PREFIX_UNDERSCORE but selecting
CONFIG_HAVE_UNDERSCORE_SYMBOL_PREFIX.  One trivial comment below.

Maybe this was an unfinished version of the patch?

On Tue, 12 Mar 2013 15:18:15 +1030 Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
>
> diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
> index 600494c..314ee6a 100644
> --- a/arch/blackfin/Kconfig
> +++ b/arch/blackfin/Kconfig
> @@ -45,6 +42,7 @@ config BLACKFIN
>  	select HAVE_MOD_ARCH_SPECIFIC
>  	select MODULES_USE_ELF_RELA
> =20
> +
>  config GENERIC_CSUM
>  	def_bool y

Extra blank line added.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__12_Mar_2013_23_33_00_+1100_DFkOzlM2uo73ZOmL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRPyB8AAoJEECxmPOUX5FEWmQP/j4PPUCPgSE0nl/oO0CFQUKV
lzF0X2NJFVeOMbzIzBRbItbRm8LivU/Sw+W6u3i4rFZhANIzy9SN0F47au8IdR/+
c3/qE6G6KUzBRL0PdM3020AtVKL34afqErHRApYjPjCTKJjnDcTFlkKlDej5Y1h8
Rk/hCI4/rs+Flu2O+VnSIXVPxlJ/zmkrnNG/Z9KnJSqb4IsaF3BKbFE+cEknvx1t
7L4VbhcXFRdYQPRPIySnKL7TYpj/HejYQLFM2C0F6NvnsDBvIv3Yh62f3+nKmvyq
sPiShjxdypkZMMelnD1ntfcOWQvBwkWnvUttRPEw/CoeToWH8d4h4s5llrFgMyaP
xKOPFTpL2JxXdvMc29L9I1A2I8ZqyJvyhl0uAcpoHeh2sKWruIpMeoPf3lxe6llp
QmxhmEtCb3XhWKWJ2JNq5p7XXWLyu6pnPmACvDUqnEVwCm24oLbuvx0R++whJqB0
Ip6yQOD8az3hBKUKZeH9tZCli4XdgHJpw2IxfdLpVVAutKE6rB4wHtxpLGYUYoTc
qdpkVbV5RDegpZ2C2BPjYeQFzrO7z4pjWkswYpYiG24ATdEPokK9qlCTnuDCY970
PZjbVQ9aS9ZeC3RNWxf/8gk3cken4Ug0llXS8zbVpkqB9Y70YVNaEWRh54HGOhXP
+IlRL2ZDSSNyJ4jHMeCU
=mSBB
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Mar_2013_23_33_00_+1100_DFkOzlM2uo73ZOmL--
