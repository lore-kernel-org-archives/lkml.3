Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbaEOPES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:04:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:59283 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbaEOPEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:04:16 -0400
Date: Thu, 15 May 2014 17:04:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mateusz Guzik <mguzik@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: WARN in do_rt_tgsigqueueinfo()
Message-ID: <20140515150412.GP30445@twins.programming.kicks-ass.net>
References: <20140515133834.GN13658@twins.programming.kicks-ass.net>
 <20140515142723.GB22041@mguzik.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iDVed5OELLBB+kAD"
Content-Disposition: inline
In-Reply-To: <20140515142723.GB22041@mguzik.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iDVed5OELLBB+kAD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 04:27:24PM +0200, Mateusz Guzik wrote:
> On Thu, May 15, 2014 at 03:38:34PM +0200, Peter Zijlstra wrote:
> > Hi Thomas, Oleg,
> >=20
> >=20
> > trinity$ MALLOC_CHECK_=3D0 ./trinity -xinit_module -xreboot -xshutdown =
-xunshare -xnfsservctl -xclock_nanosleep -xuselib -xumount -xmount -m --qui=
et -C 400 -l off -xmremap
> >=20
> > [watchdog] kernel became tainted! (512/0) Last seed was 4072360471
> >=20
> > [15908.562512] ------------[ cut here ]------------
> > [15908.567245] WARNING: CPU: 22 PID: 3312 at /usr/src/linux-2.6/kernel/=
signal.c:3060 do_rt_tgsigqueueinfo+0xb4/0xc0()
> > [15908.577715] Modules linked in:
> > [15908.580857] CPU: 22 PID: 3312 Comm: trinity-c198 Not tainted 3.15.0-=
rc5-01700-g505011124ad0-dirty #1070
> > [15908.590412] Hardware name: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/08/=
2010
> > [15908.597228]  0000000000000009 ffff880428715e40 ffffffff81682052 0000=
000000000000
> > [15908.604834]  ffff880428715e78 ffffffff8109808c 0000000000000001 0000=
00000000ffff
> > [15908.612402]  00000000efdcefbf 00000000efdcefbf 0000000000000129 ffff=
880428715e88
> > [15908.619941] Call Trace:
> > [15908.622423]  [<ffffffff81682052>] dump_stack+0x4e/0x7a
> > [15908.627600]  [<ffffffff8109808c>] warn_slowpath_common+0x8c/0xc0
> > [15908.633658]  [<ffffffff810980da>] warn_slowpath_null+0x1a/0x20
> > [15908.639535]  [<ffffffff810a9914>] do_rt_tgsigqueueinfo+0xb4/0xc0
> > [15908.645591]  [<ffffffff810a99f1>] SYSC_rt_tgsigqueueinfo+0x61/0x80
> > [15908.651851]  [<ffffffff810abb2e>] SyS_rt_tgsigqueueinfo+0xe/0x10
> > [15908.657946]  [<ffffffff8168a842>] system_call_fastpath+0x16/0x1b
> > [15908.664036] ---[ end trace 02450728e2526283 ]---
> >=20
> >=20
> > This is apparently a very common thing to hit according to google.
>=20
> Well, it warns about an argument received from userland, so nothing fishy
> going on as far as kernel consistency is concerned if that's what you mea=
n.

I hadn't looked that far.. I just manged to hit it two times in a row
while waiting for my bug to trigger.

--iDVed5OELLBB+kAD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdNdsAAoJEHZH4aRLwOS6JF0P/AlQbdkE4T9dOFx6Tgg8+u8E
RVUHTAyfbUia87Ne5l2bxk5A+h+O0ASSPSZEHaDBwH9G8k/PKhuKS//MIfQ5M+as
+RivJiSYrf5eDziWOYFuCPMqrzxvGYQJsTICfthq557vBCNbWvZ9oIqwuRHfzEsv
SQk5Zsufz+GmusK9BxzuMHOoaRwg2dAX+TV+7+tiPleTcAVTOG+txnX0lYKCZMkz
t0Gr7wKHIwgstN0SV/024VZGDs9QYMZbvBh2EWArEpkp4Ygn2QRd2WaPlZ9TAexB
7TxZ9UXgbp2VKI8hyuEXQ+aA5D+zyql9PNEB/GZ+djR4u/rVZS280vXHt3cR78sI
PFEMJmmFArlQj7GlhbSenQRE+phif82Mp6+5nIRRYYBRkVOuxwrlufRte7q5PFEp
6iqLn5+B7iP8r5k23UAhQUBWfHMRaI22xUOMeW1led8tY649BzsMNVoez6lsAYGv
gm25XrJVwjD62csu5lLyeW1KEQOLbrpF4PorN2bz7tPioZRCtZ/sGqReOu7S6XOo
IMFd5Owb6RyMMjHmgwnKQSMdBra2QLWnd7T0PQsDwq7R+xf4u1bpKWmnRpajwKa9
ep1LAzafPBmjTuQOKSBlmkIkTxYf3JP/KkNg6SjUkd3xZchdIcAVinlQf2P6K7jf
dIfhIH8NoH7gfoyrNWsj
=B+fv
-----END PGP SIGNATURE-----

--iDVed5OELLBB+kAD--
