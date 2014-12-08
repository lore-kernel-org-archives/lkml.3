Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbaLHKbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 05:31:33 -0500
Received: from ozlabs.org ([103.22.144.67]:60467 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575AbaLHKbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 05:31:32 -0500
Date: Mon, 8 Dec 2014 21:31:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: status of the lzo-update tree
Message-ID: <20141208213120.214c8386@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Y1sEam=so/FcZ.pSpBYWFN."; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Y1sEam=so/FcZ.pSpBYWFN.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Markus,

The only commit in the lzo-update tree
(git://github.com/markus-oberhumer/linux.git#lzo-update) is:

    lib/lzo: huge LZO decompression speedup on ARM by using unaligned access

It is dated 4 Feb 2013 and committed on 4 Mar 2013.  Is this going
anywhere?  Or should I just remove the whole tree?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Y1sEam=so/FcZ.pSpBYWFN.
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUhX4CAAoJEMDTa8Ir7ZwVh3AP/A4JyG3YGBo/sFstM8+LcX+A
SQeeQO2Ky2NnHb6sWz3OQXRD1NNqJ4eqFGDFYV+1nPaRNJaCAwdWdEhxg7yXyl5N
l98dxLGFvmbeLWOyjIaaQl7j5Ac8AcorjLAWBUlmF/qf37uWU90RecozjsWDp3dU
gToQw8Mwh+kfcM1j4b6hTX+hIEIjy7yczYvnzguC0bdTfsmm4Is09UgCwiCKibbC
gUrdU72qd7+T4gzS6w/mwI+goEbsee404vTvXqiBJMYl88hG4N6emScnBS7OlCi1
nUqP+E63UkS4ovc0fiNp9j1Ion187iFn6kpr744TBo6kpS/r/jTR8baeO5/hiSAT
auTOpZeeI8HyWm7boYaOQzIKKqq+z5VmLPpNoiGcHJhzY8TPBl6rD4TXa7g926RZ
iqT7aBRrcG5EQQSsR09KTCYRd9KJphF4QDQbK2IZrDY28uvix+VX2j3u8/PThUG4
p6eA2r1JAsZ/XvHx18eKyf0vi6DfsYw3+UaX7muIAUs/9B/ZtZlGyTRadv9gXX2y
/tZMm555bCWbcPwmL9d2IPRmjbKBNQUgorX0DF5RACsPpNIuiGQ3GZugBHlouwZ+
CC7+e7OcQWuqlzpAuQS+NMfLukWhdO993nzXvIt8WRDZgOmn3XjfckKtyUmkEXH/
rkIUQlRhsKgmA2oJKO/h
=bRxn
-----END PGP SIGNATURE-----

--Sig_/Y1sEam=so/FcZ.pSpBYWFN.--
