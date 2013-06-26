Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab3FZIvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:51:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52620 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab3FZIvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:51:41 -0400
Message-ID: <51CAAB98.6040706@canonical.com>
Date: Wed, 26 Jun 2013 10:51:36 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, hayeswang <hayeswang@realtek.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [16/26] r8169: fix 8168evl frame padding.
References: <lsq.1372214158.437609827@decadent.org.uk>
In-Reply-To: <lsq.1372214158.437609827@decadent.org.uk>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig12DB985F5CE43DC06931C451"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig12DB985F5CE43DC06931C451
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 26.06.2013 04:35, Ben Hutchings wrote:
> 3.2.48-rc1 review patch.  If anyone has any objections, please let me k=
now.
>=20
> ------------------
>=20
> From: Stefan Bader <stefan.bader@canonical.com>
>=20
> [ Upstream commits e5195c1f31f399289347e043d6abf3ffa80f0005 and
>   b423e9ae49d78ea3f53b131c8d5a6087aed16fd6 ]
>=20
> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
> Acked-by: Francois Romieu <romieu@fr.zoreil.com>
> Cc: hayeswang <hayeswang@realtek.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/net/ethernet/realtek/r8169.c | 33 +++++++++++++++++++++++++++-=
-----

No abjection, just make sure that

commit b423e9ae49d78ea3f53b131c8d5a6087aed16fd6
Author: fran=C3=A7ois romieu <romieu@fr.zoreil.com>
Date:   Sat May 18 01:24:46 2013 +0000

    r8169: fix offloaded tx checksum for small packets.

    8168evl offloaded checksums are wrong since commit
    e5195c1f31f399289347e043d6abf3ffa80f0005 ("r8169: fix 8168evl frame p=
adding.
    pads small packets to 60 bytes (without ethernet checksum). Typical s=
ymptoms
    appear as UDP checksums which are wrong by the count of added bytes.

    It isn't worth compensating. Let the driver checksum.

    Due to the skb length changes, TSO code is moved before the Tx descri=
ptor ge
    written.

    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
    Tested-by: Holger Hoffst=C3=A4tte <holger.hoffstaette@googlemail.com>=

    Signed-off-by: David S. Miller <davem@davemloft.net>

is included as well.

-Stefan


--------------enig12DB985F5CE43DC06931C451
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBCgAGBQJRyquYAAoJEOhnXe7L7s6jnSUP/jy0lFCN5JtavPVVEPt74gmL
upYLU0xwCCfGVr+ApkP4s92nEgoirLuEtngyVlSprLQlI3SoXYgOfB7WVu0D6Ts/
r1hqGbVDJVGCmt7y66S4pY7kwSX5FvUSzUdKQp4O0FjSH0RH/2vt0q63BO4ZuxRI
l2p5682gM1Lk1ELB0OSoGcHZ12ejxj9u5FZPf0zmIEdLhj6G3iueC/IrZnhP2zex
1+PB/3EF3dqup60dfnzuP/uK6Bt2t9Cw8z3+nxpZ4U+ExRDXLs1QR1xZy6v/NzLG
UQawYABuwethKHm+LTlWcogieAcjx6w9FjFaMUzj8h6Q7ZXcOOM0vLWP2OlEEgXk
g3LX4l3p77VHsnqKjhEELr2T5uFQVJJA+zRNQYKRFq7F7zgg/vEID///dLFmzmUz
rq8XBrL1jG84/fV1lA8lm9QrhiKrxigwwuA7P3+aF/6rayxZULzLn4+ScKWmRP+w
hdpwT06EQsnHgn0nLaRZKUc8LsTPiRn6xaNhXc+cvsUU6O3rk+3BWjyo4SAa6jJ5
dJcCfyjnafDLo0eIUmG0hNF3oFGR7fnWI1SQxBdwwwXDZ4phlsvU1gY9bBJzOU+Q
fy2+0OJ6tvujS2Gr8S4vys9P5o/oQXWeNHQrn3yhpU9RAJsbjxvYjPd0e28uWq/t
u7e43JqbsNynYVJ4eXNF
=+2RH
-----END PGP SIGNATURE-----

--------------enig12DB985F5CE43DC06931C451--
