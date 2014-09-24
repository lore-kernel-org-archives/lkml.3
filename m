Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaIXVBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:01:53 -0400
Received: from sauhun.de ([89.238.76.85]:43107 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118AbaIXVBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:01:50 -0400
Date: Wed, 24 Sep 2014 23:02:16 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Peter Huewe <peterhuewe@gmx.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [REGRESSION] i2c-acpi: Fix NULL Pointer dereference
Message-ID: <20140924210216.GA1291@katana>
References: <1410548987-3558-1-git-send-email-peterhuewe@gmx.de>
 <1696265.yGhHYgE97A@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <1696265.yGhHYgE97A@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2014 at 11:06:24PM +0200, Rafael J. Wysocki wrote:
> Hi Wolfram,
>=20
> Do you want me to take care of this or are you going to handle it?
>=20
> It has been ACKed by Mika already: https://patchwork.kernel.org/patch/489=
7751/

I am going to handle it. i2c-acpi is being reworked, currently. Just
waiting for some testbot results.


--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUIzFYAAoJEBQN5MwUoCm2uQcP/0S4ArVct/aLOWNDMIq8FZDQ
zoA0cSmVg2n40a10dcEJ8ZOFzeFaa/rET7GsdngEQD0evceD5CUfUOQIi3qccENr
1zF0XbA4ApoCM4DSvAkyxxOzey0Wu/cEIKLPM/GQhE7wI6AbVAlFiC7UEDX1vOJ+
PUJUy3QUyAJgbbzCm9qQcWyMwjIHRedAy0tLFEjQNv/xi/uik3E8CDYRzoXXSdyw
xC9NYqrEt8JEBFlqEOjVgTkq5o1RV7BBMlxtnmmCJ/PU4DXf14PnQnGhWkVlS+HQ
h+bkO494Lg51auCDqOWld6XqgU6ryysvlYbzs1Tvig8HTIJdyaBnS5yfUu2+raJp
LkvKjpZYksv2MSaXRytYfflmBU6od9h3ZvHwbj9w7SpycSdho6A9pqmsJn5+9/3V
uCD7mJsmEGVzMTNkV6oyERj+VApe0MeZrBAhiRgdGWwgIISBjyIkbrA7awm1Doga
dokVbdvoVu+R+4atUPh7qjlRPiFRPWJ2iykM2FFGRxefGrYMQ/NkeeaKA9CFki5F
MQD3is+LCimYgXr1SyO1UDJJ35TVkfnZ0iKTASR5zg8aULPbTeJMuB9hd7XUjJG7
SRjYvFC9+xi/JFyn/IoyR2rHSSQZao5I7iJcFoG/tsLNLzUFN0O8XHt7foywkAAy
AlavGNRxGZ7z5a6+SU5i
=BwFv
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
