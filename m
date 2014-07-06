Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751072AbaGFI0v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 04:26:51 -0400
Received: from mout.gmx.net ([212.227.17.20]:62840 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbaGFI0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 04:26:48 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: Pawel Lebioda <pawel.lebioda89@gmail.com>
Cc: Julian Andres Klode <jak@jak-linux.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ac100@lists.launchpad.net, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] staging: nvec: fix some coding style problems
Date: Sun, 06 Jul 2014 10:26:41 +0200
Message-ID: <280954076.FMFuBvGU15@fb07-iapwap2>
User-Agent: KMail/4.13.2 (Linux/3.16.0-rc3-12.gfc9498b-desktop+; KDE/4.13.2; x86_64; ; )
In-Reply-To: <cover.1404586529.git.pawel.lebioda89@gmail.com>
References: <cover.1404586529.git.pawel.lebioda89@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart9849659.i5ZEGLnPSd"; micalg="pgp-sha1"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:QXS8iJF2trHSHH/FV4O9WCeddCt9cqPYQf4CQ8x3CYKvOiWsW2j
 b8kSK1JII+WnVA3958wHe4R5n5EWQO3hVyn9cwUOfzHbUchxmiYPxlpXz9zZMVlV/zdQ1Tr
 dxuXd5c+bZVanviFaoJeu4KLyPEZvw8dWf7QCi2p80fSTzCxsKiEUgTlMsqNuy6lb6UAynI
 uPxJ5TlG3ba4pxEi6b6vA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart9849659.i5ZEGLnPSd
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"

Hi Pawel,

Am Samstag, 5. Juli 2014, 22:30:54 schrieb Pawel Lebioda:
> The following patches fix some warnings reported by checkpatch.pl
> 
> Pawel Lebioda (2):
>   staging: nvec: remove unnecessary 'else' after 'return' statement
>   staging: nvec: remove unneccessary 'out of memory' message
> 
>  drivers/staging/nvec/nvec.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)

thanks for fixing, so for this series

Acked-by: Marc Dietrich <marvin24@gmx.de>

--nextPart9849659.i5ZEGLnPSd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABAgAGBQJTuQhBAAoJEKyeR39HFBto4KsH/2xv2G50rEedyYWKUUvWwi8P
zpC0SUKt0OHQiihuWx3VaORFqZUWZoR/8mlOftu0/EUoH2YRc4AmNlBPkoMeM/pa
Xg+nKltAyYAh8iA2aZdzOdt/++LemCHmq4oYwmR8tLbzf96vtCQvSarwGoQj0NBT
HuFAS0M+PwgilJkXTUy2XtkzURiDZ2hula3xEKFgI/5nluJ3V5g4WeYmhwT4Pm7F
6rUWrz9zgPWXYHS3lYbA74I4Ib1xh5k7hlsMb/XqWq8FSX1kld8GX+WC79lOe3yY
FBLJnipU30AwvpBF4dCVPHQjB7d2q1CuErcJqa3AbRzjyz6cD35HC1IalkEG5jA=
=EGnp
-----END PGP SIGNATURE-----

--nextPart9849659.i5ZEGLnPSd--

