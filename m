Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbaBQDOy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 22:14:54 -0500
Received: from ozlabs.org ([203.10.76.45]:52729 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbaBQDOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 22:14:53 -0500
Date: Mon, 17 Feb 2014 14:14:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the mfd-lj tree
Message-Id: <20140217141446.454ab86eb19621fd397be6ed@canb.auug.org.au>
In-Reply-To: <20140214134217.aa7e1994b4cab7ee563c8307@canb.auug.org.au>
References: <20140214134217.aa7e1994b4cab7ee563c8307@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Feb_2014_14_14_46_+1100_i6pUEJqY/xg+4.c5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Feb_2014_14_14_46_+1100_i6pUEJqY/xg+4.c5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Lee,

On Fri, 14 Feb 2014 13:42:17 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the mfd-lj tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> In file included from drivers/mfd/max665x.c:19:0:
> include/linux/mfd/max665x-private.h:31:1: error: expected ';', identifier=
 or '(' before 'struct'
>  struct max665x_dev {
>  ^
>=20
> Caused by commit e77bb5297293 ("mfd: max665x: Differentiate between
> MAX665X devices").  Clearly never built by anyone :-(
>=20
> I have used the mfd-lj tree from next-20140210 again for today (since the
> other version had other problems).

Still seeing this error.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__17_Feb_2014_14_14_46_+1100_i6pUEJqY/xg+4.c5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTAX6qAAoJEMDTa8Ir7ZwVfU4P/0s5/BSMyGQhHixBqtCKFtcV
BD2sYxKJ8rKK3vmZQtoml9lkW1Rq906VB8H4bgJfrl66hYiOdvbftkk4eamiwKOL
u3xZQGwM30+GEE06ohvEN3o/mz8DTEGTSeA1GNkM3r0yZG3ZUzw2Rf8365mo7CaW
0QMddAV7izd3LFiadotx9rpD2SselNWiJUTRcRO0grqcn5SNZAmux/V/qjmxhu1n
/V7OckDUTzd/0doQY9Hy6XX0o6B8W5/2GooK//7o6+gm2SoGuPKzrijWjR3ByU10
B1qbUnBrwd7kLs2kZ3bSapuYh16tsCHGtVom59wWbWo0V+u7EwjhTFvs2LKGmXKr
DFE9ZmwSj3cugl+vZAkxIC0chc8yIdHGKZgo1ad6TAtQmjTNX6QJ6BPzg36wvxS8
wgvl49iNaJersy/j33SGLUQPH8hB2eu17kJ9fsOIsMAfVskJ2ennssmPsUtIOhL+
1XiRbS8sZA6wtIZ+VV+fVy0izXwrObSGiGIMu7GGLKpPiQLZJyGfwg3pZBSBt+9T
XTUiBVLR1MgJhr5P1mvPbNj7Od4l2FttC773ZEmaXBn8+q3pYk6/TJuzz4L43qWD
EfcDJ4+CQ+dkJ6HlTnycodi4EfogO1+zatWsTUiGioid2lcZx575HxgLKUHaTuLB
TbiLOBbEwMNU390XGgTB
=fIB1
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Feb_2014_14_14_46_+1100_i6pUEJqY/xg+4.c5--
