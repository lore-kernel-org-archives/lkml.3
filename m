Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab3BFEVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 23:21:12 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58667 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754856Ab3BFEVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 23:21:08 -0500
Message-ID: <1360124462.32217.21.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 014/128] mwifiex: wakeup and stop multiple tx queues in
 net_device
From: Ben Hutchings <ben@decadent.org.uk>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Avinash Patil <patila@marvell.com>, Kiran Divekar <dkiran@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 06 Feb 2013 04:21:02 +0000
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D1432F6DE@SC-VEXCH1.marvell.com>
References: <20130203144644.035172954@decadent.org.uk>
	 <20130203144645.292616915@decadent.org.uk>
	 <477F20668A386D41ADCC57781B1F70430D1432F5B8@SC-VEXCH1.marvell.com>
	 <1360021291.4538.19.camel@deadeye.wl.decadent.org.uk>
	 <477F20668A386D41ADCC57781B1F70430D1432F6DE@SC-VEXCH1.marvell.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-YUjnYGShTTgQAvjDw+h9"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YUjnYGShTTgQAvjDw+h9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-02-04 at 16:36 -0800, Bing Zhao wrote:
> Hi Ben,
>=20
> > On Mon, 2013-02-04 at 11:43 -0800, Bing Zhao wrote:
> > > Hi Ben,
> > >
> > > > 3.2-stable review patch.  If anyone has any objections, please let =
me know.
> > > >
> > > > ------------------
> > > >
> > > > From: Avinash Patil <patila@marvell.com>
> > > >
> > > > commit bbea3bc432dc5c08d09ca5c80afdd82515470688 upstream.
> > >
> > > This patch is not for stable kernel.
> > [...]
> >=20
> > Right, I've managed to pick up 3 changes to mwifiex that it looks like =
I
> > shouldn't have included.  Firstly:
> >=20
> > 9c969d8ccb1e mwifiex: check wait_event_interruptible return value
> >=20
> > This had "3.6+" to the left of <stable@vger.kernel.org>, whereas I
> > expect version qualifiers to be on the right.  So my import script just
> > put this in the queue without asking me to interpret the version
> > qualifier.  (I don't automate *that* because people use too wide a
> > variety of syntaxes.)
>=20
> Sorry. From now on I will put version qualifiers on the right side of <st=
able@vger...>
>=20
> >=20
> > When trying to apply that, I found that it seemed to depend on these
> > two:
> >=20
> > bbea3bc432dc mwifiex: wakeup and stop multiple tx queues in net_device
>=20
> I'd rather classify this patch as an enhancement because the code change =
is relatively large.
> To play it safe, let's drop this patch from -stable.
>=20
> > b7097eb75fa1 mwifiex: handle association failure case correctly
>=20
> This is a bug fix indeed.
>=20
> >=20
> > which also looked like they were important fixes.  Presumably I should
> > drop all of those?
>=20
> Please drop bbea3bc432dc only.
>=20
> I can resend a backport of "b7097eb75fa1 mwifiex: handle association fail=
ure case correctly" for 3.2-stable.

Thanks, I've made these two changes.

Ben.

--=20
Ben Hutchings
Everything should be made as simple as possible, but not simpler.
                                                           - Albert Einstei=
n

--=-YUjnYGShTTgQAvjDw+h9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAURHaLue/yOyVhhEJAQrXjg/7By7wq8ra/VDfEh4DcUobmsTktn5wu5rC
7/tk+/2o42Atgeb8VSQRbeeGYI04Geo7MlSDvkgyIWE6wuTrt6R2pg3Cv1I8PAdz
3UHpIJUqhHrp6EG1EgMRB7Yo+UdedNoUOdLwSN82RDtEB/6GWGJVXqwL8mBI0/f/
hPoFitTjYpc/tOprEzdyaUEYb9KXzl/B/pIOKGBwTRL6il3HMoHoeUS5t22ffEXK
A8U9dUpGhTcLe8DOiy5NRx8atFQaIQk7Uc7vvlxvkK6nakGUIshOIGPhA/KKEvGQ
V5J1YIdJ/6Alv8xK2tUa/4v7qnSXaA0APvjETBC5o+xYU1+ovU8dWnHxQbWsyTmi
evOwZ4KSkRoEK2I/yhJlTeUr/UuEGFpYxdvCIkWsX1t5sSCOP9wl8PBAoGKnClwm
8MTvbeoV1xIlNZNSQAj7iWk5694LeL9sLmfE7i9sTZTcHJqTRewo8QxJQtcGo5jZ
ykx10Fp4wSXAm0rYYl3HFkL8ASl3y2TD9vbO749zNWZjI/OWy0A4DxctDlHKJcRO
Uu0KyUcuYSNynazydYhiLQQUD8fQursfu2qzJy5pkir3uPynS+v4pXnWrrTGpWWq
msZMFeIRgnne/i2jsWiv6QoUnHyf/yfs5JhI60TdWeuRjv6rvuJCc39WBqnJx7x/
NIh/3fMm3vE=
=IjWH
-----END PGP SIGNATURE-----

--=-YUjnYGShTTgQAvjDw+h9--
