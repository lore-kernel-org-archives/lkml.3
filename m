Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaKINNH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 08:13:07 -0500
Received: from ozlabs.org ([103.22.144.67]:52848 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbaKINNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 08:13:04 -0500
Date: Mon, 10 Nov 2014 00:12:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ley Foon Tan <lftan@altera.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, LeyFoon Tan <lftan.linux@gmail.com>,
        Chung-Lin Tang <cltang@codesourcery.com>
Subject: Re: [PATCH v6 00/29] nios2 Linux kernel port
Message-ID: <20141110001250.7fc64233@canb.auug.org.au>
In-Reply-To: <CAFiDJ5_opOE5g14y1A7X3mn3H0ZOGV0kLVhEJnSrt3n47Nn2bQ@mail.gmail.com>
References: <1415011945-3297-1-git-send-email-lftan@altera.com>
	<CAFiDJ5_6HOPH_g6+Z1GwE87qXaGtnyUZdPvFCbC7E3v0+7o3VA@mail.gmail.com>
	<CAFiDJ5_opOE5g14y1A7X3mn3H0ZOGV0kLVhEJnSrt3n47Nn2bQ@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/_.7ulH3/uPwo3YpSpOlPZFv"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_.7ulH3/uPwo3YpSpOlPZFv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 7 Nov 2014 17:24:43 +0800 Ley Foon Tan <lftan@altera.com> wrote:
>
> On Fri, Nov 7, 2014 at 3:39 PM, LF.Tan <lftan.linux@gmail.com> wrote:
> >
> > Review for Nios2 port is completed and ready for upstream. Can you
> > please add nios2 patchset to linux-next?
> >
> > The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a=
1da4:
> >
> >   Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)
> >
> > are available in the git repository at:
> >
> >   http://git.rocketboards.org/linux-socfpga-next.git tags/nios2-for-lin=
ux-next
> >
> > for you to fetch changes up to 1b9e67a57ac633f407de11b36d8f996c368a8c66:
> >
> >   nios2: Build infrastructure (2014-11-06 15:23:37 +0800)
>
> By the way, I also created "nios2-next" branch for you to add to linux-ne=
xt.
>=20
> git://git.rocketboards.org/linux-socfpga-next.git nios2-next

Added from Monday with just you as the contact.

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

--Sig_/_.7ulH3/uPwo3YpSpOlPZFv
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUX2haAAoJEMDTa8Ir7ZwVAdsP/2zth6cacJXydrKwZ9qhsbSi
uq+Y6aM+ZK/7QqYWK4cKPZZgQeDjfPtAmSngVCHS7yL018u3hPWhbOwWDpeXvgMP
seWwTW8E6isaN+Z4FgX5dN7PiOsgyXMYVefgyCpn3SmT+dXpbKv6iqw9rZnEXQud
hmH3zOoJ0LLBAiRhwOZ49YkqyC37euJivG+ex+ubKsynW+8z0UW+bCHYq6Qsl4bR
Fl9E0WMh50sbRbGF84pRwXDEY5b1JYn0k/6sNM43CndwVS5Ms/pUH9qSPpSu5IWm
h7L+tnR7bPorXnAN+7FkwuVbtUTJU9quMaW6p9BHo4dJisHApXEeIPMg1VT6K1y5
tSHRVR9y1jm8nsMEgSuzx8Pxy14ASz15GY1EhLaP9PyfNWdI+iP7y56Sbx0dx3p1
mo75gYKeKzrIZ24bZ4KjW5vgEnXqGGKt/i3gH5b27LWNbpqGpY++gIhVUcNfppqh
ta2prAuNOgGybKEJW5YH2YtorS39a/FT/g0DcVQX5Tl89rUelQ9aLOsV1Z7lCjwP
6r4wOg15L0Kao5ao5SpEbUnLDYO+HrCIjPr49EeTVv9R6K7Qo8d2AKI3AcNx4RNA
VrZP5+YXjUXKH02EUKJ9odfWtiwCDSERMY26iMWdCqniLsZ+aGK9OAdtST6GwVG2
xZ8xbeLDxfuTb3WiZ3VX
=lXGJ
-----END PGP SIGNATURE-----

--Sig_/_.7ulH3/uPwo3YpSpOlPZFv--
