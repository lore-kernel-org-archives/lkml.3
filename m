Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab3GKAEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 20:04:44 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39828 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab3GKAEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 20:04:42 -0400
Date: Thu, 11 Jul 2013 10:04:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: rebase of the drivers-x86 tree
Message-Id: <20130711100437.4e5198a27a72dcdd3f69200f@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__11_Jul_2013_10_04_37_+1000_0x0WabxcQdx+sCdm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__11_Jul_2013_10_04_37_+1000_0x0WabxcQdx+sCdm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matthew,

Why have you just rebased the drivers-x86 tree
(git://cavan.codon.org.uk/platform-drivers-x86.git#linux-next)?  You have
just invalidated your testing and made it likely that Linus will blast
you if you ask him to pull your tree.  Your whole tree was already based
after v3.10 (i.e. released or rebased after the merge window opened), so
why move it again?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__11_Jul_2013_10_04_37_+1000_0x0WabxcQdx+sCdm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR3faVAAoJEECxmPOUX5FEuwYP/jFf+hwtVU98uuUfcuqdM5ua
hlZQS/589iktEBVGlaBpld1c12eFh+z24LkrrxW4dlZ7iwqKwAr7QKVf6CK3qJdv
OrXTk8g5Jcsn36TORc7PdxidUkoKYVo0P9cl0Jg7om7MKuL1fEX7Ln+H9OHNSdEL
aQ02/HVOVZsq7XUAp9l6j4Oz99CiEro/txpZLe2fRQyoF2jYeUdtSBiltj6nQdWk
Wc8i5ArEUsv0Esvejuxy/cyz5jSpC0tO1492wr8snYf3irFqxvUlKdBCxfr9wINl
UZYIeurYw5F0z5nrmPd+ms1YCXTYofQgo49IaPGoT5M6ZzXyWdFgknVJMxp0TtEv
W07Aj4V3/2JR3Y95p8qtGCPKk+WlbQTJwvwE4U1BOQU+ux324LCyJcfC39zmH0Zc
g+Wpuccj1v8sGYST4FM16cZ9VKBiqctYlal5LIoTmfTAi1svWCjuZfcUDj+/HxPL
4BKV+PSb2FDcSKaBUrIezevsdp+15in5nv9HnguCp2WBaa6LFL2fGs08VkgrDgh4
GAqpibgVaIypgpTUoBveRRiFgL0RIJuOq4mzaF9agvYDI/N7TKsVwAR5ITcIgr4l
zvaTA6S2/TWyCY/i3jnSk6OxeJG+XAOcWsdTEdJRJSeSH+ShUyF9e8s6eYdW5kc8
3ifjMIo04Zbqu0lA+NJa
=3siF
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Jul_2013_10_04_37_+1000_0x0WabxcQdx+sCdm--
