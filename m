Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbaEZHHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 03:07:23 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbaEZHHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 03:07:22 -0400
Message-ID: <5382E81C.9070605@nod.at>
Date: Mon, 26 May 2014 09:07:08 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Marian Marinov <mm@1h.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        Jos Huisken <jos.huisken@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: inotify, new idea?
References: <CAOiKX_m8buaq=4_hVQjyfv36ZtFVFieZ-CU8JeDpcdbeiX5mug@mail.gmail.com> <20140417212834.GC17769@csclub.uwaterloo.ca> <CAHO5Pa1Rb5YkXF_0iE_KUhOOGeNo+zV+OWQW6L8_ix=iFvkTyg@mail.gmail.com> <CAFLxGvxx8_gJ+NAGVn_vZmkVfey45_1qTqAQnxKDCZD0gQsr5w@mail.gmail.com> <CAHO5Pa1hfp+uLiQ78-pn2RJ6SytSYqXTniyx3UvaTwU_=ECWjA@mail.gmail.com> <5354DA0B.2060204@nod.at> <53804FC0.1010207@gmail.com> <538091C2.6040802@nod.at> <538280EC.1010202@1h.com>
In-Reply-To: <538280EC.1010202@1h.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="bpO1hVVB6T7Or3074wsq59TQsOKi1N430"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bpO1hVVB6T7Or3074wsq59TQsOKi1N430
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 26.05.2014 01:46, schrieb Marian Marinov:
> Have anyone of you looked at this: https://github.com/1and1/linux-filem=
on/
>=20
> I haven't stress tested it, but in the past I ported it to more recent =
kernels:
>   https://github.com/hackman/filemon-patches
>=20
> It is not polished, but it works.
>=20
> I'm considering fixing some of the issues at has for use in my home set=
up.

Well, the patch itself has documented its major flaw:
+ * WARNING! This patch has been designed as EXPERIMENTAL. Its usage
+ * is DANGEROUS, because some filesystems could get exhausted by the
+ * masses of ORPHAN INODES!

Thanks,
//richard


--bpO1hVVB6T7Or3074wsq59TQsOKi1N430
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTgugiAAoJEPmeIjfg4UaauusP/3uFyEzGLkEo+S+X9XFBvtLo
Au4LOQ1XlnT0tAKyUkk/+TWUE9L1grxS5aMLFPnxJivUM73kaZFFjiGM7YyP2ktA
jrCmeA5wjv297wgzp22GAIBadOVAVj9yGEnDua6yFdVzfYMLRxcXkrjbAfIgeze/
r6lO0Q5Nv/8il/IYQkSTNwSkbhYRFF16Cnth/QkRotwWC1ufppg+rbeO7vRmQDR2
JOPlejYk3b0Qr4oacO+KrJxM7cJG+72QSelnR9NAu028ngMv9myvH0L5Kp3vyFnF
4li8/0RgXJpicxS4WhrgbRzVMX/zZLj9h2880eS5Hx8MLty6rzHyRVbryuKofkz6
LqOqJwDmdE/VO2i4VQ/6ir7u24AkIHyhvGrKNfKP7X3WxxUyLPYEsUCAZ8Sd8E0e
yGeIMnQJN+lxGsiQgBoH6CKO8oUuyEmKEiVHT+gTWl23HxIY77Eapft9vd4WKP6F
dpKl9bFa7/PnN8dG300L7cLusCO+D8/HR3yY75N4SUJyf3CqrVsDIw0AGryFth4B
WEwy10Vp8FKg5OBfc9DwHiC6DegRTi7DKTDoyudOjSn1oixrd0GbcLc09VMm8+VU
u+GV6Aq8PqT31EJt2kb7IP6HuJUyvRvCkKWM61UWA+msrWkvR9Mg33zXYE3NnSth
PRE9rosbJXwsSQrRi3a+
=o8GT
-----END PGP SIGNATURE-----

--bpO1hVVB6T7Or3074wsq59TQsOKi1N430--
