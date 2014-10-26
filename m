Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbaJZXT1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 19:19:27 -0400
Received: from ozlabs.org ([103.22.144.67]:41069 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbaJZXTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 19:19:25 -0400
Date: Mon, 27 Oct 2014 10:19:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: opw-kernel@googlegroups.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, john.stultz@linaro.org
Subject: Re: git tree for y2038 patches, to be added to linux-next
Message-ID: <20141027101919.1201c580@canb.auug.org.au>
In-Reply-To: <8455153.NY1892ffCa@wuerfel>
References: <8455153.NY1892ffCa@wuerfel>
X-Mailer: Claws Mail 3.11.0 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Avana/6i3q=qHgyjPviN8rX"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Avana/6i3q=qHgyjPviN8rX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

On Thu, 23 Oct 2014 22:15:24 +0200 Arnd Bergmann <arnd@arndb.de> wrote:
>
> I'm collecting patches for 64-bit time_t conversion. I'm getting patches
> for this topic from the OPW application, and hopefully soon from an intern
> in the program.
>=20
> The plan is to have most of the patches being  merged through subsystem
> maintainer trees as much as possible, but I also want to give them linux-=
next
> exposure as early as possible, in particular since a lot of the code that
> is being changed is not actively maintained.  I will send the remaining
> patches to Thomas Gleixner so he can put them into the tip tree.
>=20
> Please add
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git y2038
>=20
> to linux-next. At the moment there is only one simple patch in it,
> I assume there will be more soon.

Added from today.

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

--Sig_/Avana/6i3q=qHgyjPviN8rX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUTYF7AAoJEMDTa8Ir7ZwVcp8QAJOvIWvKk3nefzdiE3RL8i7q
NuqliJIuNwzw8Fpgwih447n8SKreOQt1jQcmsTGPsiTjwy+bSTo/SvT0hFN5onWR
E2dO6i0+oavb4QwiCflLm7mvh6WzlLf9mh693+RP0cYqDnaQr6rBbK2+BYrRWrVi
lVAXD739rkZ9+C9ajl78HCgPCrZuZ22vGHG3vAuk2LNjP2qZ6tdMu1meKiHQZR21
B+CdFZDcqtMmHTdCSpBCDV2RTIBjQfYAtDc8Izz4Qr5jFBhncQUZi5R43EBwgb4F
72z7b2bKGaiufOQSC2u/gXWTla6IfWIeEJ7OR415oPd/uVUyuge3RoVZbF+6bOT9
isrSBdl+a0Q7XGaXlXMaSOqQgrltr+Hkh5pb8Kfm3LOd0gtWVTplYnMwQ9dLeD4Z
Qmigv9vZUrPT9X0UtgOPBWJCI+oSHj+SB5/cU87CTZa9nXSwpahwxNQVMBq0jBvi
AdCymKBu6doo1DLX7NzeKvndRTMOj585bENuJ987jiGtaQainwMJxhCtzqiOElt2
pV76lSLE3GHe9RUWC/TRpGF9mkjYxEfMKEpFMVyfgDvlu4ffz6IWPNdFMKiF6hSO
ACpKso639LJFhDFl9gTv1tD0nYex0nhgeD6LyhcuUi/mdKUCzAcZR1zTnOo9OQNo
zlRO8yQBaWJVHqbYMkgq
=j0QL
-----END PGP SIGNATURE-----

--Sig_/Avana/6i3q=qHgyjPviN8rX--
