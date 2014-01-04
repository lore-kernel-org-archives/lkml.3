Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbaADPjD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 10:39:03 -0500
Received: from ozlabs.org ([203.10.76.45]:47327 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbaADPjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 10:39:01 -0500
Date: Sun, 5 Jan 2014 02:38:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/3] kconfig: consolidate arch-specific seccomp options
Message-Id: <20140105023853.dda6c1f9c6f9875159634e69@canb.auug.org.au>
In-Reply-To: <20140102202014.CA206E9B@viggo.jf.intel.com>
References: <20140102202014.CA206E9B@viggo.jf.intel.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sun__5_Jan_2014_02_38_53_+1100_pW+nGXcN2tl_66XS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__5_Jan_2014_02_38_53_+1100_pW+nGXcN2tl_66XS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Thu, 02 Jan 2014 12:20:14 -0800 Dave Hansen <dave@sr71.net> wrote:
>
> From: Dave Hansen <dave.hansen@linux.intel.com>
>=20
> There are 7 architecures with "config SECCOMP".  They all have
> virtually the same help text except for those referencing the
> /proc interface which was removed in 2007.
>=20
> There is *NOTHING* architecture-specific about SECCOMP except
> that the syscalls have per-architecture definitions, like every
> other syscall.  It is absurd to have the option in the
> arch-specific menus.

You seem to have (mostly) lost the dependency some of the architecture
versions of config SECCOMP had on PROC_FS ...

--=20
Cheers,
Stephen Rothwell <sfr@canb.auug.org.au>

--Signature=_Sun__5_Jan_2014_02_38_53_+1100_pW+nGXcN2tl_66XS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSyCsSAAoJEMDTa8Ir7ZwVcSQP/RuONn+HzaPnZBJc83TSfVHX
0AOwuNeyqOn8olC21RsGWLiHGYEVq7vt4UaaJw01gaEH7IYYamcqXBPeneDHkYSf
cNLPZkSRRbjHOtwAI5MMbJ5XvMrSGDZ9FXS1LBVmVie/zJY4w44gVizouMcVeHfx
4rxTFzGXk/vNsC5kCGDi5a9D0DqVkn6VCmICkroCrqpaENc7URN+dzwAbJZE4RAO
67Pp+38AGNwHr8st7mECDXTDlb4Oj6BfA1IIK/XttC8PvQrKxmFWAqR+EETh694R
hACy0Rn74G3bs+qmHeCb3Yfj0VKUnBSFc2Yn8sWfAuKpeZvtdiWeEAGWX+8RzkHK
xrTgv/KDvBdDsDuoXs9k2+9C6AjdwEnS6ySUGnmcJD4c9CwrOcMg58sS5OX3mtXk
lLnm+v7qiQiv+AOzVcszB9sm0blA0eZOgC79q6EPxElyC/rhzwnaoqoZkwHtI8Pr
/uhg8OJJ5dObfYYQw9qPlMJzV3Q31BJyEOvxqLfafcA6vfxj0slLXau4h53cZUx/
ArPcCg5tcbg7PFZvGrj6o9p5oswXVikS6snvahmzyVnoNFR+oFOOrDwg3vJmbhfr
6yrP5+nrddkjLqGNSWqjPePPtFTg50+ENvuLQS4zpXaOTENGTtq54Qrz1JxlGEEm
JaZNFVuMZHI0lXwx6Px8
=qYy3
-----END PGP SIGNATURE-----

--Signature=_Sun__5_Jan_2014_02_38_53_+1100_pW+nGXcN2tl_66XS--
