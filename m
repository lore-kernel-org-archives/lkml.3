Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbaCaAIJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:08:09 -0400
Received: from ozlabs.org ([203.10.76.45]:46315 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217AbaCaAIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 20:08:07 -0400
Date: Mon, 31 Mar 2014 11:07:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liu ShuoX <shuox.liu@intel.com>, Zhang Yanmin <yanmin.zhang@intel.com>
Subject: linux-next: build failure after merge of the ia64 tree
Message-Id: <20140331110756.c4f9b2e9f9f4874e0d90da11@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__31_Mar_2014_11_07_56_+1100_0m4m2Q../5IdSJiq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__31_Mar_2014_11_07_56_+1100_0m4m2Q../5IdSJiq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the ia64 tree, today's linux-next build (x86_64
allmodconfig) failed like this:

fs/built-in.o: In function `pstore_file_open':
inode.c:(.text+0xa29e9): undefined reference to `persistent_ram_size'

Caused by commit f5d7e81eda59 ("pstore: Support current records dump in ram=
oops").

I have used the ia64 tree from next-20140328 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__31_Mar_2014_11_07_56_+1100_0m4m2Q../5IdSJiq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTOLHkAAoJEMDTa8Ir7ZwVl3YP/1GYWCD2eOsrZfpnSx39N6qn
RKc4NVEdCYi20TbsBBcRxSoITHY5GwUBoVbwP4gl415b2jud9B5YVyIdnYyqf5Sd
3I9vhtWnocY8MRq9tdXNtEkvM0ZIe+RS5Qu5uYgPdvPmrtEPANWPKZu7gqKXJ235
WuvNi3rWbiIc3V0m2pqNOv0jskx5E8mg1v/ZVFQcsRwIPTdKEHc7yirQL8GBifKT
iN/QE1q7Fd+rfS+SNvlRBzzbYZWXEmQQJ8oiZbJkrQpjW7dXJrVlt37D6fa1Z36x
vi26YNkdY+I3S/icTXnMhu2zrjPJYpk6pKSdlCEldOSs7hUtzCkE0Se43/He2m1K
iLp87Ca9PVxQTc2EA/4LrUYDQRqXoD487DHzf/0LgxciubnWc0xdEtkbgMszc11r
LMPDS4kZ6d+NsTd879rzAOJ3D8PHXUhguw3ROpjV1s0BGuXgOPWUZ87utDjDw29M
hL3SifQeGCGidYtNRXxK9BRfkHQpNHt1e28qpX//gNM6m4dBR8jumrfIxKkPONv4
mdl8CJa+R6jbWFNvvj04sTe7BcLhZYLFlj88DNgZiFXbi7+KaXdHgXutnVNcsFJW
ka+wpxoZDVJ8ASQyFM3FmgZgMqwsB6mOUwRKq+IK3UfJuzBPpxtohAhPM1+LuQvk
dbjrlD0uKJqw1Tlmf6/v
=689P
-----END PGP SIGNATURE-----

--Signature=_Mon__31_Mar_2014_11_07_56_+1100_0m4m2Q../5IdSJiq--
