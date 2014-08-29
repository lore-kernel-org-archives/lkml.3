Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbaH2TBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 15:01:42 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40060 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbaH2TBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 15:01:40 -0400
Date: Fri, 29 Aug 2014 20:01:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Gokulkrishnan Nagarajan <Gokulkrishnan.Nagarajan@in.bosch.com>
Message-ID: <20140829190129.GZ29327@sirena.org.uk>
References: <1409336356-27682-1-git-send-email-dmitry_eremin@mentor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lKbk9CFItQTD29wm"
Content-Disposition: inline
In-Reply-To: <1409336356-27682-1-git-send-email-dmitry_eremin@mentor.com>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: GPIO #0 is a valid GPIO
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lKbk9CFItQTD29wm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 29, 2014 at 10:19:16PM +0400, Dmitry Eremin-Solenikov wrote:
> From: Dirk Behme <dirk.behme@de.bosch.com>
>=20
> With GPIO #0, this if statement will always fail. Remove this, the
> check for gpio_is_valid() is sufficent here.

No, read the archives - this will break boards using zero as default.
Any current boards should be using DT and so shouldn't be using fixed
GPIO numbers in the first place which will mean they'll not end up
getting zero as a valid GPIO.  If you are using zero as a GPIO for some
reason provide a way to specify that the GPIO is a real GPIO and not
just the default value for the struct.

> Change-Id: Ia10e8e9c74e11deba852fcd44040cc275b583cfd
> Signed-off-by: Gokulkrishnan Nagarajan <Gokulkrishnan.Nagarajan@in.bosch.=
com>
> Signed-off-by: Dirk Behme <dirk.behme@de.bosch.com>

In any case I can't apply this since you didn't sign it off and please
don't include noise from your internal review system in upstream
postings.

--lKbk9CFItQTD29wm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUAM4GAAoJELSic+t+oim9fIgP/jgVBAmL+Ot5lkfQ7WLqFaP3
JmSXqyYeIDG5SiycDVASLFh56dWrfqoDU9mgga5RUH7/9IPUxDm9uAYWGMGA9T8c
Hrbm76dO3e6JKT/lSguqQPE9rPNBqbMMFGbmuxlAZ7vcwrSDPGvoJYoWmlmqN0Vf
kDAbDKaFz9Ss7WUr/+/vpb18PkpiCol3+OsKr+5si/icTjiiJZgTWEAdXNxEG7Xa
GHt4LLB16rxUbJm5DfzGFBsjXtw7apORI9CTWc9nehwOY4Ql6dlrapVK/Lf2O8c5
OcZ19NpQcBUmFa8E4SyxsmlHvt9/dQsk0DUHJWxcywq3SMnAQuqKlvdIuMSeyzGi
8g10PWt7pQFsNlE5jC+LsbtG8DU4ATYqAGuQYNpKTd4CKU8Yehgqr5fTNsvB6MT9
3Kqd8CoWE5O7YNzGURUigYbZkoqqzlbMBaBSDkWJ4U5mcgnqOEd29Aov5QZwQD36
hXLhiqVkXU19KHOFV8+DN7K30IGHnJO6S5QCFpco0l/lQB/X9AskAUcgy2igsOl7
+TQmNYwMQ+1KFfSmA1yBo+VvwApWaWAjwqBgw2fPJHK3DPq7G3oojTnHxGTJxl3e
fGKVvY/a5zY+xMvJydmJMoi8F3cwubSumXPwTzNrSXga+6wc50ckVH+80XOPUKMR
TAMzkf2b0uZ+I3J05Ete
=51Qb
-----END PGP SIGNATURE-----

--lKbk9CFItQTD29wm--
