Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab3CBPsy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 10:48:54 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53290 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab3CBPsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 10:48:53 -0500
Date: Sun, 3 Mar 2013 02:48:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Hogan <james.hogan@imgtec.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Arnd <arnd@arndb.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] late arch/metag fixes for v3.9-rc1
Message-Id: <20130303024851.4be2d2435da42a6010c6c8f8@canb.auug.org.au>
In-Reply-To: <5131D2F0.2010705@imgtec.com>
References: <5130DD94.2060408@imgtec.com>
	<CA+55aFw9qvUdrtEk_83-gEjZMTceONk=AuVsHuTtqOj=jpVPQg@mail.gmail.com>
	<5130F978.9040604@imgtec.com>
	<5131D2F0.2010705@imgtec.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sun__3_Mar_2013_02_48_51_+1100_jSINA=Jz1muBeD_N"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__3_Mar_2013_02_48_51_+1100_jSINA=Jz1muBeD_N
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Sat, 2 Mar 2013 10:22:40 +0000 James Hogan <james.hogan@imgtec.com> wrot=
e:
>
> Okay, I've rebased the arch/metag tree onto mainline to make all the
> back-merges unnecessary and applied those simple fixes into "Build
> infrastructure" and "Various other headers" commits (additionally
> trivially removing ARCH_NO_VIRT_TO_BUS which is also now unnecessary).

Pleas make sure that what you are submitting to Linus is the same as what
you have in linux-next (i.e. reset your for-next branch as well).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sun__3_Mar_2013_02_48_51_+1100_jSINA=Jz1muBeD_N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRMh9jAAoJEECxmPOUX5FEIDQP/3BqmOj8OfQCfgxkYkRHV+3r
sbgVxmvFciM6Oaw4R/whC2MbI5AgSEjeKbQJdnTKKfs+4VzvCzaOJnb9zjn9Q0JV
+NKMtmutAwwiFPrsvF15/SwY6f0gcDWDplBfqkwcypNcXRRMo0YtiincCItRv+CE
s1UZaJnXXRE9MIqYEcSzsTvgHgtbYNTusRGKJ2EOimzafNnhgNEO4CJrXqCnhVyN
q3AjyLZPYPwRzd/FDo/90ZSMpPfiQP130ao63KkSxm5p010udtclYdI/udq+2SB1
m+tWE5JaqM6Qdj7pWGLqym9iJhaUzoNAvc8xfPwzPRbQkuAlZPKiwsWHP8M5msR0
cP04eD+EsT0uKg3BADuTWjukVU7ukwUkQ/I8gOSj+RGfVcP3Fqr20Nlhr28bWre+
SeuMza9+z8GC26i/aeROcXGjAipcWnBQ25nXBwKWFHFbf99GOy9NI8tjdNk8d2jr
idbWScotRDq0f+AXFViacMvgD5FSOD5ZyaKFGxpzosU9Ajxl0NpZxKBEIzvRpAow
8lYL+Cxw1lPmkSswEPfiTknMSUVEfE0hWLQvpRT/ZF1Iws3BmovC8P9cObZTyz4b
kDoCADRYquXmdEIBrGrAoqZanH/0KChcxVJTpkX/8+aJqp7REovuqdNQIhAQojYh
IqKrt9lghp5RZxZ6irvU
=fDy2
-----END PGP SIGNATURE-----

--Signature=_Sun__3_Mar_2013_02_48_51_+1100_jSINA=Jz1muBeD_N--
