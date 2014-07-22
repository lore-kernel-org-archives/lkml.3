Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933854AbaGVWvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:51:10 -0400
Received: from ozlabs.org ([103.22.144.67]:55541 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932507AbaGVWvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:51:04 -0400
Date: Wed, 23 Jul 2014 08:50:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Richard Weinberger <richard@nod.at>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: Global signal cleanup, take 4
Message-ID: <20140723085057.5d0b12d6@canb.auug.org.au>
In-Reply-To: <53CE0A25.7090508@nod.at>
References: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
	<20140722144727.441bcc2a@canb.auug.org.au>
	<53CE0A25.7090508@nod.at>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/LqKh5uz_JjdXR2DRZ3TltvT"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/LqKh5uz_JjdXR2DRZ3TltvT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Richard,

On Tue, 22 Jul 2014 08:52:21 +0200 Richard Weinberger <richard@nod.at> wrot=
e:
>
> Am 22.07.2014 06:47, schrieb Stephen Rothwell:
> >=20
> > On Mon, 21 Jul 2014 16:02:46 +0200 Richard Weinberger <richard@sigma-st=
ar.at> wrote:
> >>
> >> The whole series can also be found at:
> >> git://git.kernel.org/pub/scm/linux/kernel/git/rw/misc.git signal_v4
> >>
> >> Andrew, can you please pickup this series?
> >=20
> > Why don't we just add that git tree to linux-next? Then you can send
> > Linus a pull request in the next merge window.
>=20
> That's a good idea.
> Can you please add the tree to linux-next?

Added from today.  But I would prefer a more generic branch name if it
ever changes.

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

--Sig_/LqKh5uz_JjdXR2DRZ3TltvT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTzurWAAoJEMDTa8Ir7ZwVqT4P/0MJcpcuSMQ8M2ywy1VxnYyO
M4rRZlsy/v+0hPaxGTksb10UIYJEAp/cUppOD9ib2V0G8h1FeGop5asseiSYaBgf
sAGPimMq5ta9C0bBE7HgMl8M75Yva+St+mwaiTBCQ/U7nwvmPkWQ/Dqxil+XhNld
Kc1NElB2io2trZ215OmDkva1AlnoRK72xWWD9//6XAkhmP3QNR63oGifSUvR0cHN
gwqQzY0WfXEPN/tmOfhIiw5GoI9EjKOpj2Xaba4PI6lIYhL61CNnDuFDmOB1A/2S
mO+lmZ8xEOJp6N3+461BBtearZspgxyqKZxME/KpArfqXS+hQ7hD9+2wTgABR7FD
J9NozV3vha6cXtimTMZPq55YVFZTS5hiY4GNE7zuK1O7WUXclChYWhs/6PhIw0nF
SErVRaqVABYfEYSBy0pdMq9QUm2Wq8AYSche93VUZ0RZII6EC71Mx15CqCKwPGQc
uKZeVD5bfcrGxHto/sXscgab5dz0iNzWKN2AOMBeIQJRdgcOcTpADQazZA5Glo7F
0bqcOqEY4HoGfHGuLgeIe5OQWBQy53YawFfSzaQqv0HVusr/QNwQdB4wL4rKbFl/
vJbpiCeuyRE54N2oRntvQ674Gbev3iDyz3RjGTpPJk/FEqF9sSiJ8qT2cS9uKy/G
jkm9NbyZe8ezy3VDsSuB
=YTla
-----END PGP SIGNATURE-----

--Sig_/LqKh5uz_JjdXR2DRZ3TltvT--
