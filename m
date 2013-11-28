Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750962Ab3K1FZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 00:25:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39828 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750753Ab3K1FZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 00:25:31 -0500
Message-ID: <1385616317.23855.75.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.12 07/19] tcp: gso: fix truesize tracking
From: Ben Hutchings <ben@decadent.org.uk>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 28 Nov 2013 05:25:17 +0000
In-Reply-To: <20131118183646.248381899@linuxfoundation.org>
References: <20131118183644.030738675@linuxfoundation.org>
	 <20131118183646.248381899@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Z90FvmgZRjUw68asvEwv"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.213
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Z90FvmgZRjUw68asvEwv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-11-18 at 10:37 -0800, Greg Kroah-Hartman wrote:
> 3.12-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Eric Dumazet <edumazet@google.com>
>=20
> [ Upstream commit 0d08c42cf9a71530fef5ebcfe368f38f2dd0476f ]
>=20
> commit 6ff50cd55545 ("tcp: gso: do not generate out of order packets")
> had an heuristic that can trigger a warning in skb_try_coalesce(),
> because skb->truesize of the gso segments were exactly set to mss.
[...]

That commit went in 3.10, but this fix hasn't been applied to 3.10.y.

David, this code moved from net/ipv4/tcp.c to tcp_offload.c after 3.10
and this patch applies textually after adjusting the filename.  Please
consider including it in the next batch of stable fixes for 3.10.

Ben.

--=20
Ben Hutchings
Usenet is essentially a HUGE group of people passing notes in class.
                      - Rachel Kadel, `A Quick Guide to Newsgroup Etiquette=
'

--=-Z90FvmgZRjUw68asvEwv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUpbTvee/yOyVhhEJAQrykQ//Rl7M9l6lTufkG5tVeTsB7mzLLdUDW/7A
PLTJtYDMZy8Ampwq0DlXvFvWBm0Tz+a6EToG6Xlea7G9kd7K4AkWfe6/bUNFU0By
2SUQ961FNYNvV5RN5lKb0wVYmXdSARvuCQmKXnYrvdpEsXr9/AJQlh8i3kwqE64+
05XO/Vps7H1GH3+IhnLGsNxfQFePR1HbFDT+bEckfZw8ntIQdi1t2KvO+qkBQuG2
/rAhdoJBp5oiCWylynxW1i1HronklW3iC2WBqBlf6lWlgUDwN/dNeqhxs5KMDQ7w
v/vezOWLm/nu0642HFAXDxKqe6mSNeSWF7gUtp4mUva98svzKAqEPpF4Crpeo2qX
K5X1/92CmwoRLXXvbb41+U+OseEGSQpIzJUNUCAF/miJDsKoiQyLjmH9PHoYnDpp
iPczGfQU0LDg4eB+6oSsQ7iKEJGZuzVQk0GUxQmantNHZRjQxgg6Vx4t021VeB6Z
hv923TqBJkG9s71+G/HY5zJXpayCAM0M8wm38H/4SWJvwlWINpp8wZM9o80SGyHf
SsMf/zcbYRi5aSTWCE9V3Q5v2sm0pmgUciVtWYO2csmHutTwvBWrJ09oiMpXhYnT
0ePNQBpdh1/xXmKsvQ+ZT79KOuix5+ag5fWmVz51MtO0m+LLIx8veAN3YNqKJ60F
2A3WSyF69P4=
=s49N
-----END PGP SIGNATURE-----

--=-Z90FvmgZRjUw68asvEwv--
