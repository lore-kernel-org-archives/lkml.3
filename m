Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbaFQWzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:55:44 -0400
Received: from ozlabs.org ([103.22.144.67]:42959 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756597AbaFQWzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 18:55:43 -0400
Date: Wed, 18 Jun 2014 08:55:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: the vfs tree needs cleaning up
Message-ID: <20140618085535.689388ac@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/p5KmPTLCRZ0pjhDlWpzi1zH"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/p5KmPTLCRZ0pjhDlWpzi1zH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Al,

If I rebase the vfs tree
(git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git#for-next)
onto v3.16-rc1, it ends up empty which means that its commits were all
rewritten before Linus merged them.  Please clean up your tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/p5KmPTLCRZ0pjhDlWpzi1zH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJToMdsAAoJEMDTa8Ir7ZwV0KgQAJA/E/3jiXXDAGTmjH6QLXYG
rqZDzYZflKNJGByQsg5uzCPl0HiLpcAWF09JMVmixQn7/RP1zE0gwj5fKT/uxv5U
EU4YrttI2/5AiaMBkYjWy5lUMbB0Mwl5to/3/RrMW2XdjFB9Kx7858ckqyph5jWz
6hVY4sEuFGJ+M47/oG5ZHAcbWPtgHnLe1lYZg0q4TEuhq9wQ3mVGrog7U9dI1Aqp
N6NmhRt9OcXmBcl9RSv71wC46zcExPqGsWTSQ4n6CoPosYikUmfZKNBmS5HWo8dd
2lKGp0Wr8K/StNh1o67L60qjiQYLX/U+OXjUCjXKy4LGX7DvoUtPeTBO6w+i3j/Z
nJvSv1PQMBnLlcvDSoyUx7gMK0GLyf4sNTzT42LqVwpGuSp6MfF7FKjpFRZXCVB7
VGLIyozamUPgjKi+mtwCJ/rpjsoEQUCEhABZXj6XeON2L3y/WOEGKuCIn2Mtvl8o
D27iU3XLRNlLGcPWq7ZX4HuFXjX5ubW3IbsmxOB6U579uVq3lPkM3d6XsMtzEhEQ
dlubZpDRipVHHF7+/iTbZQ+YBemq5zLGbh1Gvv2s9zUO/lPouwWtziijuT92JgBv
Qs3Q7J+HQ0zsorAKSjx1Fu/dFNypX5wQ9iNMTbO7oSYK8PoJv2feW9GIxYSwSPbD
T7eHJhRPqzZPC5D274rO
=zNV8
-----END PGP SIGNATURE-----

--Sig_/p5KmPTLCRZ0pjhDlWpzi1zH--
