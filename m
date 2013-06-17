Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab3FQQJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 12:09:01 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60958 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab3FQQI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 12:08:59 -0400
Date: Mon, 17 Jun 2013 17:08:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, thierry.reding@gmail.com, patches@linaro.org,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20130617160853.GG1403@sirena.org.uk>
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
 <1370864113-17895-12-git-send-email-tushar.behera@linaro.org>
 <51BED2F9.1020307@linaro.org>
 <20130617100525.GA1403@sirena.org.uk>
 <51BEE64C.80608@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tZPt2X9wWvZFnOOr"
Content-Disposition: inline
In-Reply-To: <51BEE64C.80608@linaro.org>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 11/15] regulator: ti-abb: Convert to use
 devm_ioremap_resource
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tZPt2X9wWvZFnOOr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 17, 2013 at 04:04:52PM +0530, Tushar Behera wrote:
> On 06/17/2013 03:35 PM, Mark Brown wrote:
> > On Mon, Jun 17, 2013 at 02:42:25PM +0530, Tushar Behera wrote:

> >> Ping.
i
> > Don't send contentless pings.  I seem to recall you already got some
> > review on this.

>=20
> The comment was on removal of the error message during
> devm_ioremap_resource() error check . Since there are a few other error
> messages in the driver (related to devm_ioremap_nocache) in the same
> format, I prefer to leave this error message right now.

So we should say the same thing repeatedly?  That seems silly.  That
seems silly.   It's like the contentless pings issue...

--tZPt2X9wWvZFnOOr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRvzSSAAoJELSic+t+oim9by8P/14JZqxcjgaJ1SqGZQOEcidR
ZIpJlK1r5m3VySGx8niGxKv3ApmE1ZKNBbZNi/nsbKmeQPF2wsRDkWupceuuUyEh
crf4VJAey57oNdbmLX6MRhih9arSJz4UmhciUpoP7RaCxX0tS67DNBd14f10sK5G
6JbV1Idu3KZxv0wH3ITgQQtNmsDFZFbq3AMkJ2NfjshUWsNL5q5WZ3vPbdfnZXi4
Rqq3lxw5HYQbX67c7GbhRKsZtvXVhc6FgluhGIjSQ30/pw+t2pppuIbPYnWUbroo
JELqmu91nDpmDzKl9qVO72ZC1xJ5/c4bg7BAPafwoxe6KTwmaXJKswA7jdjUvvUi
epXsS9uEjtYIAYrAWLCz24GDOFq6mSWfPwxSFUT1oAje27h8axYm9HdVH0TmwJqR
it7gJfbHBYxqAkzP0Eql8e4gImwlkl9twOXgransOGBVWaSx85U6qIJhsm4Vjb7S
StUULkqcvkW/oCLY77AXxv7sSoX5waDOc5LxiNA7PA6z5XfPkMUqtbTZXnWHcLZQ
jA7/WM4D+TrJS/5TTiMRoRPqYxOcbOa1BZevS6nisCkHgBjwNf2+Zn7hJMkHJu32
QQknNcJ7jIpG72rXCjJP23g68oYQIENvoCop8VcMHl74hU71/jHAm18/Kyt0m27g
A0j0YYgdy6CuySOHSrAa
=yY00
-----END PGP SIGNATURE-----

--tZPt2X9wWvZFnOOr--
