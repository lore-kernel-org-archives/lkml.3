Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaCJXNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 19:13:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55220 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752349AbaCJXNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 19:13:45 -0400
Message-ID: <1394493216.23624.17.camel@deadeye.wl.decadent.org.uk>
Subject: Re: perf: Add support for full Intel event lists
From: Ben Hutchings <ben@decadent.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, eranian@google.com, namhyung@kernel.org,
        jolsa@redhat.com
Date: Mon, 10 Mar 2014 23:13:36 +0000
In-Reply-To: <20140310221420.GM22728@two.firstfloor.org>
References: <1394048978-15909-1-git-send-email-andi@firstfloor.org>
	 <1394480354.23624.7.camel@deadeye.wl.decadent.org.uk>
	 <20140310221420.GM22728@two.firstfloor.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-SM/LqVvTBkkm3t3AMoVy"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.245
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SM/LqVvTBkkm3t3AMoVy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-03-10 at 23:14 +0100, Andi Kleen wrote:
> On Mon, Mar 10, 2014 at 07:39:14PM +0000, Ben Hutchings wrote:
> > On Wed, 2014-03-05 at 11:49 -0800, Andi Kleen wrote:
> > [...]
> > > I implemented an automatic downloader to get the event file for the
> > > current CPU.  The events are stored in ~/.events.
> > [...]
> >=20
> > This directory should be placed under $XDG_CACHE_DIR (default:
> > ~/.cache), and should have a more specific name like 'perf-events'.
>=20
> Ok.
>=20
> I don't like calling it perf-events because it will be used
> by other non perf tools too. I guess pmu-events could do.
>=20
> >=20
> > It might be useful to also support a system directory for these,
> > under /var/cache.
>=20
> I don't want people shipping those.  It just causes lots=20
> of outdated events everywhere, like in oprofile.

Sure, no-one should be shipping files under /var/cache.  It would be a
an alternate download location.

Ben.

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-SM/LqVvTBkkm3t3AMoVy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUx5HIOe/yOyVhhEJAQoKphAAwBhWB7JEj6Z92QtjJLk1xH+VuTzcyZah
vRtIGOnFwmLpuqYYm8g48prlh7SIKONDZ+Bn+DuvzgGknSrVrJQHe+eP0h4BoMal
+diNMaGpX1zVDzzXWnd3dkbRB2zhEsM+gK6pgjbBQyOpix9mqngnLTfOrMau8mzK
wkwn5AxmIIsvn7BbgtMC4TtvK3gPlPRwuQpZud9ubFybORZrBm/BtWYPLY/qC86y
JooM96Qnl6kd7WcowZWce2LkYQd25qmDpSTDns8bd9MeUGnKXSZJ7e+Y/uoltulX
v4W9R7TCQA1KQMz5Jv5ufIzVV8Vf3kAXL9AxKmClVY4pFBD4qG++BajXS3fA+CTh
9UfTpT2svMKv7fz3IXNGFiCEJxAKNVWX4OtenEsm32wVAy2PzXqxChngzf/2G/wy
4PhL1FKJtKZVlufgyAXfb/yUJbRsrzIk1d5PCU43F7vjSrH/OL2ojuQm3nNU4oUS
8RYUU3byA65bM7+exUcMfibTlmUPf3udeUJwOXY6XZM5F8VMRg8LDiL5OBWm/YsJ
wk8nn9/HGSJ63Cc/6ji6eeVYik6GTdQv4cGQhpIdWxY37BEjde4dBMhBhNymT2cc
tMvuqjtCsi542jqOVGpiSrbPWFZOQXXN56zHyOeBod0hJZrNjm9bzPI/uki1gfnM
83MTjunCleA=
=Ep0l
-----END PGP SIGNATURE-----

--=-SM/LqVvTBkkm3t3AMoVy--
