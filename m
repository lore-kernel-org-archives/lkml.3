Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab3HMBdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 21:33:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45580 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429Ab3HMBdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 21:33:37 -0400
Date: Tue, 13 Aug 2013 11:33:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the ext4 tree with Linus' tree
Message-Id: <20130813113333.016c4c319edb0ac9c249ea2d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Aug_2013_11_33_33_+1000_nKXoFj2UyNd=VOl4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Aug_2013_11_33_33_+1000_nKXoFj2UyNd=VOl4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Theodore,

Today's linux-next merge of the ext4 tree got a conflict in
fs/ext4/ioctl.c between commit cde2d7a796f7 ("ext4: flush the extent
status cache during EXT4_IOC_SWAP_BOOT") from Linus' tree and commit
0dee1a241030 ("ext4: swap all the extent_status LRU fields during
EXT4_IOC_SWAP_BOOT") from the ext4 tree.

I fixed it up (I guessed that the ext4 tree version is a better fix(?) so
used that) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__13_Aug_2013_11_33_33_+1000_nKXoFj2UyNd=VOl4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSCYztAAoJEECxmPOUX5FEdCQQAITI8ipXEku6jM7fpusGNXr2
7TaXaWN1BqwkXZt2KyfCzwdPjiu7wypAs9bf/XbQbTtVS8+OGj3wnobZzkNeCuDb
ZQGpLqJvKNHPoWpaRuEbBOkLalopwqdX9N1x6XARBkq+psLk5TZgMo07NWAwjsOQ
Z2gTqsS5H64udVLpuIBnyHAYJj90AJQYkyb/rsxt5Z8ET5j93m2z3vtw2zdK/qed
hcny76DlFLSl3xzfY0H1fVO2irEgPY2B7TfCm8AR1CGYPhdkvbEVPCt0HsbhHyM9
aVPIpUoWVFFnGHl6sEmxR6w3/JoqZq31/nfStZXLsnl21W/iVHukrLTej5gsLRVW
xbXB+ebmymvhgFQ2/DXweSQGxNkqv94RTRWtIi2t9HMAr4i0bLKkJ3Wc3bTFyXwn
R6eJs/MgH/0IbwYjgqu4hOwMF+kFiH8mP56ao6uDJqhRqdq8Ye8uDMN9Uyvkg59l
HAQLASEqGKtwWOAtqWi6YYQs5Fb/5dyXLKKMeGDnAnRhzwj0S71R7gALFub+uumw
1dWVwDcWspskzbGQ83r5tU94Dr4MjHWKNUJ5ZWQx656Sdbe3ZyCLirKsqxSrJs8N
g51TbdCqbHgoJ30YIFsQrFxlig8MCHO5PvFJr8hjXaLNohMiO0ew+3RrheeJHI/U
XLv61onncR24mrJpy5JY
=bKJe
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Aug_2013_11_33_33_+1000_nKXoFj2UyNd=VOl4--
