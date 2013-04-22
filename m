Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab3DVOdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:33:08 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58299 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755317Ab3DVOdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:33:05 -0400
Date: Mon, 22 Apr 2013 17:32:32 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sourav Poddar <sourav.poddar@ti.com>
CC: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <khilman@linaro.org>,
        <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: Re: [PATCHv2 3/5] arm: omap2+: serial: remove no_console_suspend
 support
Message-ID: <20130422143232.GC7508@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1366638237-6880-1-git-send-email-sourav.poddar@ti.com>
 <1366638237-6880-4-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bKyqfOwhbdpXa4YI"
Content-Disposition: inline
In-Reply-To: <1366638237-6880-4-git-send-email-sourav.poddar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bKyqfOwhbdpXa4YI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 22, 2013 at 07:13:55PM +0530, Sourav Poddar wrote:
> "no_console_suspend" is no longer handled in platform file,
> Since the omap serial driver is now adapted to prevent=20
> console UART idleing during suspend.
>=20
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Rajendra nayak <rnayak@ti.com>
> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>

looks alright:

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--bKyqfOwhbdpXa4YI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdUoAAAoJEIaOsuA1yqREPlUP/0IA0x0biHeVTyBoaKEPU69z
zC/0subtmuqyRLVqpcvG9y19QSDvAH58+jlOzr1ZRYZ7DFQ5d8kO+OtAKO1uikWh
0DvqqAQ0VBcaG/+raY2gvvbumLy3JTkOlxJzDm5UwKzFRWfMcyz+RJXvhpQwduZi
F760SYoYio0IbbrTIwbncxAPUb9gMXjXAccT2yecp3at3ddI6oI/4pyivGCQV1By
Jzh2YIRsDsJB/tnyGyChkZO6tPxC/upnsOB7F3RYhBxmSiv2Uu59zQwjwLyGZatS
WxkCTCDLw+CkySO0PsyeOnmTOgfnRYTX+YX/2//H9E7ddy2bmVNYIeeua7y7SMyz
LLL1B98xJKpijAkL25zZFdC3t2Zo7h4aMxrNZ1fATM4cMFcbouUb5n3MEbTZLZHK
7Y0aeRWiGGCTekgjuqROUqCc1x+MAKSclCbf8HWclRX68QZXVZGwa5vEdsWSBRsu
fBwm3w7cZHDBfcFcZno5CafHZaTXB6xJanzyzR46tj798Vc5mVv6NS1IshzLNLQJ
YnJv95/749iKy7qfvWqJ2vW7s6afMAgQzSoQr72NQoMLINHWKyG5YRLZdYnYO9sA
ZQ1wrV1V+dExk8xofkMWV7SCrICBcZUchGtntczPO3FbztkfDYnOdA9gK5K0/GtC
lz2wCPQ1QuWPrOqncRhF
=9BNX
-----END PGP SIGNATURE-----

--bKyqfOwhbdpXa4YI--
