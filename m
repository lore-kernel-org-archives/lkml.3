Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbaIZGeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 02:34:22 -0400
Received: from ozlabs.org ([103.22.144.67]:40560 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266AbaIZGeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 02:34:20 -0400
Date: Fri, 26 Sep 2014 16:34:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Carlo Caione <carlo@caione.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the watchdog tree
Message-ID: <20140926163412.4135c44a@canb.auug.org.au>
In-Reply-To: <542503B1.9090206@roeck-us.net>
References: <20140926154031.4bc4dc39@canb.auug.org.au>
	<5424FFF4.4010506@smartplayin.com>
	<542503B1.9090206@roeck-us.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/tbBIDPKZlYg5RZlho5kpaPC"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/tbBIDPKZlYg5RZlho5kpaPC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Guenter,

On Thu, 25 Sep 2014 23:12:01 -0700 Guenter Roeck <linux@roeck-us.net> wrote:
>
> Someone suggested that I should create an immutable tree with the
> restart handler patchset, which everyone using the restart handlers
> could merge. Is that an option ? I could technically do that,
> but I would want to pick the patches from Andrew's tree to retain
> his sign-off. Andrew, any thoughts/comments ?

That is exactly what you should do.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/tbBIDPKZlYg5RZlho5kpaPC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUJQjpAAoJEMDTa8Ir7ZwVepcP/je69hglH97vOI9Qq5nweTZ4
vBY57w4NEeiKfnwlxqejUMHeBOLZo7TGZ4MQZQCN8dyTyeHF4tmGADYp1hyTTauo
4wPpEg37uMiqEXGB7j2dlbf2pFgsnqgazAEHALwCYS/VOOrwky3QbfOXiG1gEeyJ
IsaeczhzfQ+Xq2x9qCIj1pBhO1CKZ1Id2jT0U6VzBFNi1iUj6CH7UGCNYaRIKCAB
9IN2aU1eBd85bqWJYYZ+B6urfpxYSny9VlZyq61S/2dfF7mCwHMWtLEM2jMju/fl
Wa20+lfaGJSL/hBLVXYYKdV4nRLThrgUmyxAxnPE0JKM4Nd7II+OyqD5cfRFB7s9
XG02age3Jetr42ldB8yDzfV1d9DyU0UnbcI/CmpWuJB3/sKMP/minN4OvwfGR8VY
64pFhGjzgaIwFp6D1eZlHSKTwh9JUq8pJN3qHSBV4ZtjBexkQ0pzQCiXHZLJLSQ7
jXTr7NBMzOvCVZkn5MyQu6aqo8b7B1w70qpcG7P4+xUItrPYPjLCHXnxeXp67tkJ
fYi9S9P9zPgOFzOuM3vop/A5MG4JLbDCgOIDXEqsCK/oQFrFx9kZGbrGRa0bvTpt
HMjvzuLP2Onv5r1JjZnSVeGYhod7IS5iWioM3mXgvbhSwhZ4/q28glfgy5WQSAxE
NdBWDxQaafUZCtHIG6FZ
=798Y
-----END PGP SIGNATURE-----

--Sig_/tbBIDPKZlYg5RZlho5kpaPC--
