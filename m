Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbaIVWfC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 18:35:02 -0400
Received: from ozlabs.org ([103.22.144.67]:50098 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853AbaIVWfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 18:35:00 -0400
Date: Tue, 23 Sep 2014 08:34:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Please add the tiny tree to linux-next
Message-ID: <20140923083442.15400844@canb.auug.org.au>
In-Reply-To: <20140922175301.GA27348@thin>
References: <20140922175301.GA27348@thin>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/=Y/DdP+olILEj54F7_uFlbp"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/=Y/DdP+olILEj54F7_uFlbp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Josh,

On Mon, 22 Sep 2014 10:53:04 -0700 Josh Triplett <josh@joshtriplett.org> wr=
ote:
>
> Can you please add the tiny tree, branch tiny/next of
> https://git.kernel.org/pub/scm/linux/kernel/git/josh/linux.git , to
> linux-next?
>=20
> I'll be using this tree to upstream various patches for Linux kernel
> tinification.  I plan to use topic branches under tiny/* for separate
> topics, typically based on the previous -rc1, merging them into
> tiny/next; when the merge window opens, I'll submit a pull request for
> tiny/next and start merging new tiny/* topic branches into a
> tiny/next-next branch or similar that will become the new tiny/next
> after tiny/next gets merged.

Added from today.  I used git:// instead of https:// for the URL.

I do not want code for release N in linux-next until after (N-1)-rc1
has been released.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
        Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

--Sig_/=Y/DdP+olILEj54F7_uFlbp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUIKQRAAoJEMDTa8Ir7ZwVzbsP/jPHxV9dpsEH8sgZ9IzM48YX
yaX5NG69AC/ElswzywPKi6mWyL3NdOEnZbn1uWQGqUCAEqL5MO+BrrOaAxKZntcY
7cb1AGeZvFIcdxAeLtQKEuD9jccA1Ic+wUhLfhb2Gxb830+UVqhnoN/gy8T8ZCnq
Tx2uD0/rlUQcdk3UumXVhfffMgwxHPFR7a/WtisrqL0efJqLyW9Vv+q8Fq3N2zfJ
7OO11wdu2tGP4Fwq41ejfMqDTgP59EG7eLthaAufndYfleYuLj3lYp8+ORqYoxXV
jQ5FlaG/usPsU4cz76Q+7V/VGvU91SoYKh5u/p5W+wFCt+U86Shs9NwC/VuT16mK
lF/jXBgkrU82OkyjgjrVb3Slp30LlGM9AJRIFPmb4CRS5lESKipmoWRsUiG3WbLl
bv2Apr/H6Fc/6t7mvOeZ4Axzq/FGmzmuF3U2I9V6ECTEjqSAlnT2Z1UL7Du3K9q0
efVHP2AAHRvgM5qvQ/hMhWa1o9BudrnZoj7yITrkZ2pMokIV9YTjC6B6mh7ZOTUL
n+OWEcWc1Kcln8Tb/Z4ccZqswQ7EuPLU3Ju07JgWKPwz1Cg78Snpb9j/8L2LcDTu
5uZEpN7C7kKsuEuFUOcwa2pZtfMlmkRV27uQw9Cf3DeSOyCb+bxLdNdP8SumdLFf
BuU2xcyuiLBD/tAnwpkt
=/uJU
-----END PGP SIGNATURE-----

--Sig_/=Y/DdP+olILEj54F7_uFlbp--
