Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab3CPC2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 22:28:07 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53077 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab3CPC2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 22:28:06 -0400
Date: Sat, 16 Mar 2013 13:27:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: New MFD tree for linux-next
Message-Id: <20130316132753.591db4c078d06db297ba46a8@canb.auug.org.au>
In-Reply-To: <20130315164625.GA29531@zurbaran>
References: <20130314000201.GA4425@zurbaran>
	<20130315164625.GA29531@zurbaran>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__16_Mar_2013_13_27_53_+1100_VGOt6ndy.NGoa6Op"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__16_Mar_2013_13_27_53_+1100_VGOt6ndy.NGoa6Op
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

On Fri, 15 Mar 2013 17:46:25 +0100 Samuel Ortiz <sameo@linux.intel.com> wro=
te:
>
> On Thu, Mar 14, 2013 at 01:02:01AM +0100, Samuel Ortiz wrote:
> >=20
> > I am moving the MFD development from mfd-2.6.git/for-next to a new mfd-=
next
> > tree:
> >=20
> > git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-next.git
> >=20
> > Could you please point linux-next at it ? Many thanks in advance.

Done.  I assume that you are still using the for-next branch?

> I'm also carrying MFD fixes through the mfd-fixes tree:
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-fixes.git
>=20
> Could you please also add it to linux-next ?

What branch should I use of that?

BTW, those two trees look very similar (in fact "diff -u <(git ls-remote
mfd) <(git ls-remote mfd-fixes)" only shows a couple of differences in
all the refs).  You do realise that I can use 2 different branches of one
tree, right (as can others)?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__16_Mar_2013_13_27_53_+1100_VGOt6ndy.NGoa6Op
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRQ9ipAAoJEECxmPOUX5FEWFgP/j8k4g5KaKJyAavWi01e5eBu
N4PoyuJBA0CQocroqx1SE1GHg6B4Pq6c8yqJT5xWTVBpZdub2MKL16CrisnbPrbm
35UGW34MdTm4TaVd6of8OhZ9Nprkz2pwGVXbjt91ea7Bh6YZ4ZP5UmPIwfHjYfTf
GuA8WPVibWp9m0X9te1w9wr+km71h60FE+hbZ2i4lSy0ZHqiWb83fD2F82waywye
4hxVPEkT7W5gOB0/I4zh8ZwGmpFyQU1Z5Vt6wN7/3haV984tY+1Yt0yk4+ok/Uos
f1IOzh1fZu/ELitKrVVjhDoeec3lDY/pHHNp75VU+yiR/4mvWFI3LOSRqL34FyX9
XtJm/Cvc7Aou1GMVlE239AJRjaRD5NoNSdd8jwT2UJlcNISO+wybTFaAidTaui9/
1JjYeQO9SdsKItgioye8zeRq0XdwE6lG2FtKBp6kgR87cP0m4KZzA6GluaF668WL
WOQi3VLc8tYPUdLBnEPdNk+3/93RFVc0uPG3JUVF0SWY60QB1P0+62KmKg2nDB1/
gQlfiaaLABA6SFMv3ZOsh0IWgTdzR9E3xQQPqiHLaQONdlKutnHwfnnRuEN+nzMJ
p2ZKEMDOsejh4hi9pdEA+pNbacxfq9S1C/UyNmRviLbPdjNwuo5KfJ15yD1UJS1f
+FB6MRnTUKNRAMB5PlgY
=XJv8
-----END PGP SIGNATURE-----

--Signature=_Sat__16_Mar_2013_13_27_53_+1100_VGOt6ndy.NGoa6Op--
