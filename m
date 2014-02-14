Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbaBOKHx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:07:53 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60316 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaBOKHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:07:50 -0500
Date: Fri, 14 Feb 2014 21:18:09 +0000
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140214211809.GI4451@sirena.org.uk>
References: <1392378602-32302-1-git-send-email-sachin.kamat@linaro.org>
 <1392378602-32302-11-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OtZJUqNUNrB9XA/T"
Content-Disposition: inline
In-Reply-To: <1392378602-32302-11-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.45.49.105
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 11/16] regulator: da9055: Use of_get_child_by_name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OtZJUqNUNrB9XA/T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2014 at 05:19:57PM +0530, Sachin Kamat wrote:
> of_find_node_by_name walks the allnodes list, and can thus walk
> outside of the parent node. Use of_get_child_by_name instead.

Applied, thanks.

--OtZJUqNUNrB9XA/T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/ogOAAoJELSic+t+oim9eWEQAJbONGoab1R5TP+RneBdq3UZ
ltMA9/TBmYkbhOBMCLRWUg3ZdrH9b/ceMwzjnDlslLlJlzmjeHoAAIM0/fGPNOEy
bY0OUX/71GnwZArae14LgG+avd2DNvKAUhLz8mxD+O9oSaW3aeJIKo/N00TlOqkl
p76ktalOh9kGFajPLCGis+JzKLg13R7YdvLPxvftzwBNloBzDurLWxuOMp+frpk0
TTf59mZV54mlDt1dkSHEsQmL9NgycMvaQ7A9YB2MsF+PJSHDQeUTw4dQI0yTAzrs
1c+VB9/kibSUJQkZeZUGFfPjGtD9Q+ILoQY9J8k+Y4ilU5LKZdpD1XrR+5ZqTHCq
CUehU4C9XoE5GuBP6oGAE8C2Xg7Pab2GcF+iuprWoo05T79Vl8D5UPf9OgsMPL5n
2+Ur/3j6OC7iJVA9+lnf9lQoPlnFhIwKxOaG8vZsYHsxMHpqo0BIpGIRo1yruanc
/h6oFO/CUUpj/VYgUg8hAuzyfGJqghfSfQ6s5nK+NmGu7dK079bNh7uIEWVdsV6j
USoUeoyMjJbkdMW+FOnD2PD4rg0dMIN3gqjZXrWAzY0521FD9FvSObzzHnk89mdP
mCzqfg4RcVwUd3PdNIRVXxPzoKFLkYnY0VvKCBjFzvuKv82u0Is+nVf6S+jC+70S
6Pc32vYf99p9jHZ3gsVw
=kmXT
-----END PGP SIGNATURE-----

--OtZJUqNUNrB9XA/T--
