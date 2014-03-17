Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251AbaCQCct (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 22:32:49 -0400
Received: from ozlabs.org ([203.10.76.45]:47389 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755818AbaCQCcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 22:32:47 -0400
Date: Mon, 17 Mar 2014 13:32:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: linux-next: manual merge of the hid tree with Linus' tree
Message-Id: <20140317133232.c18d3d977ecf8466f9959a8f@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Mar_2014_13_32_32_+1100_8Ugo4k6G6oI=a_lx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Mar_2014_13_32_32_+1100_8Ugo4k6G6oI=a_lx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the hid tree got a conflict in
drivers/hid/i2c-hid/i2c-hid.c between commit 9d27f43274e4 ("HID: fix
buffer allocations") from Linus' tree and commit 649f94790314 ("HID:
i2c-hid: use generic .request() implementation") from the hid tree.

I fixed it up (the latter removes the code modified by the former, so I
just used the latter) and can carry the fix as necessary (no action is
required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__17_Mar_2014_13_32_32_+1100_8Ugo4k6G6oI=a_lx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTJl7EAAoJEMDTa8Ir7ZwVzY0P/AlciGvWxOpazljxC4+suQc/
fQcUAU5ngfSPJhjPKSry8IQLJCleF+DhbNrbHwUwXbGxCWbfN+PthYcJTXyVd/dx
hZKthWhvy97Hfam1eFYppmfdXaYtHdYao1tmEThZeKWzqZxKns+YIq70muZIZScL
G2PbFTwlLo2Fx7upWOnGIvqmnFI7xsAIc8pK4tXVjmNQ+qvaFci5Sqx6t+imD+p3
audugdN7vWEXe2rDpBRR7oEesHlC5iCs5XNofO7gVKJT7dWmtXKDYgZMrub3WYtf
gS4YNgnsJ7NIfAL+K32rRESVOVavxvqJA1G9oH+7IhfSLJ/drTpKbkzeQanavOzP
Or4KuIjlOdY5UkQduoRT0gpGeV0jQXqnr8OYPU/KJUjHWPdPGITlye6t4Usp8S81
gDgoW9w3CABeLZEHjX22oCCbqg1FCrgYVVU0plGBYavFawi0YYahKZ0SoEwdGVN0
DGSKtZ2A4GgOJhOBbdUPs/ex/Gl4HBdcGOkaQYM5bT0uUhhtjmPOSNvAmcXDlU7a
KOcWd8dSAR7n/Wc4IHhPiLzGQA231lda+gl1m8KdnaUGRoaDy9ThgI092PnU/Cim
BreQX1KJ7odAgXfQP6r9vx8PtKfEEdJwvxSuL07DC7tZc+1xVmmdD7Fo6JrRMdyi
YzY/8RfctOPilsFu7eTs
=p/a8
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Mar_2014_13_32_32_+1100_8Ugo4k6G6oI=a_lx--
