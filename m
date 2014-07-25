Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935011AbaGYAOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 20:14:04 -0400
Received: from ozlabs.org ([103.22.144.67]:37008 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934843AbaGYAOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 20:14:02 -0400
Date: Fri, 25 Jul 2014 10:13:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-ID: <20140725101355.7946e4b9@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ZD7VHkHvLn0p3L1SxKu0dPj"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ZD7VHkHvLn0p3L1SxKu0dPj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-integrator/include/mach/memory.h between commit
3ae4e9812941 ("ARM: 8113/1: remove remaining definitions of
PLAT_PHYS_OFFSET from <mach/memory.h>") from the arm tree and commit
e6dc195c1c69 ("ARM: integrator: get rid of <mach/memory.h>") from the
arm-soc tree.

I fixed it up (I just removed the file) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/ZD7VHkHvLn0p3L1SxKu0dPj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT0aFHAAoJEMDTa8Ir7ZwVSiUP/1MVQ/MZcszu2nFFCDqce4rp
Nk/BVhBtpa8wPZPwHAzJcSiVffd73LYPuiNgjubyM0ZSIMm0ryyu7kCSGY+TjIXO
nwlQfNvoZlCsQ/h7gHvOlvx3AtnlBIhH4ZaGxAvAKeKZv6OzS/qzys3W/Z+pTuDI
MvFMhdxe3Y+3FpVBZUHxDpj52V+bGw6kwF66kf4vPreeQKDq61ENcqX919QkgMyj
DIbN7M0W/Kjvc/2W0dqIbIJOR4DyyJgawPNaXBH0ZQ1JuXY7AlY9oG7JPkOodNBL
4KSkjpFOeXIe3oz7AKRpo7O+FAajnHo0qQu/Bh+iPtPw2mcykfCIcyUp8W1IfwAj
DnJG9apWg1O4NT1uxvmB3QXk6KSyUELkYL/XB8jHtXOxARuc8Ouz7lR2ixqZlbBk
wAwxwm6DXymDVTUH3QlH2M99EnkkiX0mYY9Ghc6Ba4HrG5504lWIU4dfk54A97ik
3bBU/+VDctG/e1Vp6dwFuFN+3604DeJLsh1NEfC4SEiBM/MGALgAMhgsSnxv/lxy
gowe0KLrG/10dXPLbgkmzWZpJxYWuS772XIyvBc3Ub/wq2VTt0yFxeBQYTqkJm5W
ayEILrCMwG0Oj5g8pQW5TILXcnxZIj+ZoDCVPB/bsVbQZCXza52hcqrYLZKrWqkE
hMY7H7fOtQjlEuoULeGs
=B/WC
-----END PGP SIGNATURE-----

--Sig_/ZD7VHkHvLn0p3L1SxKu0dPj--
