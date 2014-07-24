Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935055AbaGXXSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:18:46 -0400
Received: from ozlabs.org ([103.22.144.67]:38379 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934768AbaGXXSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:18:43 -0400
Date: Fri, 25 Jul 2014 09:18:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: VFS tree for 3.17?
Message-ID: <20140725091834.58c1f102@canb.auug.org.au>
In-Reply-To: <20140724153057.GA1584@infradead.org>
References: <20140716114136.GA25237@infradead.org>
	<20140722162455.GA15053@infradead.org>
	<20140724153057.GA1584@infradead.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/IyIcU092gtO7M+RFjhzPN.y"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/IyIcU092gtO7M+RFjhzPN.y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Thu, 24 Jul 2014 08:30:57 -0700 Christoph Hellwig <hch@infradead.org> wr=
ote:
>
> I've pushed out the current queue to:
>=20
> git://git.infradead.org/users/hch/vfs.git vfs-for-3.17
>=20
> Stephen, can you include this in linux-next for testing?  I plan to
> send the first two patches to Linus on Saturday as they seems worth
> to fix for this release still, between a user triggered refcount one off
> and a fix for a just introduced warning.

Added from today (called "hch-vfs").

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
        Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

--Sig_/IyIcU092gtO7M+RFjhzPN.y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT0ZRQAAoJEMDTa8Ir7ZwV9rkQAICCz2UKUBD73mM7e9F2KxYE
0bsqCfXWpl3qFZxIgxJOco/4w6jjuP8eugyRFMJx2Z/b+vhg8YASlzqE5JQqRZpD
lo69xpoe1w+jxA5vVzMXWxUu0i/7dFfTsxx0NwXbIGYfio+vb0QraUpgIDTdRuow
paIGIrs5jcCCE1frU8AJVYyUJEvQeiCI4WgRrnMbJIltXfjhGjORivmXXR7zA1a5
rKwyejupQug2U7o9JY64mJXGD4dHGcWXSeMX+473d5A5okAS87xQezV4+wFyq13V
r3S/SFFCZXECQD3aDhAXDogenXEwoXHwg62IHR76CE+SQXQNj+ojAJ+CenA1/0lA
LBe0+A/WNXCnOqFInZMU0/G+KgcWfVqt+SEHaMs587YMXnqwKC521yHjWMQ+s6Sj
K1baN4zCAaVinSnCcdLMhjsoaoaThD7UFfMNIzsKjQYTjVVXs6OUfD4i44HqH3BD
h1XmHucXlp/ig+AGjzNFhJ3qq/GCRn2Rjfs86gorm5Bw2mfwOhh6zt60WRQ6qKvL
y+nnRbGPUqamK4gCcIM/lfFV4y/wqb6K2x8IoENlw9nLvQOlRhmE+qRXHRfvRHEq
av5xmewIeKrVsa5jseGf9+3IimJKsPcd1bk4rrJmlnkrzSDGWU1zSy1lk/jXYdfQ
ocRX3rDQ/NbLbw6IjwW8
=b563
-----END PGP SIGNATURE-----

--Sig_/IyIcU092gtO7M+RFjhzPN.y--
