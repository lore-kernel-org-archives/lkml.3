Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab3AOAes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 19:34:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47550 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756309Ab3AOAer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 19:34:47 -0500
Message-ID: <1358210073.15692.60.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Bug#695182: [RFC] Reproducible OOM with just a few sleeps
From: Ben Hutchings <ben@decadent.org.uk>
To: paul.szabo@sydney.edu.au, 695182@bugs.debian.org
Cc: dave@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Tue, 15 Jan 2013 00:34:33 +0000
In-Reply-To: <201301142036.r0EKaYGN005907@como.maths.usyd.edu.au>
References: <201301142036.r0EKaYGN005907@como.maths.usyd.edu.au>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-eTIYiJF0k2H4mifvGy7X"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eTIYiJF0k2H4mifvGy7X
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-01-15 at 07:36 +1100, paul.szabo@sydney.edu.au wrote:
> Dear Dave,
>=20
> >> Seems that any i386 PAE machine will go OOM just by running a few
> >> processes. To reproduce:
> >>   sh -c 'n=3D0; while [ $n -lt 19999 ]; do sleep 600 & ((n=3Dn+1)); do=
ne'
> >> ...
> > I think what you're seeing here is that, as the amount of total memory
> > increases, the amount of lowmem available _decreases_ due to inflation
> > of mem_map[] (and a few other more minor things).  The number of sleeps
> > you can do is bound by the number of processes, as you noticed from
> > ulimit.  Creating processes that don't use much memory eats a relativel=
y
> > large amount of low memory.
> > This is a sad (and counterintuitive) fact: more RAM actually *CREATES*
> > RAM bottlenecks on 32-bit systems.
>=20
> I understand that more RAM leaves less lowmem. What is unacceptable is
> that PAE crashes or freezes with OOM: it should gracefully handle the
> issue.
[...]

Sorry, let me know where to send your refund.

Ben.

--=20
Ben Hutchings
Quantity is no substitute for quality, but it's the only one we've got.

--=-eTIYiJF0k2H4mifvGy7X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUPSkGee/yOyVhhEJAQrbyxAAucDS0JK+jxM1edWyh6x21ngvDqaQ55Wi
OfLa+fKTHz2yhZ1A6JoIJuL0xwalbLiAAeIaFVTsUAM410DUhTe2GWwxa/ZC+y1Q
tyv4ZIb9BfIbDdsnfK0UlN7QjQVreNDFJEo1asfG1jjxnyupoCp9wr2ikJOc1uuW
1jpDjtc9Dknkxo9cEtHJdf3fMVmZLEUp2sScbtRXX08PA9//EwADz3xvz0gaZcvj
QH82Fluh1lJuhjWhDlQoKlFztcGc7QAfCBA14BQIEFw/T2sK6dGVeiBCTo+3vbcm
+qavK5lK8MlZ2ibFQ1HarzCkRzQmUiseXhOl4owdlhMNTZLmAixLJHiHpe7ybk6u
cjWjklxenWmWTHxBF9tmPr8SJO8Q7e1RL08SCjUtME5wJ2KUHzpvqib49ysyEdwH
TqQTEm1VMvFCbq/wYwRKw/jIsM+zg1r+e392QT/zMVAIui8y7whoeL9heyHoC6jF
uiOSMnA23+OpawSZDM7knPW0j1K+MTz9p8IlsUa+Z8U6wirw7npLNz/Z4Py++8Dn
uJ8WJcQ8n+HXbhWgaFy8cnir4zET35OdgwKq0p6BNqT1PqCDeVFKiDE3khhmUJAY
U2LBYk0uzr6NAp1nfjzhPYLhp2TclkCM7wDH/CmZK6sM0r24HTfY3rOfL0S4YKRw
PZLopwX7Rak=
=28wN
-----END PGP SIGNATURE-----

--=-eTIYiJF0k2H4mifvGy7X--
