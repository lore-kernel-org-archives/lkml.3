Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464AbaCRX1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 19:27:20 -0400
Received: from ozlabs.org ([203.10.76.45]:52670 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755163AbaCRX1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 19:27:18 -0400
Date: Wed, 19 Mar 2014 10:27:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tony Luck <tony.luck@gmail.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Sasha Levin <sasha.levin@oracle.com>, Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [BUG -next] "mm: per-thread vma caching fix 5" breaks s390
Message-Id: <20140319102711.84f68cdb4a7b7acfd945fe74@canb.auug.org.au>
In-Reply-To: <20140318161050.ab184d30edf4b2446a2060de@linux-foundation.org>
References: <20140318124107.GA24890@osiris>
	<CA+8MBbKaaYXNV_XZNRp=wn-+3Mqd4+JVoXn_d+eo=PQR17i1SQ@mail.gmail.com>
	<20140318161050.ab184d30edf4b2446a2060de@linux-foundation.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__19_Mar_2014_10_27_11_+1100_=k_3ALlqxoHEleo/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Mar_2014_10_27_11_+1100_=k_3ALlqxoHEleo/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Tue, 18 Mar 2014 16:10:50 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Tue, 18 Mar 2014 16:06:59 -0700 Tony Luck <tony.luck@gmail.com> wrote:
>=20
> > On Tue, Mar 18, 2014 at 5:41 AM, Heiko Carstens
> > <heiko.carstens@de.ibm.com> wrote:
> > > Given that this is just an addon patch to Davidlohr's "mm: per-thread
> > > vma caching" patch I was wondering if something in there is architect=
ure
> > > specific.
> > > But it doesn't look like that. So I'm wondering if this only breaks on
> > > s390?
> >=20
> > I'm seeing this same BUG_ON() on ia64 (when trying out next-20140318)
>=20
> -next is missing
> http://ozlabs.org/~akpm/mmots/broken-out/mm-per-thread-vma-caching-fix-6.=
patch.
> Am presently trying to cook up an mmotm for tomorrow's -next. =20

I could apply just that patch to today's linux-next if you like.
Otherwise if you get a new mmotm out in the next ~6-8 hours, I will use
that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__19_Mar_2014_10_27_11_+1100_=k_3ALlqxoHEleo/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTKNZUAAoJEMDTa8Ir7ZwVazwP/0EQu9KEcWaJwYfCd/WrnQGE
xnmp1rMDw9+uRPM2ubo0/d82dn/AHa3+yWwFFQyfNrs962kOfG3yUU35YAkOlD7q
O7cLNvrTcg/wrFHh0+oxdK2JYFhjW5xdsDC41K7qsK6dM0ExiKF7mYhaNkOIMSkt
QMcweM+BlOdlQZ+vY45/m3u3++86XuzFdWW86ForrgiU9bswW2lsDoz0Lk+Ow+mY
r8Hb0/pxVKJuz+oGK1i5IwxVkq7KRhtKgEFpbTgg5fLRySCmSdyr92Y6uCheUNA5
MVCUnUbS5HaOlABcL62RASNP5/K132cKId0uCzdfveNSMl0TvMe/080HCrPybOVm
2gYSc593JEDu0hc0A5Zl9pIFdwmWoC7wHsCgGEjC3va6HBWLQpVYdU6z0/ZuCObV
XO39DD6nPYTYhbZHD6Kdf2Bfob1AWyeSfDS9Zu1ISqpufrGT/h5Gxd2smXBs8d/7
YIgIpQCrtKHcn+l2dOhziCcy2XtFBq2XHHaD9ev/KhPSPLOMG55/7SDBkoVqUPh1
zynodSLN2pspcQT7yOjf2qZzIo09ne36+bxIuJbH1an5GoyggPw5ZVmMxPsyt9Ns
2+3qeILk9+u2Vw1S4/DcbaTptf/XlMqOwkfc3fvShUzEEE1XFxLuxTpFTKUjkCPj
NzBbZ19YPn8wr9Soao2B
=9yIk
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Mar_2014_10_27_11_+1100_=k_3ALlqxoHEleo/--
