Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaBJDl3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 22:41:29 -0500
Received: from ozlabs.org ([203.10.76.45]:53472 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387AbaBJDl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 22:41:28 -0500
Date: Mon, 10 Feb 2014 14:41:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: Linux 3.14-rc2
Message-Id: <20140210144122.06eebad524fc0308bb2b8e98@canb.auug.org.au>
In-Reply-To: <CA+55aFwCWi5Ao7jSD-8anyLW=GP9t1H5J8YrQ4quES-ZY=z1RQ@mail.gmail.com>
References: <CA+55aFwCWi5Ao7jSD-8anyLW=GP9t1H5J8YrQ4quES-ZY=z1RQ@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__10_Feb_2014_14_41_22_+1100_HaXaIFZXDs9R9oRa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Feb_2014_14_41_22_+1100_HaXaIFZXDs9R9oRa
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

> Anyway, what little there was looks normal: roughly two thirds drivers
> (gpu, block, media, misc), with almost half the remaining patches
> being architecture updates (x86, s390 and arm64). With the rest being
> filesystems (vfs, nfs, ocfs, btrfs and some kernfs fixes), some mm
> noise, and tooling (perf).

Any reason that "tree-wide: clean up no longer required #include
<linux/init.h>" from Paul Gortmaker did not make the cut?  Google ate the
pull request?  Or just waiting a bit?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__10_Feb_2014_14_41_22_+1100_HaXaIFZXDs9R9oRa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS+EpmAAoJEMDTa8Ir7ZwVDz8P/0L/mro5LFIizlDALB5WWcC1
T/jkchfL7xeeI1wP3nMbILxvBXGAVlov686pD2f7z5NXv9SEbPKRrZgijiC+hnhy
jKTd4i5s6s5TvjaXCnYyTEAyVrlDHo2VpQZQ/J8OUiEUPh5bJuFF3oCvpW/cI/s8
PkB0yqOZ015q0HzBunSIByhYK4QYTZ8qI2xqDszhe8oLjdlyur3PqiYBOBZ11L+w
IXlWBvPyutZ71MTt1dTNJCc0piZi6kIr7PC5YuWXKIul/osMTWrrdPeJm31QxDRO
p9RXow4uvIUV/TQzuYu/xbw4dhaa8tmiHLarN3kFf/dbsQERqPUI+Z+VCVLRwv9M
9H361+k0dku2IuhpCAS5rWAOROArUiFf2q9z5GSYVZQwTfb3WmrY8zhUx7lBCAVX
hKOWmXFosnmsnC1Ojf1eDGCECZ6jGG5US0aHqXpkrygpQm/0sOrDWyMEkoStzoJ0
VviOb/BwTaY8A6tjglV2m+kce5X5UjUSapJUfNkZVvkIkTZ0s5fJ+1QUmU+4w93t
7QpIgX238QlehkpQ4OzQ3utvAqXMGx3SMzEVvXTCZKCQjknScJHxgYQPmxng+lE+
JYYcV3vVH2nEphMY+tc0C12Ghep+0cVtFWvLFod3NSiLBUsxDb0xSADuy5/WtLgp
/Lb6BuC7iA/5VKVN/5mW
=TLMW
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Feb_2014_14_41_22_+1100_HaXaIFZXDs9R9oRa--
