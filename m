Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab3CLFqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:46:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59724 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab3CLFqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:46:08 -0400
Date: Tue, 12 Mar 2013 16:45:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Li Zefan <lizefan@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: build warning after merge of the final tree (tip
 tree related)
Message-Id: <20130312164558.f352a1189f8c99ab73518002@canb.auug.org.au>
In-Reply-To: <513EBA25.8060106@huawei.com>
References: <20130312154215.f9c3e957c2a2e510f27b826a@canb.auug.org.au>
	<513EBA25.8060106@huawei.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__12_Mar_2013_16_45_58_+1100_2=97eZlAb1iF.tQk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Mar_2013_16_45_58_+1100_2=97eZlAb1iF.tQk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 12 Mar 2013 13:16:21 +0800 Li Zefan <lizefan@huawei.com> wrote:
>
> Should be fixed by this, and it has been queued in tip:sched/core
>=20
> Commit-ID:  b719203b846284e77f5c50fca04b458b6484aeae
> Gitweb:     http://git.kernel.org/tip/b719203b846284e77f5c50fca04b458b648=
4aeae
> Author:     Li Zefan <lizefan@huawei.com>
> AuthorDate: Thu, 7 Mar 2013 10:00:26 +0800
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Mon, 11 Mar 2013 09:07:24 +0100
>=20
> sched: Fix update_group_power() prototype placement to fix build warning =
when !CONFIG_SMP

Good, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__12_Mar_2013_16_45_58_+1100_2=97eZlAb1iF.tQk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRPsEWAAoJEECxmPOUX5FEntAP/R/h9qxTIuI32DxGJcPAc+c6
SApj3hbPd1Jc4EJuFA5SsdnqOcmoOkIwczpC1ChH28fFwFNoZEXbGQ2FG0HUM2r4
1iRaOCY4Ql0CtfJjBZd6MzGEwCi6CzdmogMQeB3UKn7oAtjWTpXSJ6OmsedNKi8t
QqENFZ6eeusIoydcYb0tyZQQLIY54aTpXtLMeGcuQpGDSsD99eP1Et95LnO3xI5h
ZB1uTNC2vjbS9V/mngq96nsaN5Gkc4KYibCiEHWPoFdu5B3/3f14PSDIQDdrE6h0
zEnFhJEY0E7aXJTh3ucf6JcxEkBvToghR1UcZbkBsEKa8pQ22naSYKOadawTWaa5
/4E+g/Wnu5NDx+6ZPoLUBRlAPNpx+Jb2rJ3cYlrRcGcGDHsFbUxqbgxgjCAM2apR
SF5H1ucqzAoNHh6l2/Hys+0OMSaTaaXmD70Iif/wexb8n7nNGGpD2j0zP3A2lBWv
tZT4QRKqrs47TzNnULc7woXP6enjjVFWxDHcJkNG31KF8uwHAe8z1+ym/RrZFspu
x4SUO5k/zLTqEyUnLg9zrzpi9Gbf85xg1IZwuDm7VLq51hYeEYGTtRbvETCEEXzR
qP54tv5dbomgI1Y2HLEL7bc57tZnCG+Hh3Gb38MqC2i0jktWwlxhZieo6+NC4kQS
I63ZocuRpd/robFe6wzm
=36UW
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Mar_2013_16_45_58_+1100_2=97eZlAb1iF.tQk--
