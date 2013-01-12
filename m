Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab3ALBPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 20:15:41 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:57979 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550Ab3ALBPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 20:15:40 -0500
Date: Sat, 12 Jan 2013 12:15:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-next@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Request for tree inclusion
Message-Id: <20130112121536.c7c9371672bcf3afc5c2925d@canb.auug.org.au>
In-Reply-To: <CAFTL4hw-WM5ur6Z-1DPMMvregEJr_CfcaeBOHV-nawh+NKi+VA@mail.gmail.com>
References: <CAFTL4hxWdV96dO_KCOnvc4O1zutvnW6eGZ950d+qwnCSHb9NpQ@mail.gmail.com>
	<20121203094906.4cbfcfc0ad3f0319895a162d@canb.auug.org.au>
	<CAFTL4hzqqQPA1cd4uPoCd73d5rBj8cGpv=VnB6CrCpdjjwr1xw@mail.gmail.com>
	<CAFTL4hw-WM5ur6Z-1DPMMvregEJr_CfcaeBOHV-nawh+NKi+VA@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__12_Jan_2013_12_15_36_+1100_NW3TEch+AwaJCkBX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__12_Jan_2013_12_15_36_+1100_NW3TEch+AwaJCkBX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Frederic,

On Fri, 11 Jan 2013 02:15:39 +0100 Frederic Weisbecker <fweisbec@gmail.com>=
 wrote:
>
> fw-cputime and fs-sched have been merged so you can now remove these
> branches from next.

Done.

> But fw-nohz remains. In the meantime I have created a branch named nohz/n=
ext:
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
>         nohz/next
>=20
> This branch currently refers to fw-nohz HEAD (aka nohz/printk-v8) and
> this is also the place where I'll gather -next materials in the future
> instead of the multiple branches you're currently pulling.
> So could you please remove fw-nohz (nohz/printk-v8) as well from -next
> but include nohz/next instead?

Also done.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__12_Jan_2013_12_15_36_+1100_NW3TEch+AwaJCkBX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ8Lk4AAoJEECxmPOUX5FET/kQAItie0B3XZm8JUNFW5RgX3Fb
2MFN4T9Yi+AdIIIxupJS1wkwNb4ckfdrAitT92odje/zHlGYTjAemEsUoRebrQkj
hazaH/L+nWaX/c0g8dXcXcDH6W7ZwkrI13QqWRGcOJt0xFQvXx5aQzpQFBl8UpTd
xwXFi0t+Oi2lNGAfCtwaTPI2rMt4VNp2brfdgHKGXIRCjJmWUonI0BdntrSfWAtF
tg8znj2pEpG4Bw+cUUtmLqxQ+3iHBLko/1rfCnlo09vWf/Ecw8t4GugKS5wafrG3
YOM+0qggpJ/u3V9kJhe3stkoVO26rFLxiZk90zF8wdc+RoNZh6WBusMKlEsom6gr
6V0tMLvGcU1TNlarptjJi6Y8bKwg8VT5zjUQe7alacmUPYpRCVl8F0r91FOPAlYB
G79E+H6f26D77Fnb2RNth7dJFJiw/8fKdvyTe47BfNF8JHsK77EM355JUdsrO4Cn
eDoHFWuc1+OQkg8JRjZDZT2fTJ7CENVrsFBD8UYYgXcf31JD+l5gKikCLTOfX1Ui
xNIDK3bY9EJW9JvLq0VNvkgqta5PZqTaYmfhFnqdNNeNhMgiIGtLxANtSq3vjxuG
jH2HZWAkDUVeH1iaA3TLHKW5Tx0eLSnOZukBeRih3Vn6V0e4XVnEEsPCXMr9aGpk
HCFccxwXzd1SGMCWSwYr
=x0kr
-----END PGP SIGNATURE-----

--Signature=_Sat__12_Jan_2013_12_15_36_+1100_NW3TEch+AwaJCkBX--
