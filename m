Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaHSQi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 12:38:57 -0400
Received: from ozlabs.org ([103.22.144.67]:59007 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbaHSQi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 12:38:56 -0400
Date: Wed, 20 Aug 2014 02:38:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: linux-next: build failure after merge of the nfsd tree
Message-ID: <20140820023844.6077bc09@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/8XoK80TkjC+kg8vn50vRVzX"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/8XoK80TkjC+kg8vn50vRVzX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

After merging the nfsd tree, today's linux-next build (powerpc ppc64_defcon=
fig)
failed like this:

net/sunrpc/svc_xprt.c: In function 'svc_recv':
net/sunrpc/svc_xprt.c:776:20: error: 'current_task' undeclared (first use i=
n this function)
   rqstp->rq_task =3D current_task;
                    ^

Caused by commit 983c684466e0 ("SUNRPC: get rid of the request wait
queue").

I have used the nfsd tree from next-20140818 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/8XoK80TkjC+kg8vn50vRVzX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT832aAAoJEMDTa8Ir7ZwVMLkP/jHZdr10FRoGt8xXc8klOICs
IAiKitVsMTs2MqJEzckM/S3mu26ATT973WRrXkubxW7qUNoO9gCSylbUUXdbwaTy
thy3apTIKvTtLs+uHn1WzWWmmxR8/rYFCL07W0nFjibMqcH0pKv2MZMvA/jbg/hA
rsex0gd0DA18sZG7r/+ohibYAUFpNYRQYCe4jPWEne4RFQdDzozEcUEn2Lhd/bIj
DRORT8mmod5c7fzfZ+W8/ivhlIT475034O6rZev/smB0xsx/I6+6lGpwZk4KxD6y
QyBT/1YeR6HQ6UTj4QX2f7udgYGH+8vEsXkOMu8s16Hh2AAeDA8Aw8o5EAgVUgnU
w30ohLCcK5D2aWqOwF9qk8XxDhLc3YhxJuMNWG61l47jE8pc/9WO6bJg8wLutc+W
6TF+NBJkadUQOTLSQob39Ky8B7sEwC/b0uEGibdxneF9bgCM3LTWUYbvpbBQTM2o
HziUfszoUlW3j1+dgSF3FwDAiaknK5Tl/ZrAwKkLJW+EG5QKJu+K8dlMynvcqeff
yhu81YaV6cFwl71QyQgjHqCKHM19GaCKWxgy2y6FluhLOIfQU7wp3rQWMT4OCRHl
4gUquR1SYIuUCUyNBugHt1XChhwa7xKD3LV0tBqTkb9p9BPyr4oEsLd6gH56YCo4
gIEFxppm5TvcTBZDxj0N
=mH3E
-----END PGP SIGNATURE-----

--Sig_/8XoK80TkjC+kg8vn50vRVzX--
