Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaLZEqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 23:46:30 -0500
Received: from ozlabs.org ([103.22.144.67]:47786 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbaLZEq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 23:46:29 -0500
Date: Fri, 26 Dec 2014 15:46:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tony Lindgren <tony@atomide.com>
Cc: Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: add the omap-pending tree
Message-ID: <20141226154621.08a41399@canb.auug.org.au>
In-Reply-To: <20141219200230.GJ23854@atomide.com>
References: <alpine.DEB.2.02.1412191715230.3102@utopia.booyaka.com>
	<20141219200230.GJ23854@atomide.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/koNH7f91wP5fqPp0GR=rQuW"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/koNH7f91wP5fqPp0GR=rQuW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Tony,

On Fri, 19 Dec 2014 12:02:30 -0800 Tony Lindgren <tony@atomide.com> wrote:
>
> Makes sense to me. The delay in getting omap stuff into Linux next
> via arm-soc for-next is just too long because of the large number
> of pending pull requests for various ARM SoCs.

Maybe that requires a conversation with the arm-soc tree mailtainers ...

> While at it, can you please also (re-)add omap for-next too:
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap.git#for-n=
ext

Added from today (called "omap" with you as the contact).

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

--Sig_/koNH7f91wP5fqPp0GR=rQuW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUnOgiAAoJEMDTa8Ir7ZwV7NcQAIC05rKnZSUCwta0Kel6NmOR
5fjvZspywsSFnkr4llRBRGKX0mJmocpILHc1/gGcQASYfZtFJkIuDOWHeCrU1CNd
8oNCGrfJDNv55HhEQkqMgOcYyLWIu/lnMX7oIXayVwHjQX0t+3SfN/0dLWBzbbVB
ZpXKEFBdqAfgmGNDQfr30RvoCfa5X4Fo3DzNMVCCSgS7S+BxNJ0lYktuyipnPyH0
y+LEmDQngVZII9UJbOab8Gk07gAu7XV3MoVA7TDER1kph52M4wvw6+9UJuqsuwXY
NV4ePjbdwEFx6CoQ7wcWDgTb7VYOx3FGEenu/S9QiHUXUc78z51SFD/l1gI5mtIv
rJDRA4/DWZWh+YWtxJp6Ylffuu6s8xqZ6lfhO6UvIwB+/RMzovIByyIfVUF+AlBo
/Lp6iQo8WSm35Btwj1kRMAll3woAOQwMWrggdx9vFmXdcr/JwKw2vZsCOGgY3TwO
NWCemDDfWU3gov6TYWoy/xtxUXVG3/3OTfLHJ7Jo5mXnMVLE2ECaIz+YoA+TVfl0
Usgihroo9lJss/4S9crQR1PlI1t8wCf6oKMZoxgXhsChwVPnEClKbKpOQiKpUs0P
p4bD25tqCLuzzgt2Pziw35pOdHmNQABkGo9Cy5AZD1+Jgd9Z6yiRoDdE4E/WwdPu
xIxaptasfgocxfueR3aJ
=/dAt
-----END PGP SIGNATURE-----

--Sig_/koNH7f91wP5fqPp0GR=rQuW--
