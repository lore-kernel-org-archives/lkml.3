Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbaAIOLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 09:11:06 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50083 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaAIOLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 09:11:00 -0500
Date: Thu, 9 Jan 2014 14:10:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-ID: <20140109141053.GA24418@sirena.org.uk>
References: <20140109054104.GH1265@elgon.mountain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <20140109054104.GH1265@elgon.mountain>
X-Cookie: Many suitcases look alike.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [patch] regmap: fix a potential leak in regmap_bulk_write()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 09, 2014 at 08:41:04AM +0300, Dan Carpenter wrote:
> Static checkers complain that there is an error path where
> _regmap_raw_write() fails and we goto out without freeing the "wval"
> buffer.

This doesn't apply against current code (these functions got rewritten),
can you please check?

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzq3qAAoJELSic+t+oim9zfEP/Aq0UGql2MU6+w/g3W1zUy+E
sE19Zxnirwx50KRI4hwGU8D+aAZ5JHuknfbQBkFrvyLtdPBAWvjPnb34/LBDiTsw
c/u7kyv+PPBMxgMgmWpBF7d2thySF/y8T2dWMT9X8f75BWFNyMcdHlGjNkCYa1vI
yU+hQNlzYGOx6jH8QcdVgRVccrc427P6cGuzQ6K3JI+Xl0DNPN7jpUYbFnr/QXpF
IGm/6irUGN5JgacOPY50Ni5jadsGAZT/mpStWs7RAWEPL1f+GgJRvzLPKf6Rboea
w7I/D7NksQIlUxIBjD7vSfIUsnkb6WM/MTzZkXgl4YRyrF22/AZSDXKb55gcmPeC
9yBvBDsvowp+hURqVTAYtZfM8MSP3KzTwMG0wLOys7dx4WEqCJV3CYZWSEZG255S
ZlN1hMJmCvjbN+JOg6wogO/ksNctgnpm0M14A52JkapJQpZFwlvP6Qs5vSB1r7Tw
xbKLMcQSEc7iNdeNy/5ZdXvDFbJFRAATRgkG+se2cwNsKcS1THoePsA34mabM+jt
H/4is3m++heHXN7J1ltkyX6GWBBq14vhpnlyv+MC2b+lKHW5hiB2oOjW0QUhPPRn
Cfi70riXXmGpxXtTdRRRMwh9+zuvm3Z3v5N9XHBXL6Zy5qg8drno7yTCbjysmmf5
hQGf6XwVcnHQTUWoo0Sk
=6FtH
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
