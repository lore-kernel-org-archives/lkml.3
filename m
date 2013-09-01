Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab3IAMom (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 08:44:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60671 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab3IAMok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 08:44:40 -0400
Date: Sun, 1 Sep 2013 13:44:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Krystian Garbaciak <krystian.garbaciak@diasemi.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130901124433.GD3084@sirena.org.uk>
References: <1378009191.25863.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UnaWdueM1EBWVRzC"
Content-Disposition: inline
In-Reply-To: <1378009191.25863.1.camel@phoenix>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: da9063: Statize da9063_ldo_lim_event
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UnaWdueM1EBWVRzC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 01, 2013 at 12:19:51PM +0800, Axel Lin wrote:
> da9063_ldo_lim_event() is only referenced in this driver, make it static.

Applied, thanks.

--UnaWdueM1EBWVRzC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSIzauAAoJELSic+t+oim91p0P/0QBijgzKVQ6qm0EUdBiyBaZ
33cOVEq0mf69GqkybhP5NhExotsxwpqn4lxg7MNXRZwuPvinwBdrS6o+1oEEaiio
75ekSAxv9mkEf7v3FiufVgjv7A40oQc+V9ToSInddJ1FTxt35Su89SsOIg9zu8xP
pTeOYNHKYeVqClzVfF7i4EWZayahm/uyhqxHMSJeU5hJhMoJRsCH6x+hA+MBXX4Q
HQKHRWcHSSUJP10/Q9wFmjIJoxi+UJ/rVYYFsdmYgkkc34SqMxQHLF04BrkSEXb6
Vgoq5Phkv1w2liLcy/aTvUlsMXigpRsCI7gZaZoL2GxcQUhqzhl3pDt8L0DlG/RC
jQgqdnysI7CVkVAxZUD+7Bn5GNuuNUBFmV4TBiTrrHllcHYn37uClh4IEZsoy0JD
YZpJvPUfzFkAJfxJU5Acjk6AMipjkPKkZ66TqdYPwG2LWdjAVKLauMMIK1twJ8Z7
STqRU6jt74t63UU/gPXqK3eNZFWde7utKZ6ffznb+9x674zAFfgQmGyPRl894xp7
5DjAc2NZGiHl7DblsYL3K8W7aCAAUOUoXy+uRBlfPVaPUT2uqady5+S7BL4hjcOd
XADuVaEHWz8bsOS1ybf11sVCed0iZGj8LWpgr+L4h0d45GXMTAYyYKzbSEAEuRxb
qoAjNrEBbLl37VvTVWtd
=v4Or
-----END PGP SIGNATURE-----

--UnaWdueM1EBWVRzC--
