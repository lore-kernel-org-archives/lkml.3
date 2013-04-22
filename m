Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab3DVBWz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 21:22:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46996 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754114Ab3DVBWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 21:22:53 -0400
Message-ID: <1366593764.3408.133.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 10/11] mtdchar: fix offset overflow detection
From: Ben Hutchings <ben@decadent.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Brad Spengler <spender@grsecurity.net>, linux-mtd@lists.infradead.org
Date: Mon, 22 Apr 2013 02:22:44 +0100
In-Reply-To: <1366059320.3072.65.camel@shinybook.infradead.org>
References: <20130415020614.067692418@linuxfoundation.org>
	 <20130415020614.846683113@linuxfoundation.org>
	 <1366059320.3072.65.camel@shinybook.infradead.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-uycp4Q+gsp3Xv78hwP0k"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uycp4Q+gsp3Xv78hwP0k
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-04-15 at 21:55 +0100, David Woodhouse wrote:
> On Sun, 2013-04-14 at 19:17 -0700, Greg Kroah-Hartman wrote:
> > 3.0-stable review patch.  If anyone has any objections, please let me k=
now.
>=20
> Please use f5cf8f07423b2677cebebcebc863af77223a4972 instead (for 3.4
> too).

I've queued that up for 3.2, thanks.

Ben.

--=20
Ben Hutchings
Klipstein's 4th Law of Prototyping and Production:
                                    A fail-safe circuit will destroy others=
.

--=-uycp4Q+gsp3Xv78hwP0k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUXSQ5Oe/yOyVhhEJAQqxNA//YjPQNQY2nWD1GpQz1lyAaymlyXDQbV2m
2v4Zm6V3eJ7F/jRyKMwKbVq8DcvFjnUoO7IZEOWBEh5OODVuNY0MW44Ia3/FC0Si
hzKsgHB2r3S0cVtkRDuElITZdzxrWtn9Px7HDCh7qhUzqI60J3mdGj+CyYZMRQb3
IiB4aw25YlmdW252Ws9GaL4Yd+IMgrl73jbHmHweHvohOiNNeRFSIIyOvjh4xi0+
X+G9sUnYvAJnX2Ck8fA1xvC/q/4ErTdKBMB54TotuzT0hPg3Z7a/lYihLNmew32o
9yjYbON9UW8KvJdi0fv3TgG38LWbXx7ehz+NXKQLtuyTR1uyjcwxHTPehvBJ0Qq/
vx4HLJ47Qpq6WHxtS+5NUKlJtntPrMinOAed8TKH5R8cNfRhuQJ11i/+6Ki/km1r
7ejc0Pa4I8mp7Uzd/hkvYZG2/F5uLn/bHqNxA4w1/QDXutsGr8e/icFeucaGwWTr
fAZ4S2tM0t5oJfwAA+qp8rYQfK4o8gvIsAJwZLvd8NkrSf/zj5Ah2OYWhga9f/f8
fThX47gmebofXBdznNXQQQ/mQls8g8zI44dF0mhxQwikMiJD4k1fRkhi4JGUF6/W
PTvDZ5fDULFCLsQ8ExlanWdpO2AfWnE5xHx/q+jQ255z2F21gvhqQ1wpsEUebScp
RsNcKIKkPa8=
=Dv71
-----END PGP SIGNATURE-----

--=-uycp4Q+gsp3Xv78hwP0k--
