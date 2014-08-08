Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbaHHBwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 21:52:34 -0400
Received: from ozlabs.org ([103.22.144.67]:51612 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815AbaHHBwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 21:52:32 -0400
Date: Fri, 8 Aug 2014 11:52:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jan Kara <jack@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the ext3 tree
Message-ID: <20140808115226.3f4fbeb7@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Zk3GQEhAPOPYq9vfTjYLA8Y"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Zk3GQEhAPOPYq9vfTjYLA8Y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jan,

After merging the ext3 tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "new_inode_pseudo" [fs/reiserfs/reiserfs.ko] undefined!

Caused by commit 523096294315 ("reiserfs: Avoid warning from unlock_new_ino=
de()").

I have used the ext3 tree from next-20140807 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Zk3GQEhAPOPYq9vfTjYLA8Y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT5C1eAAoJEMDTa8Ir7ZwVaRsP/AwVJiQw2Bixx/hb9agE4H2m
WN+lYVAPFy0B1C8yFt1DAnymwWRccb8dkquUgBTJSYhyFfZrAIkrkZkKKhiYiU6c
6P5gHIbE1eqdiUlWzcvro9ZpUx/uYnPfr91NCh6HndiH6h/0QRr2hpOMfO1FYjiU
tqDXxvRZWSeBs+C+Oyh+er9sou2u1wR/oMckC7vm9xUnZlYc0inckr2FPO8qHnOG
zjPVpoGIbhHeJmp5/D1JqgSUa06+Uecr4ytn1bn6LfvHuXSGEdy6xVhxuNdmbItk
sS0PWuhdfFGfbgBiq7E00B2fyvRT7wl+rajX0/osMrWEHKhgU+XD/+qDcZgh1uLJ
jM/lxapmam1li73C3aWSfj/0IIakjxzwQDnbsq4yupmzDz+zxqnnnOw94Ehxohca
3wT1EZsKXYCbtB15Lr3NmJkIarj1OEUTSBbsyFrCPkmfmbTAlOwsvVHxh+F+LZNJ
cFF/f8WCv0ani7iDZVec8OUHVnmXT1TFd27ls9l14fN/epwaJXlLGWpxep/z5rE6
xD8ctLfAia6P/iKZkxlvtoZUoO4Pmtqk8OEoBNZtbhZieZyP6mvKMqGK9cFkbK2q
ISe5q4GwEKhZRCnpTuVpflBVqYXXDjnmM5l+ZU755W7qJDijbIp5skGMPCbLAtFG
KP/yFZuW/cFwTtS78Cp4
=YjKg
-----END PGP SIGNATURE-----

--Sig_/Zk3GQEhAPOPYq9vfTjYLA8Y--
