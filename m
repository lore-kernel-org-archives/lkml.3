Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaLGXz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 18:55:28 -0500
Received: from ozlabs.org ([103.22.144.67]:40378 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbaLGXz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 18:55:26 -0500
Date: Mon, 8 Dec 2014 10:55:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the access_once tree
Message-ID: <20141208105517.0e9ac555@canb.auug.org.au>
In-Reply-To: <5484C3B9.2030909@de.ibm.com>
References: <20141205213224.2dcc20e9@canb.auug.org.au>
	<5484BF4D.1020809@de.ibm.com>
	<5484C3B9.2030909@de.ibm.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/LZ8M9cZwkSpDtBqpS1ghESa"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/LZ8M9cZwkSpDtBqpS1ghESa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Christian,

On Sun, 07 Dec 2014 22:16:41 +0100 Christian Borntraeger <borntraeger@de.ib=
m.com> wrote:
>
> I also did an additional check and merged this tree with linux-next/maste=
r. This introduced a new problem.
> The fix is simple, see patch. But I am not sure how to add that to next (=
via my tree), since this change is only in next.

OK, thanks for that.  I will apply that patch as a merge fix to my tree
when I merge your tree.  You (or the owner of the conflicting tree)
will need to let Linus know when the merge happens in his tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/LZ8M9cZwkSpDtBqpS1ghESa
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUhOjtAAoJEMDTa8Ir7ZwVLT8P/iQs0qQkv+OBQ7f8vc3c8SM5
5CNv/UmMG3oAulClhQ6svAJO0ljpdzmdePZd0tkbvQAfOjUvX9K+5aLgC6mpS5E3
5byB4mm5DHkWX1kdX3yN5cWq9uydcnrVuQhD1ZiqwHL/cF6qbSQjviE8O0RRpPPy
Djw1yip2C0djmNKhk8fhybsoo+LR6BMqt0ZwGdqQbcXjDMHaDLDoF+J+ENrh81OO
GmUHrCdcglNNgpXo6hERArae9YbYGi/D2ypXvEWxvU0YH7WMStfJIvbBr0FHjQ0i
HjXBV61qjTUFGlfjFrSKzR6GvEhcn7SM27/AH7NGa50IQ+FTBz5QfClpiMdi4iQf
q8EicFXXUrakWp2BgbxpJ+l8PmAF+6IM4kgcrNGhuNEMqt9ibXBwtgEZsfO9IOET
zdarxcIvECie0u3OSpk+A1NJVJoPOcPupq9A84DuVTw3j2trMjMgEAGC+ghrbdmS
XCziFjjZVYmXJ1GUOSqFZXgluFx4hB0kzi+b9CLPsL1exo4L7FaxP2YLLHNo+ZUe
rAYiRUOvqIVmoS0E1rgPvWIY6Stp7YIusdG8WneBAxSc8luMKrVAxi6u3/4GYuSb
7dGi5sKVJu0Xe5R9JKPXs9tG/UQOt1DzM9o/teLgFAET1sPMxNZ1gHYEZU1+2mQr
lsBTful+ESjVZlTechVg
=L6ZR
-----END PGP SIGNATURE-----

--Sig_/LZ8M9cZwkSpDtBqpS1ghESa--
