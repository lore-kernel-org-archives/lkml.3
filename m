Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419AbaDVBNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 21:13:53 -0400
Received: from pide.tip.net.au ([101.0.96.218]:41524 "EHLO pide.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbaDVBNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 21:13:49 -0400
Date: Tue, 22 Apr 2014 11:13:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: linux-next: manual merge of the vfs tree with the ext4 tree
Message-Id: <20140422111342.b44f579c60d039f93f8730ab@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_Apr_2014_11_13_42_+1000_SHwIXmNjA3xo9YXI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Apr_2014_11_13_42_+1000_SHwIXmNjA3xo9YXI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in fs/ext4/file.c
between rebased commits from the ext4 tree and commit 29a8196bc41c
("convert ext4 to ->write_iter()") from the vfs tree.

I fixed it up (in this case I used the conflicting hunks from the vfs
tree - I hope its right) and can carry the fix as necessary (no action is
required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__22_Apr_2014_11_13_42_+1000_SHwIXmNjA3xo9YXI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTVcJLAAoJEMDTa8Ir7ZwV98AP/R76X1PklBZAN2OOjOY8pHNd
oNb+hKreH+roKBghD4/AK5FGnRmvlK4S5HzUezF13wtReo1kOJAC3r0hqrDgdyzz
yDzkBx0BfBgRRB9mVImPmQJBg17QFfJHkkPQPGbIt9PUWbes4k1DTm46wxt4bcpZ
Wlu6NEM30Q/koEw+NOT00xHqAw35QAAIDRmWdEJ6y1GzOeSOprBv3HvpDr1Mi/Fa
oOKfH61EmSvkEhNMHWEB+bBxBCaYALM6hFySgw9M1zW5D4FmLOJbmYfjMnlBQbat
OY1/i4/xl3Q4yTqOQp9lAFoRNpawHKlLQ/KddtIorf9RliDi/Q/gvpsCkGShX/UA
ulXFMbUJ0lqn7X9FGmsLc7AfQt7nAjPYDSD6KNezitQB3LPznsx8eqz+LcDIBHki
SsWGt3WCmqxhInsiY8YADgrc1UKltfcTpizPnpZWUC7Mj4MTsFcseIw6pamEIF71
cqO1YxJxgzxfGcJEtPEBDpVWF5bPojfMLdY8a5C3GrdVz/WncfAfRfmVVuFclzOW
uuPbyMDra1o/C5AIwokSwc+239iPVYcpsuaoQpiz+S4MWDCljBiY6mGcvRgeOrK1
09H/FO47BkZy+sR7SvOVUPN1XSavel0NagpqsooYscsfvJiJq8K4ANDRpnHBAI3a
96rZ8pItL5C01GGSP1O5
=rYRn
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Apr_2014_11_13_42_+1000_SHwIXmNjA3xo9YXI--
