Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbaBCANo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 19:13:44 -0500
Received: from ozlabs.org ([203.10.76.45]:40033 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbaBCANm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 19:13:42 -0500
Date: Mon, 3 Feb 2014 11:13:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the btrfs tree with Linus' tree
Message-Id: <20140203111334.784d919d9ccb9c3c702b40ee@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__3_Feb_2014_11_13_34_+1100_GhcK36JCqrVb4PvW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Feb_2014_11_13_34_+1100_GhcK36JCqrVb4PvW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the btrfs tree got conflicts in lost of files
between commits from Linus' tree and commits from the btrfs tree.

Not only did you rebase/rewrite your tree before asking Linus to pull it,
but you added a whole lot of commits beyond what had been in linux-next!
I have dropped your (now redundant) tree from linux-next for today.
Please clean it up and try a bit harder, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__3_Feb_2014_11_13_34_+1100_GhcK36JCqrVb4PvW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS7t8yAAoJEMDTa8Ir7ZwVN6AP/2eNfiSDwpb8HMQJFZ7vsFH6
zrpE0cYgoc2wota4sOc0zAOEIMQ6BSDIgDx17cep+Mgxj+Be97tpKmkKAQk+mW30
XhedDdBkIeX8cCfJeMpt7uj+quxD6UJEv2fM6HQvYa63+IM6J6e8BaUCWOb7Ul3r
h9xVidEbPmhJlk1CHN9jrrZQkdlgDCfh6IVbqWy4GDR1w2KybmuSwCkXEdYTaWaF
tJuIte6nKt2WKRPUajERXAicG+16GLBkEPYae51eL44Ibj/1/c/0uvWM5yBIAzGl
rEGu3Eaxe0mV+47XXMil1blBTb2qGjXYGDyqzKEmUMPq5O0y8A36wy2q7XlXWiV6
rp1ZDTTUDnQwfaHe7ZrSVJQSQwSIIl+da45QoZnxqo/MNeBW0mN3HWTUzgwlbvaV
0ERffsSqzQ/fBbRMB490XTYNFjFRWNhrAHWlrvYyeNu+qnO/pjifVpmo9uHCOxJo
Oi8P24WblC/0JtiBaKadjEAIr3he9ydXtx/7EiVra9GmHZQ0PbRaFEn7U49nYAOM
u2o18xDeEt+iJ5akbcGTmpzBLgVHHXjwNp4nz29SWANK3ByrzVmYukWl8M9pBrIe
bD2NzssTNTVWgOJ788DXmhjBzHikyPpajLosTpLPCfUDfkRhnRlijpha84Nhn5S9
0EsubFTlj7wMH1xVa+Ae
=MXqB
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Feb_2014_11_13_34_+1100_GhcK36JCqrVb4PvW--
