Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab3AWDGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 22:06:09 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45572 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab3AWDGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 22:06:04 -0500
Date: Wed, 23 Jan 2013 14:06:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jorrit Schippers <jorrit@ncode.nl>, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: linux-next: manual merge of the trivial tree with the mips tree
Message-Id: <20130123140602.221ad9463a6b8d4f2b4d358f@canb.auug.org.au>
In-Reply-To: <20130123140348.e80088cfd9f4eacc4134051c@canb.auug.org.au>
References: <20130123140348.e80088cfd9f4eacc4134051c@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_Jan_2013_14_06_02_+1100_/j.3SCoNMrYR/Cr3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Jan_2013_14_06_02_+1100_/j.3SCoNMrYR/Cr3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

On Wed, 23 Jan 2013 14:03:48 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the trivial tree got a conflict in
> arch/mips/cavium-octeon/executive/cvmx-helper-util.c between commit
> baf783ede9dc ("MIPS: Whitespace cleanup") from the mips tree and commit
> d82603c6da75 ("treewide: Replace incomming with incoming in all comments
> and strings") from the trivial tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

It also affects arch/mips/include/asm/octeon/cvmx-helper-util.h

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/mips/include/asm/octeon/cvmx-helper-util.h
index e217aba,01c8ddd..0000000
--- a/arch/mips/include/asm/octeon/cvmx-helper-util.h
+++ b/arch/mips/include/asm/octeon/cvmx-helper-util.h
@@@ -57,11 -57,11 +57,11 @@@ extern int cvmx_helper_dump_packet(cvmx
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
  extern int cvmx_helper_setup_red_queue(int queue, int pass_thresh,
@@@ -71,11 -71,11 +71,11 @@@
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
  extern int cvmx_helper_setup_red(int pass_thresh, int drop_thresh);

--Signature=_Wed__23_Jan_2013_14_06_02_+1100_/j.3SCoNMrYR/Cr3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ/1OaAAoJEECxmPOUX5FEzSUP/3aDNs3C0Eg66uiVn+XBv4ei
qgl+s2n+S+PlQAlCZANVflMuS9V3NH0mghR7WMzlrhDuQ5jH4mdMJcZNU/KTJPbM
yRKsc85iNBMhy2af1TYopGwL9n8G6/rwpVJwv1ofHOx1U/PachvShIG+6nCNtA6h
m59ebCPuVTFFKEMbhaN3Z2745NhBYproMmmNRt4jGE3A6RHV0nd90HoWOIpMq0Q9
oXc8OikjB5+/e37lG8tTFWpukbGccY0FvI5DgkO9RPJNp06lqS0h+qZq7osf0EYK
oH6sZRFShdX2Hc1NydPIsBaNKM82m7/h1pgtieLCs+nFFJAPVUZ+zahG4HgcQRAK
Ran3nLFnIQrlEytYpAxymlXvcp+g4wrHALxtXwdc1Qtj8eoPjGymiILrqH8u7L8q
K6Lt48LbpwColhywd6Wu1nYbF7Ql+OLS0TxFymTNg2ZHENbmRNE/jwmIP0sI4ZoK
dMM/kT1YwhDo6rZcOQiIpR9/aCbVliUAIF+jJtVwI5HxMVlEajXKjFo1yyt4rpDg
pd7/xDhlqCOumjM4JhGGPJqKXDJ6nsYNFb01xm9nGY0e4cOaueYQXQJpzoAE8OMv
Y7soN3rN7khcwpdZJ0bj4Q/uEOFDgAXfGvXAFIMh6kWmDITXbHA9F6RMPN2zuAhr
Wsg1ZHRabosMlY2pTrZI
=rN9F
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Jan_2013_14_06_02_+1100_/j.3SCoNMrYR/Cr3--
