Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbaKXTM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 14:12:28 -0500
Received: from sauhun.de ([89.238.76.85]:53717 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074AbaKXTMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 14:12:25 -0500
Date: Mon, 24 Nov 2014 20:13:47 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Felipe Balbi <balbi@ti.com>
Cc: Kevin Hilman <khilman@kernel.org>,
        Alexander Kochetkov <al.kochet@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        linux-omap <linux-omap@vger.kernel.org>, linux-i2c@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/4] i2c: omap: implement workaround for handling
 invalid BB-bit values
Message-ID: <20141124191347.GA26751@katana>
References: <1416518925-20679-1-git-send-email-al.kochet@gmail.com>
 <1416685634-5864-1-git-send-email-al.kochet@gmail.com>
 <1416685634-5864-3-git-send-email-al.kochet@gmail.com>
 <CAMAWPa8whctBR6fBFaSzPvm3qn+QK06CimRrxFxxH=0kNkF4UA@mail.gmail.com>
 <20141124191023.GG25712@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <20141124191023.GG25712@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2014 at 01:10:23PM -0600, Felipe Balbi wrote:
> On Mon, Nov 24, 2014 at 11:08:48AM -0800, Kevin Hilman wrote:
> > On Sat, Nov 22, 2014 at 11:47 AM, Alexander Kochetkov
> > <al.kochet@gmail.com> wrote:
> > > In a multimaster environment, after IP software reset, BB-bit value d=
oesn't
> > > correspond to the current bus state. It may happen what BB-bit will b=
e 0,
> > > while the bus is busy due to another I2C master activity.
> > >
> > > Any transfer started when BB=3D0 and bus is busy wouldn't be complete=
d by IP
> > > and results in controller timeout. More over, in some cases IP could
> > > interrupt another master's transfer and corrupt data on wire.
> > >
> > > The commit implement method allowing to prevent IP from entering into
> > > "controller timeout" state and from "data corruption" state.
> > >
> > > The one drawback is the need to wait for 10ms before the first transf=
er.
> > >
> > > Tested on Beagleboard XM C.
> > > Tested on BBB and AM437x Starter Kit by Felipe Balbi.
> > >
> > > Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
> > > Tested-by: Felipe Balbi <balbi@ti.com>
> > > Reviewed-by: Felipe Balbi <balbi@ti.com>
> >=20
> > This patch recently hit linux-next (as commit 903c3859f77f) and boot
> > breakage[1] in next-20141124 on OMAP3530 Beagle and Overo/Tobi boards
> > was bisected down to this commit.
> >=20
> > Kevin
> >=20
> > [1] http://status.armcloud.us/boot/?next-20141124&omap
>=20
> btw, based on Kevin's boot test, only OMAP3530 is failing.

OK, giving Alexander some time for a fix. If it can't be found, I'll
revert this patch. Thanks!


--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUc4NrAAoJEBQN5MwUoCm2xaEQAK082DTEJDKCWUS19KrPWQVv
VoGX6sogqQafjoeKvdr88NSg9IC/YjZMz7yMnnPiMt8/ynW8vuQMjk82mlCnUIvo
0w8Ge+8oD0hIKGZ2BGXWFUvPiqEaJiz3zCVOuLbvuzsmSrr1TsmVL9Y2fUsyrGr0
HfBh7KRM552hA6HC++tFUsMSfFmCiVQLOgOAARi6DSTxcOIZn4GeEwP1PeOqKy8P
dScCo/j3cC2MnLtayVuyRL+5PgWW8moqsjP5qOMD/S0jipYB/1VF6WnegWq9oDDJ
YaqGAD7gUeCjAlhuFIo9hIO/xiyZs4b78e8qDBAO/Ekeq6vEjsQeyJAGx6dhiUwn
bJMLIWHK1Y+lsMlbHP1DcKZ+UQkaufYAJP+nkZ0rxfd24UbPnLF+UgoXg80Y34t5
x2gZBYCq7qxhi1r3PQAVUWig1Et+2f1jndg0LZd7cUTYiOlHQ/oRCyAfUk/BQU1K
O8MiH1cHcQsjUPCK3uL96wQyab59wS4uYaR5BHfo977DcDXkAWZebuE9tZN/mucr
nDGAgSGajAlI4qcw3sdQCbiKsnxfZvYNSLchISj8OsoWNJZGHA2eNYYm5bW4pr95
7olnxARQg5u+u6JFagMc+sDYcNcwk7BTefZIArvGfU2CanlGtm+aZ3lGkWV1LGpQ
R8KQx20SkFFsgViPD5/9
=ckvQ
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
