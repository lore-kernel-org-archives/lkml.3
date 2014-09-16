Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaIPIrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 04:47:23 -0400
Received: from ozlabs.org ([103.22.144.67]:32999 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437AbaIPIrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 04:47:20 -0400
Date: Tue, 16 Sep 2014 18:47:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tetsuya Takinishi <t.takinishi@jp.fujitsu.com>,
        Mollie Wu <mollie.wu@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        Andy Green <andy.green@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Request to include Mailbox tree in linux-next
Message-ID: <20140916184709.7fb9a885@canb.auug.org.au>
In-Reply-To: <CAJe_ZhcRs45Rmzpjb-O+A=+HCUt9SspdgPofMkqd5+xL=TYwDA@mail.gmail.com>
References: <CAJe_ZhdZTSs+Ns4u7bMXwbLHYTnE-5XEE8uev4zXbXrCP52bSg@mail.gmail.com>
	<20140808142912.7bf68229@canb.auug.org.au>
	<CAJe_ZhceR1j_b-_efJoq9Dv6X6C=UuMgyp8AofjcCvc+bQVkfw@mail.gmail.com>
	<20140808144137.GE30282@n2100.arm.linux.org.uk>
	<CAJe_Zhc+_zCB+7196rsHb=KxG4JyuvyODXCpEX-y4XhwRjoBrw@mail.gmail.com>
	<20140809015857.17af92e7@canb.auug.org.au>
	<CAJe_ZhcRs45Rmzpjb-O+A=+HCUt9SspdgPofMkqd5+xL=TYwDA@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/22t.Rf+a.2yL7yUzo9cbmJc"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/22t.Rf+a.2yL7yUzo9cbmJc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jassi,

On Mon, 15 Sep 2014 20:40:50 -0700 Jassi Brar <jaswinder.singh@linaro.org> =
wrote:
>
> On 8 August 2014 08:58, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > On Fri, 8 Aug 2014 20:40:47 +0530 Jassi Brar <jaswinder.singh@linaro.or=
g> wrote:
> >>
> >> On 8 August 2014 20:11, Russell King - ARM Linux <linux@arm.linux.org.=
uk> wrote:
> >> >> Upon Mark's suggestion (and the right thing to do) I wanted the pat=
chset
> >> >> to live the cycle in linux-next.
> >> >
> >> > Yes, that's the right thing to do, but you sent the request at an
> >> > inappropriate time.  The correct time to send your request would be
> >> > after 3.17-rc1 has been released, IOW after the current merge window
> >> > is over.
> >> >
> >> > In general, kernel developers don't "remember" requests from one week
> >> > to the next; instead, we much prefer people send their requests at t=
he
> >> > appropriate times in the development cycle.
> >> >
> >> OK, thanks for explaining.
> >
> > As Russell has said, if you remind me after -rc1 is out, I will add
> > your tree then.  I will try to remember, but don't depend on it.
> >
> Hi Stephen, Could you please add now ?
>=20
> Tree:       git://git.linaro.org/landing-teams/working/fujitsu/integratio=
n.git
> Branch:   mailbox-for-next
> Contact:  Jassi Brar <jaswinder.singh@linaro.org>

Added from tomorrow.

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

--Sig_/22t.Rf+a.2yL7yUzo9cbmJc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUF/kUAAoJEMDTa8Ir7ZwVW74P/27DjnbTTi7644GRQcjM4OTn
SHGnQDtc/GWn5Pf9+yeTO0qdWSCcjMYvzJMRgt5dACvlHvF0K3n8bY2EbSsS0jy5
DWz4FoRzTZC/QDN9Aodmybbe2C1ATHQI/zt3zK84FKKv8INhWpmH2w1sWOBUujFb
rb+i9/1y2aUHeW8CPweclBkiWsEvPuNb2tpbq/ihV4qCjJyWxMUY+S8HQSUDl/yJ
b6tNN4ko3nTmHGiE/+gsLc09XOzUNREg2AqaGfmIUVbd88LnX/RfWE0yMMB50Ll4
FTZ5PAZscy4SPW5Wy5zVXos4MgzwqK41mBg2/4E4cxnfsumy0E7t46Wihq7xk1bR
Rp507O+X/YP4R/BZJSJuyRncczkdcuOPSOzEGZIJGxh1kyaFPdewzIe/V/10QaW5
Vqz11tAh7vbMKyDcd3EziSl3RmFBHlxqG1onSAgpMuszySnkkVJuw1yRij1Lce3p
LvfwRwem4pOZ4VrLJLqoZUx1/5xWoFurLNGMYfzC7AtHuq8jYX2J2LjpcTerD9xV
BrLrM0A4TEIOQ7oLwvggRl009tb+F4/NWEv5a63tyELigxcnZp1p0q7ZOzAyU/Nj
OZunOPlTccagwuWDC/shI/PTcnK8sA+ANw67uTWnhQnwCGWEgi9Q26RAi6Qn3Sfg
09E4VW2MiULW99UkFRZw
=+34o
-----END PGP SIGNATURE-----

--Sig_/22t.Rf+a.2yL7yUzo9cbmJc--
