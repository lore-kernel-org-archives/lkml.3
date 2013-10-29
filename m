Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359Ab3J2GBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 02:01:23 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40094 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab3J2GBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 02:01:17 -0400
Date: Tue, 29 Oct 2013 17:00:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@kernel.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tip tree
Message-Id: <20131029170053.c1a6473af8ff8d63f09aff78@canb.auug.org.au>
In-Reply-To: <20131028102604.GA6127@gmail.com>
References: <20131028202442.5033ddf42639863d5f1dcf67@canb.auug.org.au>
	<20131028101823.GA3512@ulmo.nvidia.com>
	<20131028102604.GA6127@gmail.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_Oct_2013_17_00_53_+1100_qdVuWAmHPUmp5nE3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Oct_2013_17_00_53_+1100_qdVuWAmHPUmp5nE3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Mon, 28 Oct 2013 11:26:04 +0100 Ingo Molnar <mingo@kernel.org> wrote:
>
> * Thierry Reding <thierry.reding@gmail.com> wrote:
>=20
> > On Mon, Oct 28, 2013 at 08:24:42PM +1100, Stephen Rothwell wrote:
> > >=20
> > > After merging the tip tree, today's linux-next build (powerpc
> > > ppc64_defconfig) failed like this:
> > >=20
> > > In file included from /scratch/sfr/next/include/linux/mmzone.h:9:0,
> > >                  from /scratch/sfr/next/include/linux/gfp.h:4,
> > >                  from /scratch/sfr/next/include/linux/kmod.h:22,
> > >                  from /scratch/sfr/next/include/linux/module.h:13,
> > >                  from /scratch/sfr/next/block/blk-mq.c:2:
> > > /scratch/sfr/next/block/blk-mq.c: In function 'blk_mq_queue_enter':
> > > /scratch/sfr/next/include/linux/wait.h:772:2: error: expected ';' bef=
ore '__ret'
> > >   __ret;        \
> > >   ^
> > > /scratch/sfr/next/block/blk-mq.c:108:8: note: in expansion of macro '=
wait_event_interruptible_lock_irq'
> > >   ret =3D wait_event_interruptible_lock_irq(q->mq_freeze_wq,
> > >         ^
> > > /scratch/sfr/next/block/blk-mq.c:108:6: error: void value not ignored=
 as it ought to be
> > >   ret =3D wait_event_interruptible_lock_irq(q->mq_freeze_wq,
> > >       ^
> > >=20
> > > Caused by commit 35a2af94c7ce ("sched/wait: Make the __wait_event*()
> > > interface more friendly").
> > >=20
> > > Since this was also in next-20131025, I applied the following merge f=
ix
> > > commit for today, please fix this in the tip tree.
> >=20
> > FWIW I got confirmation on Oct 23 that this had been committed to the
> > tip tree. So I guess it just wasn't pushed yet.
>=20
> I merged the fix intoo the linux-next branch earlier today so it=20
> should be resolved soon.

Excellent, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__29_Oct_2013_17_00_53_+1100_qdVuWAmHPUmp5nE3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSb08ZAAoJEMDTa8Ir7ZwVk/MP/ReT+bkKeFRZeXXjSNhh3zcr
OW5/Bg1d9RZntDnt/mDE+JuiH4wQZJx/vq85lZcXWgAX6TcyY+J7cLlkuwKLFPVk
8KqfG4PtkVmgA/IdCHp74+slU+rFwp7/cQMNcHiBsGUWwT6aipLzn+8Tj0H2qXJm
H4XaDiCAJP3Rqe1xEgJziCmDTDd1hl8U1TLsK9AobCN12tuK6Bt5/uD0zNO2V1yj
z35mEFMExQIEkxqIgBlr0BN0GNQmN3wht0OYQKuqpLyd+95VZseiQgwCDm6vGVVn
S+CdQUmSkDvptee4tdwhLVLzDNa2x3viJE8cS+NXB/sXivcsCQ+UqpIYOf+CyJMU
RIf5AJCNgCj0BSdZaFb4SxBgsY6wHx/hqmYear7TG7elBkecNLqPwM5KDVZAwqb9
VVkDFLDadtm/Vjh0OYi5yITZwW8OyVlhRYTKcQSQ4TZGt23HVgbzDrOZ9wFSMYpJ
QrPBHV4gQFZFO3rz+E6xMipTVz6ZXsjFxnRAJ9oprc4qAP4VxHawF1l9+EHta7CN
3I3eUK29R/jWMXeC4gL5B3X1R4E2xNM9kqVMxclfRsJurCeDw549h1R6WoTsC7Xw
URzp2b85/37sRB5E4MUbxpNc2F/uz4r+aVgwUpdsXak2Uc/uAkPWIgVP/h0cHGpy
T9h3ykkibWZh8EN3yLkO
=DkVt
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Oct_2013_17_00_53_+1100_qdVuWAmHPUmp5nE3--
