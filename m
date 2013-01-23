Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab3AWDD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 22:03:57 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53303 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab3AWDDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 22:03:55 -0500
Date: Wed, 23 Jan 2013 14:03:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jorrit Schippers <jorrit@ncode.nl>, Ralf Baechle <ralf@linux-mips.org>
Subject: linux-next: manual merge of the trivial tree with the mips tree
Message-Id: <20130123140348.e80088cfd9f4eacc4134051c@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_Jan_2013_14_03_48_+1100_HArZdOLYsj79p2.Q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Jan_2013_14_03_48_+1100_HArZdOLYsj79p2.Q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
arch/mips/cavium-octeon/executive/cvmx-helper-util.c between commit
baf783ede9dc ("MIPS: Whitespace cleanup") from the mips tree and commit
d82603c6da75 ("treewide: Replace incomming with incoming in all comments
and strings") from the trivial tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/mips/cavium-octeon/executive/cvmx-helper-util.c
index b72d9fb,dfdfe8b..0000000
--- a/arch/mips/cavium-octeon/executive/cvmx-helper-util.c
+++ b/arch/mips/cavium-octeon/executive/cvmx-helper-util.c
@@@ -172,11 -172,11 +172,11 @@@ int cvmx_helper_dump_packet(cvmx_wqe_t=20
   *
   * @queue:  Input queue to setup RED on (0-7)
   * @pass_thresh:
 - *               Packets will begin slowly dropping when there are less t=
han
 - *               this many packet buffers free in FPA 0.
 + *		 Packets will begin slowly dropping when there are less than
 + *		 this many packet buffers free in FPA 0.
   * @drop_thresh:
-  *		 All incomming packets will be dropped when there are less
 - *               All incoming packets will be dropped when there are less
 - *               than this many free packet buffers in FPA 0.
++ *		 All incoming packets will be dropped when there are less
 + *		 than this many free packet buffers in FPA 0.
   * Returns Zero on success. Negative on failure
   */
  int cvmx_helper_setup_red_queue(int queue, int pass_thresh, int drop_thre=
sh)
@@@ -207,11 -207,11 +207,11 @@@
   * Setup Random Early Drop to automatically begin dropping packets.
   *
   * @pass_thresh:
 - *               Packets will begin slowly dropping when there are less t=
han
 - *               this many packet buffers free in FPA 0.
 + *		 Packets will begin slowly dropping when there are less than
 + *		 this many packet buffers free in FPA 0.
   * @drop_thresh:
-  *		 All incomming packets will be dropped when there are less
 - *               All incoming packets will be dropped when there are less
 - *               than this many free packet buffers in FPA 0.
++ *		 All incoming packets will be dropped when there are less
 + *		 than this many free packet buffers in FPA 0.
   * Returns Zero on success. Negative on failure
   */
  int cvmx_helper_setup_red(int pass_thresh, int drop_thresh)

--Signature=_Wed__23_Jan_2013_14_03_48_+1100_HArZdOLYsj79p2.Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ/1MUAAoJEECxmPOUX5FEEoQQAKh0z4zTUygbQgDWUQV71Ztb
0r/9KcZvsVwCaHplRfi4VE3YjuQdz4RzZgZ0s8lPYXSYAUnE4nG8h36XiD35Gkeh
/FHWdWXAWkj1cq4NQiL7sayqEKd6S+bWQek+5B01PlulBatmxAFcwbJefW034bwm
cWrHtdAk8UKIdMY2QUzJ9zv3jKNek1zeFV86J1Mqmaof87cF9S+a6Ici8B6kd9Eb
D+v5pIxWqL4dFWaL6azCWAnWLLjgtTqQPgKeDkkqaw5AOTHlYmCIdd6lLm1Mth0D
HCsPqL4vj5WVBjFUyHUoa4NnEDcZ0RvcTN/DV7P7VlZnrXJVYEzPZdLdlDLERsNU
CkSD7KmjTcRRW3JeL1UWBl+JRY/bpXyI598hHvHCa0oXZCmctfm+ZUcpJwiOR8v7
h7HB5rtICYchis+VtLII9EiPSKT6NkjnzcTKEP1cIq2qy3oOm2TjMnjeeXyvznwB
OIbYjQEu6zSj87F0p6oZT7i/C8NWS42TaAG2aBoqMlNlXFiN9YwMfyPtQ/JqIatu
+X900t/eqI057EVB5vc7Stu3duRT1DRZuitMXpI0o7ZPVQ2qi3mdCjLCvx/7M0rS
E4DoG5DV6MFeKlb74idZ+xeMMAoBA/tBsU1JjIJCEkPCqWHJmWS0bESUsrZGu6tN
z2r5Aot6aOvolCZWfIDI
=FT/I
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Jan_2013_14_03_48_+1100_HArZdOLYsj79p2.Q--
