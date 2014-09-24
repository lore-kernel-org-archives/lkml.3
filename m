Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbaIXPnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:43:50 -0400
Received: from sauhun.de ([89.238.76.85]:41066 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413AbaIXPnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:43:47 -0400
Date: Wed, 24 Sep 2014 17:44:15 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lan Tianyu <tianyu.lan@intel.com>,
        Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH] i2c: move acpi code back into the core
Message-ID: <20140924154415.GA1283@katana>
References: <1411420006-4713-1-git-send-email-wsa@the-dreams.de>
 <20140923091438.GI1786@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <20140923091438.GI1786@lahna.fi.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 809ecd680d88..e3682d0dea1e 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -4477,7 +4477,6 @@ M:	Mika Westerberg <mika.westerberg@linux.intel.c=
om>
> >  L:	linux-i2c@vger.kernel.org
> >  L:	linux-acpi@vger.kernel.org
> >  S:	Maintained
> > -F:	drivers/i2c/i2c-acpi.c
>=20
> You can remove my name from MAINTANERS as well. I'm not I2C subsystem
> maintainer :) Of course I will still assist reviewing ACPI related
> changes in i2c-core.c.

I'd like to keep this since the header says I2C/ACPI. I am thinking of
adding something like 'K: i2c_.*acpi_' but that can wait. For now, we
need a working solution _very_ soon.

> > +#endif
>=20
> I would put there
>=20
> #endif /* CONFIG_ACPI_I2C_OPREGION */

I didn't want to change lines not written by me, but well yeah...

> Also please remove all ACPI related stuff in include/linux/i2c.h. That
> is not needed anymore.

Yup, thanks!


--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUIubOAAoJEBQN5MwUoCm2pRcP/jIWBNJWo/kOJ9oViOgNzGpX
Xgt6P9x1EH1Z52vbhLnwrR6NJ+1/D32bd8EEOPjw29RffKvMAQ8EFDvEs4F1QSs7
4eyjoxnPIkALs6X7Apo4UeHIyXUcge4C5VeF3ZsV3q6dAE7hDXXCA4WwwKODwnAo
AXN3DcXL27Wg9VjF0IW6feM25RRAX1qf0AgvW+blJ2/cZmuXzJtSVfguFwTYwVqD
Oy/nB1P3C802ol848tZA7F9zjmuHnHrELq1JakXa+er1yl1eGeFDfSPwOG7N208g
C4pvVA2ZOvZPrSy/74YTXD3lcyLU7fQwlRDR7UL/Tpq5S6Se8pwZMU8noiuuDQn+
DIpMPUcBJiR7wfcqrg7U3grmIiNesdEpvOtXrnD7D0DwUiwYE3SVDhNJRZidmmuE
Em4zyrWUK2CWwEbL6HZmVADAnH3eznNfn+vTZWvThuoFhUN0qbuzcQM0E3q3YgFI
7GUWu4qqnsIidLOLoUHPLPzUBKHluhtmh5JDasnrXgEonrdG6HJVjKB7qbUtQWDM
yURa4sKHgbKgM4az2cOcQia1CrR2Co/2yr5T9sdSxFWj+fh/OT9/XmBK6cpEpS/2
IYEdO6Dd8ieu1JLvHM4EjQEa29ieqJInsINS0M1nH7WLiLg1TAwHFS6GYVa/K4Pj
Qhk1SrdjbZ19MXRGqrt3
=J+BF
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
