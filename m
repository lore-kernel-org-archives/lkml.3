Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbaKCQJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:09:18 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42573 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874AbaKCQJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:09:06 -0500
Date: Mon, 3 Nov 2014 10:08:36 -0600
From: Felipe Balbi <balbi@ti.com>
To: Roman Byshko <rbyshko@gmail.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: musb: replace hard coded registers with defines
Message-ID: <20141103160836.GJ27425@saruman>
Reply-To: <balbi@ti.com>
References: <1414442919-28251-1-git-send-email-rbyshko@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yhze8HlyfmXt1APY"
Content-Disposition: inline
In-Reply-To: <1414442919-28251-1-git-send-email-rbyshko@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--yhze8HlyfmXt1APY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2014 at 09:48:39PM +0100, Roman Byshko wrote:
> musb registers can be dumped using the file regdump
> which is created in debugfs. Up to now  hard coded
> register addresses are used for that. Different glue
> layers however have different register addresses. The
> patch addresses this issue by substituting bare register
> addresses with defines.

missing Signed-off-by, can't accept. Sorry.

--=20
balbi

--yhze8HlyfmXt1APY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUV6iEAAoJEIaOsuA1yqREdDUQAJEOmPmSkTSCYXCOU7AQOjzo
+vBC4Xk1JN+fwS5tlknDoqAGG0N5EKFtEBK+QOHonpgddys/dpOl2/c2XWtDcmAq
ZARHe4EDGcybkTG5qZtC/dNl69JCAUT1Qh7cbqeHIiHjwzox91Ysuv/dHAfhMk1/
rhiYDwLoBeRS4Dp8dUYihype4Vm16IbQILuWpyigVEA5kx6KYWi0bUpVG8xl4eqA
ND3qKYr9bg+0FTbeWo3PjFwQpi9msrGeiOjLmx/KdxpqdaJ445jhHnP2nzfEJ8YX
l6EC9VhH85bfaclmULWwdqC1Cr3fbsda0gs7YctCitjoDhZDKceSS4J+XqHZHhEY
em1Rt9lPptPCXhE/jTD3RBD2nifAhfGkAswfqDEYncxkRykQXjoKJdYJ7jhori7H
g6McB0ReZOSLfquj9omfYQj9p4zf8AlHPMmHuKO/xvSxfrZwjexbAslhX/Zkioqu
wKM10HdJUYzxLECgjQAfF8FGqHvn8WwaOw/0xSvN59+SB+j3L/LF9ZT7ts0f9jIC
mdLpgWkc4OhtJPOX7p7uE9FigRjawtw6bwVoIq7f13MlS04boNTlozoZpD3Uws0c
zFMZ8SL/BF1ylLfI7nCrWgayorTeIXR8tshw+GNcxPEbit1wWQnC04GADBBmIcCr
AByTjqAKqaHh0SESSYIg
=0avB
-----END PGP SIGNATURE-----

--yhze8HlyfmXt1APY--
