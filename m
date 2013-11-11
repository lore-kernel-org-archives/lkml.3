Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab3KKMdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 07:33:06 -0500
Received: from multi.imgtec.com ([194.200.65.239]:52377 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293Ab3KKMdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 07:33:00 -0500
Message-ID: <5280CE62.6040404@imgtec.com>
Date: Mon, 11 Nov 2013 12:32:34 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-metag <linux-metag@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Hogan <james.hogan@imgtec.com>
Subject: [GIT PULL] Metag architecture changes for v3.13
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="R4lvXFbJq4JWqwSrSjGDtQSTULREN2KG3"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_11_11_12_32_54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--R4lvXFbJq4JWqwSrSjGDtQSTULREN2KG3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull the following changes since commit
5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52:

  Linux 3.12 (2013-11-03 15:41:51 -0800)

which are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jhogan/metag.git tags/met=
ag-for-v3.13

for you to fetch changes up to 51387306b5c2b0c9eb1e2556de1b37267bb2b583:

  metag: off by one in setup_bootmem_node() (2013-11-08 11:23:00 +0000)

Both changes came fairly late (hence being based on v3.12), but have
been tested in linux-next and are relatively low risk.

Thanks
James

----------------------------------------------------------------
Metag architecture changes for v3.13

- A change to remove the last dependence on bootloader exception
  handlers so that QEMU can more easily boot an SMP Linux/Meta kernel
  image directly.
- A fix for a minor off by one error in a BUG_ON condition found by Dan
  Carpenter.

----------------------------------------------------------------
Dan Carpenter (1):
      metag: off by one in setup_bootmem_node()

James Hogan (1):
      metag: handle low level kicks directly

 arch/metag/include/asm/tbx.h | 19 +++++++------------
 arch/metag/kernel/setup.c    |  6 +-----
 arch/metag/kernel/traps.c    |  5 ++---
 arch/metag/mm/numa.c         |  2 +-
 arch/metag/tbx/tbidefr.S     |  2 +-
 5 files changed, 12 insertions(+), 22 deletions(-)


--R4lvXFbJq4JWqwSrSjGDtQSTULREN2KG3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJSgM51AAoJEKHZs+irPybfLXQP/Rq7gJmWJ4jjBvlkkRQPtAIf
bS0OEoegjVzvG7xdS9iqni5S8YaEiUUU/J4wljmhMbdXB4HxfEv3KFwgovG7dBOj
wUc/OSdRjA9wSg4NzH6ZRxppZUlR007hfYjGfsoZ/A21BFE6YFkjqXm4XVzmPqoQ
cT0EsNmAol8KVmbdchY0HT8lo/6BZal7g58G42T5pH6lyQFJ3V5Z2Y5hJxNvmreD
5mQq+TwZxzXdnbXSLD5Z6lNzzkCsNjd5dOcz+9nW9ySdbEOHI5U7MVPe6ahncrUf
rhkuwT9RL9gr6hUm9CR1DolcAu1fQm5AMa/6cB+2Xa5zPLXOC0NOWLJ7DfUu367k
OZ5+WukkuUzxwXdD7I3g557KdG+jA0O5xOsVP1vh/U2aUvODZ5x096DEcaASIdw9
IY8aIqZlur+WES6PuBADipyVL8nwRdrInUlxXeN3mvONgFpDmrUoMfnnA1EQ0F0M
CeAF6hbq6aMtX3jVVfsctKCdCU5epj8g/rChSvwhzmJhWUgJqiLT+OaV0Gf1UuVp
j+c/v+6xBYaF/3ebOkioN2Nlnrlj4kTicELyGSwyQmEWtqSLyCG5HsEUy2QFUTwf
0hlojzIKTu0HSF+P6D9LwIkSC3qm4ASAJE+OOhLLnhdnofuF8eHYOzdDsXHPUJ2W
ltOpC4hu0+wDCMlzN05B
=2KEV
-----END PGP SIGNATURE-----

--R4lvXFbJq4JWqwSrSjGDtQSTULREN2KG3--

