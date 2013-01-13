Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab3AMGFB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 01:05:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58623 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746Ab3AMGFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 01:05:00 -0500
Message-ID: <1358057095.4514.75.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [add to stable] ftrace: Do not function trace inlined functions
From: Ben Hutchings <ben@decadent.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Sun, 13 Jan 2013 06:04:55 +0000
In-Reply-To: <1357681121.5190.42.camel@gandalf.local.home>
References: <1357681121.5190.42.camel@gandalf.local.home>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Y7RUhmm9ffeNFV/uNwkE"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Y7RUhmm9ffeNFV/uNwkE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-01-08 at 16:38 -0500, Steven Rostedt wrote:
> Hi Greg and Ben,
>=20
> Can you add commit 45959ee7aa645815a5ce303a0ea1e48a21e67c6a to the
> stable trees.

Added to the queue for 3.2, thanks.

Ben.

--=20
Ben Hutchings
Klipstein's 4th Law of Prototyping and Production:
                                    A fail-safe circuit will destroy others=
.

--=-Y7RUhmm9ffeNFV/uNwkE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUPJOh+e/yOyVhhEJAQqR/BAAnRal9YM9TU5RuDPMyqjK67b8F4zKR7gw
GiXbxve2fXzFlxguSETje2ZLAvC+V7GI4dSKp9FLKdZ23UR7/VS7wqCW+1U3KYOd
Euhj++H1nSDmyt2BeWMrmFchpVW7URELHCcmvBnrqQkP/NzDky/nQeUAJ16pxiVI
KKm975Ruiz2X8AAOCY1rRYsrNX77p+BgOl3yOVXxLY6fmrl/dT3HDDKzI/KMD+zp
sglVDbkcQnZ8b796wCs5i388sLwmoOap1lMoDGUA2q77Znf3+Lr4U/MNZtUhDT8h
BnbOQaY/OmF8lvgelK34ECvs0m3lBW07/2PPesQ4nFoUPZa4qq4ioaXH/REI31o2
sb/aTlv+WCc1lpaA4XwtwP4ir54CoJUF2e63TKeAZJw3h7tsHQD0ht+Fh/6lnRwU
9J9yo73b0wzPR+xz7imowHf6UBNe88tqW4wq+ZE7t1EAFbeEXmemltqIds58UKoG
5N2xa8vqsh+pCazz3SwiBJhsmT4X+07rR7EIoDZyNTNej3BQFXRouuKTjLhsJfo3
lLVGO9x5Qw4QVjzygzo66sqA0XyRqEjXnonsbrpyprmeQdCAl4/odG3rkB+phjzE
64zTUy1P8s9qDpAnlvfrIYf5N9fX/vXnjtSO/V5k04jnZ42UzuPV0TFKwq4mqsuK
x3Fk2Xg0xBI=
=4qa7
-----END PGP SIGNATURE-----

--=-Y7RUhmm9ffeNFV/uNwkE--
