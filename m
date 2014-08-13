Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbaHMJbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:31:37 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59848 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaHMJbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:31:36 -0400
Date: Wed, 13 Aug 2014 11:31:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Christopher Barry <christopher.r.barry@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: OT: Open letter to the Linux World
Message-ID: <20140813093118.GF9918@twins.programming.kicks-ass.net>
References: <20140812153812.2923046a@monolith.infinux.org>
 <20140812202129.GA20344@home.goodmis.org>
 <yw1xr40l2whi.fsf@unicorn.mansr.com>
 <20140813082756.GB2923@twins.programming.kicks-ass.net>
 <yw1xmwb83fo5.fsf@unicorn.mansr.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EYgyrsPzPB+8KyD+"
Content-Disposition: inline
In-Reply-To: <yw1xmwb83fo5.fsf@unicorn.mansr.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EYgyrsPzPB+8KyD+
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 10:24:58AM +0100, M=E5ns Rullg=E5rd wrote:
> Beware, even Gentoo will pull in systemd, if in a dormant state, unless
> you are very careful.

Right so I've not tried yet (busy see), but I meant to remove all the
*Kit and other nonsense from the USE flags.

I don't need GNOME so that shouldn't pull it in either.

And from what I understood they have their own udev fork.

And I suppose its OpenBSD to the rescue:

  http://www.openbsdfoundation.org/gsoc2014.html#systemd

which is of course entirely ironic.

--EYgyrsPzPB+8KyD+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT6zBmAAoJEHZH4aRLwOS6oIIP/0taoBcUctWtlBjDLusa9A5r
l47rx18fS4XQY3h13l7Az18mY2G270VZQahLhsYjWiNSPXrYp/GK1rUygyR+HwNQ
35/+Dy2fSer49vTkxijRJ4IUUng9gfjb8N9HMXeTNpFkreYiBOE4lPjO+Lj4vM2Y
pH+GyVB2ZaCgxRxUPiJYDcuMtcPpooXJwduboODKhBJ17f/Xz82r3AYDSbnhiWq9
LSMUUZAWrfaQij2A9bIw5smMHPs1+XXTZAy2IDuj50UIMVy81hITWQtvLKXdSqIy
p54PavaJK8iAs+3zOaZYxLwXae/BzlhKdhlSg0ax1Lf/7zym8ydtvFpPgcFW6F0x
BE8MWnuQibL1+trVQ6gLi+x274v12RAlN++NWJqenb/mtpNpQKy7elUdK/TcquIJ
SJNKqolUQ7cLLksNVq7kNG3/66pOkdGnn3eua+FEy3e2TFXuh5sisGBgJtQcb/X9
j1dooIALPfdVFvkZJricFdw76HiLxx6LGuXtru9V9j9uN95K36vLp1Hr7nN56ffn
7qEz43VCwPu0LdVyCKySjUDbYQBRxbTdZGGjQAbGqHpcpWx5OeuU+YFr97t01k76
1hTCi8Ldah5rnve9+KjOdxf2cT6XkkH5K+zWtz+e8d8K/2gox180wDdknyUv1Ivm
fNOOPYd5hILK/YdZGJfC
=vC8+
-----END PGP SIGNATURE-----

--EYgyrsPzPB+8KyD+--
