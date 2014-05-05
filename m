Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbaEEJ5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 05:57:21 -0400
Received: from ozlabs.org ([103.22.144.67]:39336 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755689AbaEEJ5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 05:57:20 -0400
Date: Mon, 5 May 2014 19:57:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: linux-next@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: linux-next: Tree for May 5
Message-Id: <20140505195711.fcce1825483f7a1ce707c2c6@canb.auug.org.au>
In-Reply-To: <CAHO5Pa0D8bxBV98feBt2qk_gb3XdTDcmaa6bD7eQv4UOdjcFrA@mail.gmail.com>
References: <20140505171459.3ce28e8e0c4d6b107a66eb97@canb.auug.org.au>
	<CAHO5Pa0D8bxBV98feBt2qk_gb3XdTDcmaa6bD7eQv4UOdjcFrA@mail.gmail.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__5_May_2014_19_57_11_+1000_9tbL7Qe41NhvTWJP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_May_2014_19_57_11_+1000_9tbL7Qe41NhvTWJP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michael,

On Mon, 5 May 2014 10:42:23 +0200 Michael Kerrisk <mtk.manpages@gmail.com> =
wrote:
>
> I don't know what the process is for clearing cruft out of linux-next
> is, but there's at least one piece of cruft that probably should go:

I usually depend on maintainers to clean up their trees.

> commit d30c01a0611d54926ac860721c933edafcc91905
> commit 8c013e265a8eca0ada9f1aaa6cd7590698dc7231
> commit e86263c9d00efb091a5215b9e4063378828d815c

I can't find any of these commits in linux-next or any commits by Andrey
Vagin <avagin@openvz.org> ...

[P.S. Please trim replies to relevant bits ...]
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__5_May_2014_19_57_11_+1000_9tbL7Qe41NhvTWJP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTZ2B9AAoJEMDTa8Ir7ZwVkEUQAIBb4HKJMli5U447Z0pOhmEP
XZvyQq6LuQS6ue9rFJyLImxJ/Qmaz1Ge9DVJtKGn0fKxHYEXy3Cw2b2ipySVm/nI
SqTPvcBYOyV+utoBT5uT1hgw3pMvhxULHFYdY/o8OFog0NQLA+eRHskFPt8kuLu4
pm1+5k4JsrswkboE09j0hBHMTKT8SM4lVygzcZq7outrnXTOmmfZcL/UpEznTCLt
srjElZx6e19MXjY2TxdjIWNxYPsskjbga3+zWrUstrr9ZnLo0UvjaT8iFeNwB1j7
ovLiqVB59SKmWlYHl7xkSPUtOVsBMMissDVMvFYsSmKgaW9okCC3KnMJRTqn82/5
CI9IH0zbpPYZQ9ZPwJx1BKOvso5soUYejKXeWrQHhn1AU6zq3jRgj1KSGFkvZx+V
e3BjSEgWW1JxZORDKasvFucPYJbRNi8x++/kIKwjKXM7aQIDEB7mfH6UfEFVa6sP
FtIWqrytfgNNgAZ7S47B5fELZJ3boBIf9/VyO7BiWcaFAMIwgs47QsNQ5qDmYQu/
H4ZG2m/z8o5drlf6fFRxiNlKzWm7R73utHqkkMn8Pb1Npylexnv2AlV9IS8l2Ekk
qDRNPTk3OcYsolI3eMb4LhdKxOsf2EKDec/lclboT1O6XZ9IvjWCNEib7HMIdBDq
mt/1PaMMMQkWNtC23kad
=pS5k
-----END PGP SIGNATURE-----

--Signature=_Mon__5_May_2014_19_57_11_+1000_9tbL7Qe41NhvTWJP--
