Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbaD1PRd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:17:33 -0400
Received: from ip-78-45-166-173.net.upcbroadband.cz ([78.45.166.173]:51763
	"EHLO moskyto.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396AbaD1PR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:17:28 -0400
Date: Mon, 28 Apr 2014 17:17:21 +0200
From: Jan Moskyto Matejka <mq@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: Updated asmlinkage patch v2
Message-ID: <20140428151721.GE2641@moskyto.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LKTjZJSUETSlgu2t"
Content-Disposition: inline
In-Reply-To: <CA+55aFwYRGV65DsK4kBcdt-6PP1EY-3dOE=WUOhG=G5hcXYnVg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LKTjZJSUETSlgu2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, Apr 1, 2014 at 2:40 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >
> > Did some basic sanity checks with LTO and everything
> > works (still need the three other LTO patches to build)
>=20
> Ok, this series looks much better. Thanks,

It seems this series hasn't made it to the torvalds tree yet so the
compiler still issues complaints about __visible static functions.
Should I bring a patch removing the "static" from asmlinkage-annotated
functions, or is this patch the better way? Or have I missed something?

BTW some of the functions have already lost their asmlinkage, see
commit 8783dd3a37a5853689e1a8fa728827a50905b912 ("irqchip: Remove
asmlinkage from static functions") in torvalds tree and also recent
thread https://lkml.org/lkml/2014/4/16/453 ("[PATCH] crypto:
sha{256,512}_ssse3 - remove asmlinkage from static functions"), both of
them because "it issues warnings".

MQ

--LKTjZJSUETSlgu2t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIbBAEBAgAGBQJTXnEBAAoJEDFERKcRJ1apkBQP+JpaPZiTIhqoxX2vgKQvT8+6
s+LgFI4pZSVunu6qp9zbxJHBYO/qqjMx0EcbOkxJcT94U4QEkdi3d+5N/q7hlXXr
1LfocAE5zHdtuYQY6BT8AxgS+Y9zL+GnQNF1byQOMLIHkBIA+A2bpeuM6dXX8R2M
KIn6hx6JUKHoGOlmnjfYbYB8iue26VSfRvTrhbUC5WocGspB6boq7UvKb7C6ZL/y
Ndc/hU2x4UmzwCIP3w1luxP0I9ZYhTSDWMBYb/jEfcFBzqvVsB5x1MKbr8TbzURP
UE1IQBeKoAE5I9V6o8J7WWW+FKBWpDK+yfyfwxbQyGbyCSnVB585OVQWOGoS4VRf
pD84a0wf1HaAblwItvGtJpftxP0bZqxiUl2RvWxZvODNAE2ACONlOjGpKT/rtLfs
QcAJAutiS6mE9TZICrdUIZH+7LAcoXeJ6wM3rVx2sWQ48sshr8IT54p480T7lB5t
DDGOIy4hxxCnK3sQCk4nIxgLZDf3NRgGyKFykMDcOmAhHf/oQuA0eY31NDb/QkX9
lnkXFNbCbiRt213GiWkse9hqsRkywVcUkwEakkhACNBl7iQejpY6o294IrUHhoNs
2WOLMTUNx6xj4X0Ebvqn0ntXXyMd0x38prr8OQTMuWgXsHtIg0KdvKOVKcrg/nTd
68l7JPizKqFIVvdhskE=
=xcgr
-----END PGP SIGNATURE-----

--LKTjZJSUETSlgu2t--
