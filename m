Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532AbaD1XmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:42:24 -0400
Received: from ozlabs.org ([103.22.144.67]:34727 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339AbaD1XmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:42:22 -0400
Date: Tue, 29 Apr 2014 09:42:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: paulmck@linux.vnet.ibm.com, Richard Weinberger <richard@nod.at>,
        Randy Dunlap <rdunlap@infradead.org>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        umgwanakikbuti@gmail.com
Subject: Re: mmotm 2014-04-24-13-07 uploaded
Message-Id: <20140429094211.aa10845c82f772155d12923c@canb.auug.org.au>
In-Reply-To: <20140428160501.df072b191fce77ab5d042054@linux-foundation.org>
References: <20140424200837.727695A407C@corp2gmr1-2.hot.corp.google.com>
	<535992DD.3060808@infradead.org>
	<20140425100459.7824f676@annuminas.surriel.com>
	<535AC91A.1070504@infradead.org>
	<535ACB0E.4070600@infradead.org>
	<20140427062650.GW4496@linux.vnet.ibm.com>
	<20140428135540.GA14661@linux.vnet.ibm.com>
	<535E8D14.7080405@infradead.org>
	<535E8E17.2050600@nod.at>
	<20140428200640.GG4430@linux.vnet.ibm.com>
	<20140428213909.GA16623@linux.vnet.ibm.com>
	<20140428160501.df072b191fce77ab5d042054@linux-foundation.org>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_Apr_2014_09_42_11_+1000_7YrNW7mQo=3Cqg+J"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Apr_2014_09_42_11_+1000_7YrNW7mQo=3Cqg+J
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Mon, 28 Apr 2014 16:05:01 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> OK, my tiny brain just burst.  Rik, I think I shall ease
>=20
> sysrq-rcu-ify-__handle_sysrq.patch
> sysrq-rcu-ify-__handle_sysrq-fix.patch
> and
> sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs.patch
>=20
> into the bitbucket for now.  Please resend everything when it's all
> sorted out?

And I have dropped them from today's linux-next.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__29_Apr_2014_09_42_11_+1000_7YrNW7mQo=3Cqg+J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTXudcAAoJEMDTa8Ir7ZwVgQEP/11NkHf0lMu+wO4BQClrOlHi
IiHfeTJWUvCUL/jlfa9RxSRzJ95MVk/CizmatyPO0+zvzuxBEnBN7TM/Jvf27gTd
VwHj2L5j7A0AUeCMTDOyXSrvZ2VCSpnv1GyEWw1K1S2SxyioOBfbYYkgbJooV8xs
kc48/slcRrMoZsQc6fR6QYrk6lD4K0wpvQghQFI3NLtA1lpZie+n9CNGnAk+QGUi
FVKeAJsiT4BaJGDOgpMDKspiouNHLg9sswMOVNjAkG4Gc1fX4rfjDOtnmRaSHThP
SNdjpC1acwmisM3FGEJUE3hi4Bxh9wgm2xrPfQVKJAp9ZOvR1Gw91pUoy9XlUzqo
NkjfR72RDCLr9eKyJnDhS0bmuhKfTfc1MuP8SDvr+T8cwhzECUgIXaUCVQjBN52S
5hGD3rRPMl9x3060jQeweVaOn9pwNeLgDqbK7a+O0Bw3A4OiHJFURFzGsqnIeWYA
61o+Q6yGEQg9OP+hcXCZE8xAs8EQwm9vqx+9YuD1/J206Fw8Kjde4uFJj0SOX7mU
NpRLdgQXKtdHv01bGlYiMXXe1EuHtGqn9tvEU/RnhZ1nth+p9GK7zTX2FV3Lb99l
rKDTvsPxDfX8qYuhhDQYwdhZ5XQ060LrZIvaIzldImA75ud2QkVQREOT4+rphDx3
L8TxldWXA8Tqf2g0QbeI
=5rWU
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Apr_2014_09_42_11_+1000_7YrNW7mQo=3Cqg+J--
