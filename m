Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaHKBnS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 21:43:18 -0400
Received: from ozlabs.org ([103.22.144.67]:48988 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbaHKBnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 21:43:17 -0400
Date: Mon, 11 Aug 2014 11:43:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>
Subject: linux-next: manual merge of the pm tree with Linus' tree
Message-ID: <20140811114309.1426067b@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/=CGwKOD1=eH3=syU/3wkRPC"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/=CGwKOD1=eH3=syU/3wkRPC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next merge of the pm tree got a conflict in
arch/arm/mach-kirkwood/pm.c between commit ba364fc752da ("ARM:
Kirkwood: Remove mach-kirkwood") from Linus' tree and commit
bb3274b6442d ("PM / sleep: Rename symbols, functions and variables
related to sleep") from the pm tree.

I fixed it up (I removed the file) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/=CGwKOD1=eH3=syU/3wkRPC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT6B+zAAoJEMDTa8Ir7ZwVbLgP+wS6DIqM0s8jgTTE0XCQK7eF
VWMsfYXuWew4Asycz3gUcJt6KapNglFh6xaBU8KL4pOU6JkUk9ESPgf+9C69fo50
B4p573xRpMt2Xmy1XVJodUaXG2VdQWVkMqXxTmvxSqWomvFSGhTn9mCAU0O22bQA
Q33bKV8ad/10F1JBdXxSLDIgL6wv/32wiv+/7d5BcSPBihPLIBnbPY3wJMSsHi/Z
dImgA5hz90tb3i+lwA0Xlp1knB6Xk4IshPr3em2BuGbNcQgAZRQg6+Nwkskzrj28
HXneRy62L/AoHZzKLv1+Gh/nbe5sh9yhGSRERuDCn+vZfCgXpFIw8CVRZWB4GAbR
l/Lj1MVIJ4QxOOM1YTUFw6YXHeclNyCSoz/Xiq7wT6tg+lj/xcM00IcRkopDIXkp
pJBm56pxiLTkAUxzP/0FyBeIeSwrMDN4W/LKeds4dKS/7JJJanmorrHe113Jf0wX
8wckOyhgZzL3Rc79dewCxHEFoCE6lxW307g8dXPZ006VD5kqepspgjSkMHlWrn61
k1OqKgSxLY3CZJMH+YYkY8AfZP1sGQr6os5/C6YfKXWyS8ewIk6E4YyfLPJWyCWo
vQnBnPvaTn1SBh56h8VJqVsBrJHWHivIgVeq3YvMrJWbwuO95tjVZe5Qde9bx0vw
smkaFvl4R5S0eDWJLF2+
=bf3o
-----END PGP SIGNATURE-----

--Sig_/=CGwKOD1=eH3=syU/3wkRPC--
