Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbaACPwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 10:52:25 -0500
Received: from sauhun.de ([89.238.76.85]:34549 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaACPwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 10:52:23 -0500
Date: Fri, 3 Jan 2014 16:52:17 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Benson Leung <bleung@chromium.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>, khali@linux-fr.org,
        andriy.shevchenko@linux.intel.com, jacmet@sunsite.dk,
        linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Duncan Laurie <dlaurie@chromium.org>
Subject: Re: [PATCH 2/2] i2c-designware-pci: Index Haswell ULT bus names from
 0
Message-ID: <20140103155217.GG7132@katana>
References: <1382326010-4554-1-git-send-email-bleung@chromium.org>
 <1382326010-4554-3-git-send-email-bleung@chromium.org>
 <20131021065804.GX3521@intel.com>
 <CANLzEksGqD30Cefh3r2urH-ToxWzkxAnTJZiY07yX2Py58FQPw@mail.gmail.com>
 <20131114180538.GK11022@katana>
 <CANLzEksP1nRfBaQ3-sSouOYL4C+oLKiE75eHfFdEzLmrQKn3dQ@mail.gmail.com>
 <20131126130959.GI7427@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pE2VAHO2njSJCslu"
Content-Disposition: inline
In-Reply-To: <20131126130959.GI7427@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pE2VAHO2njSJCslu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 26, 2013 at 02:09:59PM +0100, Wolfram Sang wrote:
> On Tue, Nov 19, 2013 at 06:14:18PM -0800, Benson Leung wrote:
> > Hi Wolfram,
> >=20
> > On Thu, Nov 14, 2013 at 10:05 AM, Wolfram Sang <wsa@the-dreams.de> wrot=
e:
> > >> In the chromeos_laptop driver, I do by-name matching of i2c busses to
> > >> find busses and instantiate devices, so there is value to have each
> > >> named something predictable.
> > >
> > > Any why don't you use fixed bus numbers which you can attach the devi=
ces
> > > to?
> >=20
> > On this particular set of systems, there are two other classes of i2c
> > adapters that use dynamically assigned bus numbers, specifically the
> > i915 gmbus adapters, and the i801_smbus adapter. This is why
> > chromeos_laptop uses the name matching, as some of the boards that it
> > supports have devices on those dynamic busses.
>=20
> I am not sure I get the problem. If you use i2c_register_board_info() to
> register the known devices on the designware busses the dynamically
> assigned numbers are guaranteed to be enumarated higer than the static
> ones. Check drivers/i2c/i2c-boardinfo.c.

Ping. Was this helpful or do you still have the issue?


--pE2VAHO2njSJCslu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSxtyxAAoJEBQN5MwUoCm2DekQAKEo6mT/LWxbxbEUdqjcOZwy
yAdLK1BrZBF5SxQuqYuhZjGkjUDa+NbccvRp8sTSFq6kKUjlWXbYQImKihgF+Cdl
Bi5QTnXhWuNDC8RMkZfSE3zttHVw5G+tUGJswujTUUTYzozcdotz4TcD/qLrrEHm
9G+Kzwsb555LcJMOzxOXFn4uQnHLsFraSOmz4Yi98SirqyNOmUZdlCR8wNLN42oJ
+gxZZelwPA4O690w+ugEqLUJM21bRLs/C21tZYIIKbgDvWCrjRVfhZMLI0S5XRKo
5iT4hjAAO/fEPuRLzR/o6fv0Vy7xN9Fx+NQ9sJ7T8G/h2cD5IkShca3W+i9ut/XH
OnE7eKnR2s47GNRsul/P3bIC7K0e7OFdsejYdLMAm3wx1U4qXeidcHl5rDOc4vo9
WkLNnBen1PwfWJoD7oGtMGR4hJ60vue4xCxA/6DSIMruImFyVxCq86VTQgmJSKrK
ONsNM6cgOPXhgsKqX5xguPRV94Ab1joUr0jwWp9RJN2egu89fTtHzACejX+PL++b
sJqhjL17Vi7RM3Py6moGviqoAC2KESy/MuU8CkYmNeTM7Oguu3uu4l70SsKeB0sT
VTmARNzu31SlvUPzL5OWZtPFdqm4kppU3D9Xi51jMXhZTaAJ5frI31OaGrcGpNHd
d6msxRs4GArI9UZ8y/Uq
=ItV6
-----END PGP SIGNATURE-----

--pE2VAHO2njSJCslu--
