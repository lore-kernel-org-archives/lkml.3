Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058AbaJVVc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 17:32:29 -0400
Received: from mail.kernel.org ([198.145.19.201]:45356 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932359AbaJVVc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 17:32:27 -0400
Date: Wed, 22 Oct 2014 23:32:22 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v2 22/47] power/reset: restart-poweroff: Register with
 kernel poweroff handler
Message-ID: <20141022213222.GA28840@earth.universe>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
 <1413864783-3271-23-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <1413864783-3271-23-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 20, 2014 at 09:12:38PM -0700, Guenter Roeck wrote:
> Register with kernel poweroff handler instead of setting pm_power_off
> directly.  Register as poweroff handler of last resort since the driver
> does not really power off the system but executes a restart.
>=20
> Drop remove function since it is no longer needed.
>=20
> Cc: Sebastian Reichel <sre@kernel.org>
> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Acked-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Acked-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUSCJlAAoJENju1/PIO/qaEvsQAKcr+Zemm30Kkui7TIBEnAju
NDhwn5yjnA04+iDUpDvpXZVimvGO2+wloc1ErT42hy5BI+4fqaHb9RhDc9xbpvzr
IaY8vnHwLdsldA4X/umu6ZRz9WE4y4CyVYpqT4E1tBWlaz6LpWNxFDWr1XW2PIO/
HvHm4CiV/9wfGse6wKCV/OWLhmf++S46RgAinIkwBX7exGkxS+5IAdd32CCBji11
bKnl9CMIU92GE/Qh2fml1xevw7ynoMeSDapjGSeMiQo1HOkVt3KUz+/4m7JUkh8y
l6d9+P1VCZTorTS74LdM7Je3UN38btzyBLCcGET/sJGjmzfXzam0TP5y2/FF0gub
Q3sTToB93M9Q9NNlVyh2pwTM8aI/pE4Ou7LpxmN13OtGXT9dQFT5YAgbY0Cn9kwo
UVgwobZXl8lalZvReqY+oueUJNsBJyZ713expxqkYs1zuhdNDSFhfweHSFkCZ5Se
tX7I2h4Oi60zDOIWjzngziHVNCa0dbwwKmQ+gMZYjsYwyowFlPAxtqnwq6L56AVJ
P12chwH8ajk1I7cQ5YC9mYo+8oof3PgJeOO6JC1CbbhRo4DCvHvDwcqefZXik2al
abhws3+RTfbw2tiM7GY4uljrMx43HHHmT5M1r9Vzt+lQF4MfMVoEqp8qTeBoDXZ5
/EYQGWd7zJRN40JmDaK4
=+9/2
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
