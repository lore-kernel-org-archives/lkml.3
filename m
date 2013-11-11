Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab3KKB72 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 20:59:28 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:43302 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab3KKB7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 20:59:23 -0500
Date: Mon, 11 Nov 2013 12:59:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Kleikamp <dave.kleikamp@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the aio-direct tree with the vfs
 tree
Message-Id: <20131111125920.0d6f6937cc64b96d516a960c@canb.auug.org.au>
In-Reply-To: <20131111125328.ef8f0641ccdbb28a0d0564da@canb.auug.org.au>
References: <20131111125328.ef8f0641ccdbb28a0d0564da@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__11_Nov_2013_12_59_20_+1100_XT3dShF/dOTW=60T"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__11_Nov_2013_12_59_20_+1100_XT3dShF/dOTW=60T
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 11 Nov 2013 12:53:28 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> There may be some question as to whether file_readable() needs to check
> its filp argument for NULL, but that would require auditing all its call
> sites.

Ignore that ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__11_Nov_2013_12_59_20_+1100_XT3dShF/dOTW=60T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSgDn4AAoJEMDTa8Ir7ZwVzTcP/Aur08WqgsnVbftEVA3zA0Mq
dMz8gcR255BIwUemySsGZlTpi7Zn9NqM0A7PzxCnm+ycapcrvFwZk6n84342nmxB
AD2MHyUMiBxupycKQAqFyyPBLMwoqp6SSWaiAQYjo064Ppd2RNVjuCs3uUZHZFyf
UgRSV0lH96b3GF3vKqY7BNJj4VTsGs334O18Err9y41fRTLV/38NkjYsaHNcVLDr
GKlCC2cJ4Ma3UjhrC5cjgMyQHot74/WACj4l2DbahdnayhejSDMDyr+UZyGn0Njp
Q+As5CmuK+83WKUNGp+be0WgLthxOgupCOQM+FGKBMeFRBH4uK5qkRD7zMKJRNBu
VCd1aaEhgZ7dccbHQP9Wuxik284CS3reMKE+nV2llr2S0PHVkkBkIE8Cb9HVZlDk
jShlUfLvBwnTd6ZuFXL+bflbN67YPMgA3R6JLXW5Wnq3pA7cE0BlOupMpwO6r+Ln
KIqA9ajOpWoZuGgJncRcvmMpWDLAPr4AvhHUcsU1MIrlrXa3JJU9FSWkwGDyXyz5
4LI+d4oX66LUcVtjg2/BzMxcug4wuK3UIiE00xAS9eTvFFIwGG/t5bgR4BOnp7Am
XAsEEkxYx5bwhmJPSXepZQlqcnBpfeISiAKxe/Dv8OMKm0CXSDhbsW8PzUbrqpJs
n/5j7XdT0mrJvObrp/+9
=P4sK
-----END PGP SIGNATURE-----

--Signature=_Mon__11_Nov_2013_12_59_20_+1100_XT3dShF/dOTW=60T--
