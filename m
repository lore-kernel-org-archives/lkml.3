Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbaLVLhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 06:37:54 -0500
Received: from vm1.sequanux.org ([188.165.36.56]:43911 "EHLO vm1.sequanux.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbaLVLhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:37:52 -0500
X-Greylist: delayed 493 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Dec 2014 06:37:51 EST
Date: Mon, 22 Dec 2014 12:29:33 +0100
From: Simon Guinot <simon.guinot@sequanux.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Ryan Press <ryan@presslab.us>, Nadav Haklai <nadavh@marvell.com>,
        Greg Ungerer <gerg@uclinux.org>, Benoit Masson <yahoo@perenite.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "klightspeed @ killerwolves . net" <klightspeed@killerwolves.net>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Florian Fainelli <florian@openwrt.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Simon Baatz <gmbnomis@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>, Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 00/27] ARM: mvebu: armada-*: Relicense the device tree
 under GPLv2+/X11
Message-ID: <20141222112933.GK19261@kw.sim.vm.gnt>
References: <54930BBC.4060602@free-electrons.com>
 <20141218191528.GY967@titan.lakedaemon.net>
 <549437DD.7040602@free-electrons.com>
 <20141219160230.GZ967@titan.lakedaemon.net>
 <54944DAC.1000709@free-electrons.com>
 <20141219170328.GA967@titan.lakedaemon.net>
 <54945C5C.2080801@free-electrons.com>
 <20141219174300.GB967@titan.lakedaemon.net>
 <20141219181616.GG19261@kw.sim.vm.gnt>
 <20141221235000.GC28117@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CQDko/0aYvuiEzgn"
Content-Disposition: inline
In-Reply-To: <20141221235000.GC28117@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CQDko/0aYvuiEzgn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 21, 2014 at 06:50:00PM -0500, Jason Cooper wrote:
> On Fri, Dec 19, 2014 at 07:16:16PM +0100, Simon Guinot wrote:
> > On Fri, Dec 19, 2014 at 12:43:00PM -0500, Jason Cooper wrote:
> > > On Fri, Dec 19, 2014 at 06:11:56PM +0100, Gregory CLEMENT wrote:
> > > > On 19/12/2014 18:03, Jason Cooper wrote:
> > > > > On Fri, Dec 19, 2014 at 05:09:16PM +0100, Gregory CLEMENT wrote:
> > > > >> On 19/12/2014 17:02, Jason Cooper wrote:
> > > > >>> On Fri, Dec 19, 2014 at 03:36:13PM +0100, Gregory CLEMENT wrote:
> > > > >>>> On 18/12/2014 20:15, Jason Cooper wrote:
> > > > >>>>> On Thu, Dec 18, 2014 at 06:15:40PM +0100, Gregory CLEMENT wro=
te:
> > > > >>>>> ...
> > > > >>>>>> Jason at the end it seems you didn't ack or nack the patches=
 were you
> > > > >>>>>> were CC. You expressed some concerns about the GPLv2+ move b=
ut I don't know
> > > > >>>>>> if it is something that prevents you to give your acked-by.
> > > > >>>>>
> > > > >>>>> Oops.  :)  I figured my S-o-B when applying would be sufficie=
nt.  That
> > > > >>>>> decision was before we decided on Andrew applying patches thi=
s time
> > > > >>>>> around...
> > > > >>>>>
> > > > >>>>> For all my dts{i} contributions:
> > > > >>>>>
> > > > >>>>> Acked-by: Jason Cooper <jason@lakedaemon.net>
> > > > >>>>
> > > > >>>> Thanks :)
> > > > >>>>
> > > > >>>>>
> > > > >>>>> Due to all the merge commits over time and whatnot, it's prob=
ably best
> > > > >>>>> to put my Ack on all the patches in this series...
> > > > >>>>
> > > > >>>> OK no problem. By the way, I take care of collecting all the a=
cked-by and
> > > > >>>> once it will be done I will either sent the updated patch set =
with all the
> > > > >>>> acked-by or maybe just I will create a branch to pull if it is=
 easier to handle.
