Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab3HFSrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 14:47:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47765 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab3HFSrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 14:47:08 -0400
Date: Tue, 6 Aug 2013 19:47:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: linux-kernel@vger.kernel.org, t.figa@samsung.com, s.nawrocki@samsung.com,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20130806184704.GR6427@sirena.org.uk>
References: <1375806880-13068-1-git-send-email-m.krawczuk@partner.samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FWibJpkbnkY6rrXF"
Content-Disposition: inline
In-Reply-To: <1375806880-13068-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] Regmap: Add missing header
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FWibJpkbnkY6rrXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 06, 2013 at 06:34:40PM +0200, Mateusz Krawczuk wrote:
> regmap.h requires linux/err.h if CONFIG_REGMAP is not defined. Without it I get
> error.

Applied, thanks.

--FWibJpkbnkY6rrXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSAUSlAAoJELSic+t+oim9yPcP/3szQCiL8R0AV4nw5t1K6tks
xDDkx7q6ayeJoNlszjNydwUeIGbN0ntMrDK44uzrzJAaBVR2UtZKKFUMH6Jz6J5E
o6T7GcapyVlnjq3XbXyJr9p9k+HCs5+f3CgmgYzfZKB0KEJ9G0D9Y16dXQL6MsTf
lCd6zdGNKA6Sw1lfzRqdXGurLrHt6AAu5IXD2q8dng4JPq8yFyYTSgw/jn+eixIt
rxKzi8Ht+HzwLEisCHwFrlid4khkrOE3guqZ94Fb38cO8CJDUEhB7LdAaxhcB8Vd
5l5j9dJafVkzTNt84sO2nxmAH7P/MZIg+kCQNgEfB7oqStCbehweKHLa0w0jCpoV
x4e99DU4uLJMU5X5xHeNKm9x4aUDI45Gj86e8f9pN5EeLnR/tIZ/pI48YK8hZD5v
JnOin9f/VE+xcxAhqMX5VijatPV1Jc7p7043SRnA1YmcArC1+gNjbtClrJ31QuT1
brRqIDBwBUYF06Ui6wFJbI5S/qEJxDg7mKUqpWpfhBx80479XoudMPN0mHxpY43a
rAqZvd5QWoc8+IOEWBnbqIDOVlC88M1FWFaJ1AG1ZMZrNzwZa1CifSPpFKWiwR1a
C6eCYiQ4iGWLZz/UHfY2tgf64oLfM/UXYIORIk5KMySdg9Jq3mq3twudF0CQo5cI
xkbJhFRreCU4uHqmULCC
=g6jL
-----END PGP SIGNATURE-----

--FWibJpkbnkY6rrXF--
