Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab3AMEOJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 23:14:09 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57893 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754583Ab3AMEOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 23:14:07 -0500
Message-ID: <1358050431.4514.57.camel@deadeye.wl.decadent.org.uk>
Subject: Re: INFO: rcu_bh detected stall on CPU 3 (t=0 jiffies)
From: Ben Hutchings <ben@decadent.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Date: Sun, 13 Jan 2013 04:13:51 +0000
In-Reply-To: <1357174163.10284.8.camel@gandalf.local.home>
References: <20130102190920.GD29452@charite.de>
	 <20130102205630.GA5594@home.goodmis.org>
	 <20130102212948.GA25701@linux.vnet.ibm.com>
	 <1357174163.10284.8.camel@gandalf.local.home>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-2uGM+KPxiV04/f+BddX/"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2uGM+KPxiV04/f+BddX/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-01-02 at 19:49 -0500, Steven Rostedt wrote:
> On Wed, 2013-01-02 at 13:29 -0800, Paul E. McKenney wrote:
> > On Wed, Jan 02, 2013 at 03:56:30PM -0500, Steven Rostedt wrote:
> > > On Wed, Jan 02, 2013 at 08:09:20PM +0100, Ralf Hildebrandt wrote:
> > > > This happened of a virtual guest (Linux mail 3.2.0-35-virtual #55-U=
buntu SMP Wed Dec 5 18:02:05 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux)
> > >=20
> > > 3.2 is rather old and this looks to be a stock Ubuntu kernel. May wan=
t
> > > to file a Bugzilla (or whatever they call it) with them.
> > >=20
> > > >=20
> > > > Jan  2 13:24:08 mail kernel: [3531872.484283] INFO: rcu_bh detected=
 stall on CPU 3 (t=3D0 jiffies)
> > >=20
> > > 0 jiffies?
> >=20
> > One possibility is that they are missing commit a10d206e (rcu: Fix
> > day-one dyntick-idle stall-warning bug), at least assuming that
> > CONFIG_PREEMPT=3Dn.  This went into 3.6, IIRC.
>=20
> If that does fix the issue, we probably should send that off to Ben for
> inclusion into 3.2 stable.

If I read the Ubuntu changelog correctly, Ralf's machine is running a
version based on 3.2.34, which already has this change (I applied it in
3.2.32).

Ben.

--=20
Ben Hutchings
Klipstein's 4th Law of Prototyping and Production:
                                    A fail-safe circuit will destroy others=
.

--=-2uGM+KPxiV04/f+BddX/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUPI0f+e/yOyVhhEJAQq8QxAAtlj2De1+fN2ZPSBFpya8ng7TSAwPigNO
b0XfYYJgJoCPdS4NxmwRRTUtF1ZQpHhYWK9aAh/lPEYHhCsqq7tdZG5+ZevKmLLi
wvPeH69ec26+biVJQbIcfNzap2MumRbA74jkKWpWicwphcVRxEDf0Xi7wtmnlkex
rIDY6Jtw/3bHS5Dh2b67QIsRN+SDLnwFuUmqMP6UuY5m1X5LfnnVZ4k47hWha8AU
CbA52vXmIdXFSiGdMrGEGpuICaiE4fhdIITvp+o1IjDhd59moUwIsVE0zBtb4nTr
PO3kFxlvS+M3by/tzt2vyxrtQHUNecLergruDErsIdwIF8Z74ImOEyIkQ75Us6Pz
xmD6l9igQIZKawYwVmOzDh5k9i5udk4moY7K9cRDvl03tzpWfcZZKtVPE9G+uCnf
aY75ywAFsBJDPnt5Nmt1YxEE6MkoLDswrOtYAt4YwPBQdF58O7Q2MDLjxUnqzlmD
29/Av/Z5WhXQplSbIRYHh9v93VtBpoFGJL6Y47gKKsFugz0sRIG0q8YgyPnMWOQn
Y0xQGZFVxbK3+u22h5uRdmWNsKbMRqB+Q6V/LrnRFITaWLz1Gf8rdEMCrbaRjo3t
h9XXm9rVhboYK5qbI0MNkFVzlly9+J0xR9h0A94atjzHekdCyPK755/0VJaaMUDr
mSmTMoA3Vv4=
=BdDG
-----END PGP SIGNATURE-----

--=-2uGM+KPxiV04/f+BddX/--
