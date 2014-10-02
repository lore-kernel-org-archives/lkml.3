Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbaJBEQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 00:16:52 -0400
Received: from ozlabs.org ([103.22.144.67]:49184 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbaJBEQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 00:16:50 -0400
Date: Thu, 2 Oct 2014 14:16:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        hayeswang <hayeswang@realtek.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20141002141641.0e43a18e@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/E3brFBiNUF194zD6TFlN5BC"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/E3brFBiNUF194zD6TFlN5BC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in
drivers/net/usb/r8152.c between commit 204c87041289 ("r8152: remove
clearing bp") from the net tree and commit 8ddfa07778af ("r8152: use
usleep_range") from the net-next tree.

I fixed it up (the former removed some of the code updated by the
latter) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/E3brFBiNUF194zD6TFlN5BC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJULNGuAAoJEMDTa8Ir7ZwVOHgQAIaqqqtMDhVhBSal1iB+5d/3
MpaLGNiWn6wzr0h1T4VGeKrtyudGm7QnTOebtO5+j+kOa7XYNsz6B0PrIB34f+ai
lrioB/X3rkT7JbL/8VEWhn6Tc2ORSh92YIh5r8VJShkvMt8qOxBMk4JyJJHTw7JY
LHC7wxqzQBklC0iU6UFsFg5ocRgXqkCRAp6NXICp/n7LgZRByXg7HovFj/0qVyeX
VA9kZFZtH0GhTZ/lOcrpJyd6oDXkMnoW8bRGZA3FWiZtBZtG2N7iGzzHUaciI088
umthiPaq4FekHX23WLTuXv9QUxRr/lhoRWOpCr0x4mGz6Upz7sdWev0FPjS0y4dx
LEpSB0o67gBVWbJ8AfNu0X6A5arlArIUL2ia9WIvyhFW0EswQ3Z95NCgPvwk7LBm
dnq4z18OaKXTbKh3J0WSF9M+kIQrzErjxGyUYKNeWi3CqF4IBRGyqIMSaIzqkfHv
NpDRDM0e1+o76BpQYaABduA8YPJ1mtpM2d1aZpjF7BI5LDlhzFfoOVirVKjTLtUW
OGP+rln3vBxL9U+jh7nVP8MvFqd/htxdD8GICr+hmpTAxbh4sAzsJZBUa2tPh6qV
+vKMtu/P5al7Q9P5LRUspJSr15bmRbNZTsWKshidH7PJgftcdZimwWCAAYchhhWd
1HTJfJntUZwstgX+OsFm
=JXs1
-----END PGP SIGNATURE-----

--Sig_/E3brFBiNUF194zD6TFlN5BC--
