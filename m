Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970Ab3APTS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 14:18:56 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:36063 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab3APTSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 14:18:55 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: David Miller <davem@davemloft.net>
Subject: Re: Redefinition of struct in6_addr in <netinet/in.h> and <linux/in6.h>
Date: Wed, 16 Jan 2013 14:22:16 -0500
User-Agent: KMail/1.13.7 (Linux/3.7.1; KDE/4.6.5; x86_64; ; )
Cc: bhutchings@solarflare.com, libc-alpha@sourceware.org,
        yoshfuji@linux-ipv6.org, amwang@redhat.com, tmb@mageia.org,
        eblake@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, libvirt-list@redhat.com, tgraf@suug.ch,
        schwab@suse.de, carlos@systemhalted.org
References: <201301161205.04502.vapier@gentoo.org> <201301161228.42592.vapier@gentoo.org> <20130116.135959.90676245194307972.davem@davemloft.net>
In-Reply-To: <20130116.135959.90676245194307972.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2151952.n8aPA2lcy6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201301161422.19202.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2151952.n8aPA2lcy6
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wednesday 16 January 2013 13:59:59 David Miller wrote:
> From: Mike Frysinger <vapier@gentoo.org>
> > if you're not calling the kernel directly, why are you including the
> > kernel headers ?  what is the problem people are actually trying to
> > address here (and no, "i want to include both headers" is not the
> > answer) ?
>=20
> When GLIBC doesn't provide it's own definition of some networking
> macros or interfaces that the kernel provides, people include the
> kernel header.

sounds like glibc's headers are out of date and we should update them to=20
include the missing definitions

but this is still too vague.  what headers/definitions do people want to se=
e=20
simultaneously included ?  changes would be needed on both sides (kernel & =
C=20
library).

> This has been done for decades, wake up.

and it's been broken for just as long.  no need to be a dick.
=2Dmike

--nextPart2151952.n8aPA2lcy6
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJQ9v3rAAoJEEFjO5/oN/WBg74P/1+Qjn9P3o4Gzdelbg+Rvj2T
/qPQ+4Uj+CKdMmP143DU6+Y79pARKx1q4B4OVhozSsFWMGXMHToHS8ZJ0LyL5kN/
fgd1iHE3p5bkp9FChPr4WsPP5xXlUh+qIyRUp7K4x4gc6W6tMPDpBlhp/aZeVKYx
s6pI3P/3EKzXTSJ2pD6H+rLGgN3zpUZEElXY0nGd8SjdcNtT5IGQ8AhLVTtnE/cx
4vuo6GPLWQhCdC8IiLwEZvIlxaJlrAgXk1R5RPu9D8zLROGFfvHoCydA5R+Pt0B+
kS5SMfbSJJk7tnOPvGCnvK1wt5uwLGXJIr53TN8efIhr5eg0dibDPDLDzAhM5yLi
mLRRgaOg4rAw88EHqTWSHjORMhznE8yvDC45c81077pvDxmHxqZ/kqO9TE/shAOH
uayqmiZkOZM5JN8et+9MZlNzGQIsYvd1UA0ODk3aVVcUyPrNRdBoWvFAEEC1Vd9s
NDSbnN4qDGPm6ufQC5SnZnTg6uAIIuikvFVqGXQRonM5mRaaxwVPv2vsqHfFmDLA
ODPdFrbOwBkbR8M44TuT0jfEcB0tuSE1cF5BUZlRI3cwrAw+M3rZa2ex3TTH/83L
hh0HxAvWAVJ2sqnngcWZpuPblRjNRTJPqFaYGEz/tiRc2HpkY/W9jYEYjDk4xtBP
MKa80jIo9+L9RIL+P7Ch
=SGZ7
-----END PGP SIGNATURE-----

--nextPart2151952.n8aPA2lcy6--
