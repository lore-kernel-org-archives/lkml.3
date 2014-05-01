Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaEADe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 23:34:28 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53525 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaEADe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 23:34:27 -0400
Date: Wed, 30 Apr 2014 20:34:12 -0700
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20140501033412.GR3245@sirena.org.uk>
References: <1398850268-22258-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="chReQkDOePndSGWY"
Content-Disposition: inline
In-Reply-To: <1398850268-22258-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 12.104.145.3
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: Fix possible ZERO_SIZE_PTR pointer dereferencing
 error.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--chReQkDOePndSGWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 30, 2014 at 05:31:08PM +0800, Xiubo Li wrote:
> Since we cannot make sure the 'len = pair_size * num_regs' will always
> be none zero from the users, and then if 'num_regs' equals to zero by
> mistake or other reasons, the kzalloc() will return ZERO_SIZE_PTR, which
> equals to ((void *)16).

Applied, thanks.

--chReQkDOePndSGWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYcCwAAoJELSic+t+oim9I8gP/2FxY0z7027AF3qdlewe2vq2
56RYMY2fievLw6/1KpD7n/QrcnF/II2GDbTLUmg3jgMyCwn/qrYyofTLeFV8wqth
CH26XKer+w/aeyXBPPDw9JLWTtVB87RIRAc/S338q3ebDhjXz2QGhAN2XdH13wnP
6lKdLoot6xA9A6O2cZuPOHtJowve9n1139HzeAshvZpOO9fFFyC9qK56D56Z/duJ
RgL/Y0ewhZpK6oi3SYwB1Lvq7oNK8r1HrDyncPylCtC1JJQ6SzI0vpu8Cg9bBUJJ
QhplGYI6/3l24MyaESAJ/gLVPzzaoVU9FxlDYvQncsbWQ3OEsUccvyWt0mwz5vue
qHBMN4+PQdHSm3XrtV6WtUo6oLoxcwypp4cHLcBae6RF7TgzOs4KaTPu3WCjk3jW
7IVWnobbk+wdFhX0LsczwCe7aH0ww9rBtsxQYzqoeRgnJE0eoN+KnVzifnBEsceA
MVMfTZ3yygjvVadTiEkKeHQSdjqt4KlXh2YY9oTsuqSNkCirleUYta/crUo9HmZ2
aFUxzI+3bFg4UiO8qnBK1+iVW9J4QoYjNes6BeIU4BeevchrpVDbDDGqBkCZl4h3
4gojlp9Dq3DHoNYFOvBaD5iUBIsJuLrSKpKP/UsX0ojhQYULW6myKO/2yy3bQj9x
dMk6WD9Jua+tiiWCtpbn
=zTkG
-----END PGP SIGNATURE-----

--chReQkDOePndSGWY--
