Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab3KPXfC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 18:35:02 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47507 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743Ab3KPXe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 18:34:56 -0500
Date: Sun, 17 Nov 2013 00:34:51 +0100
From: Frank Becker <fb@alien8.de>
To: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-edac@vger.kernel.org
Subject: Re: [GIT PULL] A minor amd64_edac fix for 3.13
Message-ID: <20131116233451.GA12189@alien8.de>
References: <20131110122638.GA17775@pd.tnic>
 <CAADWXX_FdW4vGn8N4TA_GcNBrwuqeH_=qxmK2J7K7kfAWztxPA@mail.gmail.com>
 <20131116100649.GB18306@pd.tnic>
 <CA+55aFxHO9035t=CiNTRX1XK5KSxzh8HfZ3Kaspsm6yfs2O=8Q@mail.gmail.com>
 <20131116111227.GD18306@pd.tnic>
 <CA+55aFw_gOLXdmEZsmD0Mu0x-sRt5-EOeogDAsyJHbkhzjxrmA@mail.gmail.com>
 <20131116182328.GJ18306@pd.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <20131116182328.GJ18306@pd.tnic>
Organisation: private
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Borislav Petkov [2013-11-16, 19:23 +0100]:
> On Sat, Nov 16, 2013 at 10:10:05AM -0800, Linus Torvalds wrote:

Hi,

> > Ahh. Yes. Googling for "hetzner online spam", and there's a *lot* of
> > complaints. See for example
> >=20
> >    http://www.spamrankings.net/rankv2/2013/09/01/monthly/world/volume/c=
bl/all/regular/
>=20
> Yowza, this is just great! :-(
Hetzner provides root servers for money like so many other similar
companies. Some folks use that to run their own mail servers for various
reasons.
Blaming the server provider is nonsense. I've never been in contact with
the Hetzner abuse handling. Maybe that could be improved.

> > I would suggest everybody who uses hetzner actively drop them, and
> > talk publicly about *why* they drop them. Your business may not be all
> > that lucrative to them (compared to the spam), but still..
As far as I can see it is Google who filtered the pull request as SPAM by
mistake.
I'd suggest that everybody who uses Google actively drop them. ;-)

But right, I'll open a ticket with Hetzner to ask what they do to shut down
SPAMers. Let's see what their FAQ link is.


My 2 ct,

    Frank
--=20
Frank Becker <fb@alien8.de> (jabber|mail)

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: GPGTools - http://gpgtools.org

iEYEARECAAYFAlKIARsACgkQyA90Wa3Cns0iowCdGoqy7Z3AU6xnr2olaL5vbZlW
eRIAoIbjiohmGT2Z7fNUVTVVb7mF6Pa+
=ptn0
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
