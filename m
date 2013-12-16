Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab3LPNaC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 08:30:02 -0500
Received: from ozlabs.org ([203.10.76.45]:38149 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803Ab3LPNaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 08:30:00 -0500
Date: Tue, 17 Dec 2013 00:29:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the final tree
Message-Id: <20131217002953.c767935e277d23742589e367@canb.auug.org.au>
In-Reply-To: <20131216123301.GG3185@sirena.org.uk>
References: <20131216164721.79bfe996919a8ec3576867c7@canb.auug.org.au>
	<1387177714.4280.2.camel@AMDC1943>
	<20131216114510.GE3185@sirena.org.uk>
	<1387196021.4280.7.camel@AMDC1943>
	<20131216123301.GG3185@sirena.org.uk>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__17_Dec_2013_00_29_53_+1100_gr8x/Sjo4.WvwM6t"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Dec_2013_00_29_53_+1100_gr8x/Sjo4.WvwM6t
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Dec 2013 12:33:01 +0000 Mark Brown <broonie@kernel.org> wrote:
>
> On Mon, Dec 16, 2013 at 01:13:41PM +0100, Krzysztof Kozlowski wrote:
>=20
> > Thanks for applying the patch. The commit introducing error was picked
> > up by Andrew to MM tree and lately got merged to Linus' tree:
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/=
?id=3D8d2763770c34e8ed771f0be86760eb4485febc05
>=20
> Yeah, I saw it went in through -mm - what I was wondering was why it
> wasn't causing failures in -next.

That patch was never in mmotm (which is what linux-next mostly
includes).  mmotm hasn't been updated since Nov 22.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__17_Dec_2013_00_29_53_+1100_gr8x/Sjo4.WvwM6t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSrwBWAAoJEMDTa8Ir7ZwVoYwP/AxXEEmx2195Qg0i0r2NSQrt
RSAbQbbfKtfcqkmmKngAjwlB361WDw3rei+LEoRcNK3a+wQc11xkaNSnj48PrGO6
Qb8amO+X0Qhj9OZQDyH4DKfq4YgSLOczV0jRxMFuSfFvbWKc++7N7xT2rmQ2Eosd
NVeQHCSr/5dmuXx7mrsgHQfkO0GCTShOU3FGqGCbmm5KMywt3tUcp+5iJguSDIyZ
i7CDf8Rtx1SIHZO07hpjDhv/FqRctJM+b4vUVaCAvcZD/Rl5IvMm7NbZ1qOTXTxk
N6VrCPcZC9mylKWUv9UQxG5KBdMWKENQUsv1509G3f+lLOFmB+DGvnJpHw1dEW1C
Rx9htoua8YBrEBwJSKEOd5b7KxTB0eMECcJ6zS0ULGsmno5sH8UnEyeJiDRaQDw3
yu9qFfFA0H8Km9UM5VS01qiqK8I3tt5fH63mLswOdY01bNR35SSu8ZsLXNKpJf8V
ZqyhVOuIWDXFO+h243eOHr9AFjoAlO7MDfBdMzSYIxAscySv8JAQ4qWRRxS35uBR
hVpdKN+qDa0gNmJPZwPBgBjBX8OWrvmyEwP9UvhGQp6naExiH+w4GUfos2jqDZ/0
mPhMnKnXB/X2P1G+qWg3NTddYF9TAMo3QZ622UiPJa+Kb1tOS7LlAi1DZR32cFiv
xaZAv0GjA5cVKXtYrYvs
=GsDx
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Dec_2013_00_29_53_+1100_gr8x/Sjo4.WvwM6t--
