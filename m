Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750856Ab3KAEPf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 00:15:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710Ab3KAEPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 00:15:34 -0400
Date: Fri, 1 Nov 2013 15:15:21 +1100
From: NeilBrown <neilb@suse.de>
To: Linda Walsh <lkml@tlinx.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: RFE?: why no 'bind' info in /proc/mounts?
Message-ID: <20131101151521.2fa0b434@notabene.brown>
In-Reply-To: <5272FE79.30801@tlinx.org>
References: <5272FE79.30801@tlinx.org>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Lv6/jfWZXtD2eT.5g1zmyQs"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Lv6/jfWZXtD2eT.5g1zmyQs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 31 Oct 2013 18:06:01 -0700 Linda Walsh <lkml@tlinx.org> wrote:

>=20
> If I only mount 1 file (or a subdir) via "bind", it still shows the entire
> device being mounted on the "bound" directory.
>=20
> Is there anyway to get a bit more granularity as to *what* was
> bound on a name?  (subdir/file..?)

Take a look in /proc/self/mountinfo.  It contains more useful stuff about t=
he
mount table which couldn't be put in /proc/mounts without breaking
compatibility.

NeilBrown

--Sig_/Lv6/jfWZXtD2eT.5g1zmyQs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUnMq2Tnsnt1WYoG5AQLOwBAAodLHU2kvmv7QYp0Hfo+Yhd9ig+EXiJXm
1K8HMvOT9s3TL1nhl6sNMveb767zjmZzIPRADpreHXLBNkvYrLQ/JkEe+mkqfwV4
5CY40XrMc+vZHbdbi/t/HDeLT2c5SbYAsqY1m+MX9NNxkzx76wieC1ZKAASgmASZ
Hl+UsXqnBabc3KmKbfSf9Dvo2hvu+nFn/4hVuU2Kvx43uEK8VBw9z9SbvOEoCYLi
1qm2/VgelxYqqNTHljx4K5CnWrHBvDy5rxN4PHUenb1L7dpK/rBv42Bu1ZMPYWbQ
bqjFqIt+G9uSB6UV4r1OeeeDzUhfTBWo3n2LzZQuw3h4sdkpN61d8Hw0/I0NbG0/
2OOowVNi/1wkKORNvUJ5QRk4ksyuLT8EDa/BssiiCOiPQIzlj+gnOrWFtM8xOXGS
9WNNMumtsTx1IvOgjmZa6Pj2MDvi5LfAi62sPerIjy6Iwzx/QYqKv2skdsorcdzh
+W9EK8GOD4J1F4lwqe0aiRyGtYISAht0pRfU1cMeGd+j9Zq24UVmWGLWcygzcEbZ
9io3kZDkyZuqrUjpLVy4dlQIBp/i0acHzNVNsYG5hLWJb8D/3/lVloZO/Q7QTr5h
7ZnWe7WGyQhvxWBN40fU0wlj75JeTnLro7Z91jIJqhblT7DXch9iW6rY9tM+bNJH
pYVqN+4sqfM=
=3Eev
-----END PGP SIGNATURE-----

--Sig_/Lv6/jfWZXtD2eT.5g1zmyQs--