> > > > >>>
> > > > >>> Ok, that'll be up to Andrew.
> > > > >>>
> > > > >>> Once we have the last few stragglers, and assuming there are no=
 more
> > > > >>> NAKs, here's what I'd like to do:
> > > > >>>
> > > > >>> Regrettably, we'll have to revert Simon's dts contributions.  I=
 say
> > > > >>
> > > > >> You missed the email he sent yesterday, finally Simon changed hi=
s mind
> > > > >> and gave his acked-by.
> > > > >=20
> > > > > Indeed, that was for the oneliner change in the armada-370-xp.dts=
i file.
> > > > > I got a bit ahead of myself, but I'm looking towards kirkwood, or=
ion5x,
> > > > > dove, which brings up:
> > > > >=20
> > > > > 18ba7e4fe51d ARM: Kirkwood: add DT support for d2 Network v2
> > > > > 2d4cd2cafaea ARM: Kirkwood: allow to use netxbig DTSI for d2net_v=
2 DTS
> > > > > a96cc303e42a ARM: mvebu: update the SATA compatible string for Ar=
mada 370/XP
> > > > > d3dde4df4483 ARM: Kirkwood: update Network Space Mini v2 descript=
ion
> > > > > 98d4f2acb91a ARM: Kirkwood: DT board setup for CloudBox
> > > > > 4ea931e07d77 ARM: Kirkwood: fix ns2 gpios by converting to pinctrl
> > > > > 7f9871d9d30f ARM: kirkwood: DT board setup for Network Space Mini=
 v2
> > > > > ca7d94524ab3 ARM: kirkwood: DT board setup for Network Space Lite=
 v2
> > > > > ecee1e47ab42 ARM: kirkwood: DT board setup for Network Space v2 a=
nd parents
> > > > >=20
> > > >=20
> > > > OK I understand your concern now. About dove and kirkwood, did you =
notice that
> > > > some files didn't have any license?
> > >=20
> > > Yes.
> > >=20
> > > > Especially none of the dove files have a license.
> > >=20
> > > Yes, we'll cross that bridge when we get there.  I suspect it then fa=
lls
> > > under the over-arching license of the project.  Regardless, we'll sti=
ll
> > > need Acks from all contributors.
> >=20
> > Hi Jason,
> >=20
> > What is the problem with keeping the LaCie DTS files under GPLv2+ only ?
>=20
> Converting armada-* to dual license is just a small part of the
> overarching effort to convert *all* the devicetree files to dual
> license.  So, eventually, we'll be doing the same with kirkwood, dove
> and orion5x dts{i} files.  Perhaps even during this merge window.
>=20
> In the long term, we're attempting to provide one neutral place [1] for
> the bootloaders and kernels to pull devicetrees from and contribute
> changes back to.

OK, let's see if I understand correctly.

If I don't agree with the GPLv2+/x11 relicensing, then support for
almost all the LaCie boards will be removed from the Linux kernel (maybe
during the next merge window) ? Is that correct ?

Since all the LaCie boards DTS are at least based on my work (except for
the Orion ED Mini v2), I think there is 12 files concerned here. See the
command output: grep -l lacie *.dts | wc -l.

The oldest of this boards have been supported by the Linux kernel since
the 2.6.32 release. Also some of this boards are still widely used...

You know, it is quite a statement you are sending here: The GPLv2+
licences are not good enough to get an ARM-based board supported by
the Linux kernel, while it has always been the case until now. Are all
the maintainers SoC, ARM SoC, ARM and Linux well aligned with that ?

Is there any way we can keep the LaCie DTS files licenced under GPLv2+
_and_ still distributed with the others. Anyone would be free to choose
to use them (or not), in respect of the licence terms.

Simon

--CQDko/0aYvuiEzgn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlSYAJ0ACgkQgtp0PDeOcDojBwCgkd7a/NHUbNcQsgLJf0Di3FIA
E5gAn3n0JOD+YOAuf9trB33GqmTy9jf2
=ETFE
-----END PGP SIGNATURE-----

--CQDko/0aYvuiEzgn--
