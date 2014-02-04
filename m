Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbaBDNMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 08:12:21 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35163 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbaBDNMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 08:12:18 -0500
Date: Tue, 4 Feb 2014 13:12:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Manish Badarkhe <badarkhe.manish@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, gregkh@linuxfoundation.org
Message-ID: <20140204131211.GZ22609@sirena.org.uk>
References: <1391007448-26245-1-git-send-email-badarkhe.manish@gmail.com>
 <CAKDJKT65t+dkjEmjL_sKbmVZYiu+bGyT_7Kft1H22KwMh22u7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O0i8ts1wQXc4Kolf"
Content-Disposition: inline
In-Reply-To: <CAKDJKT65t+dkjEmjL_sKbmVZYiu+bGyT_7Kft1H22KwMh22u7Q@mail.gmail.com>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V4 0/2] devm_* API operation for fixed regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O0i8ts1wQXc4Kolf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 03, 2014 at 06:45:04PM +0530, Manish Badarkhe wrote:

> Are there any review comments on this series?

Don't send contentless pings, especially not less than a week after you
sent the original patch.  That's just more mail to read.  You need to
allow a reasonable time for review, for non-critical stuff a couple of
weeks would be more reasonable.  In this case since you're touching the
core devres code so please bear in mind that those folks need time to
respond too.

--O0i8ts1wQXc4Kolf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8OcoAAoJELSic+t+oim9zCsP/1b4Ru34ESO4eBAvFr+AHvyC
q2HJuSzMwLkYzlp8N8Qzj2um0ZxUu8/LSHZLmLG7shx1U1GewFBvMlf4dukNqFvx
0bLSoVRQfSzpB4tuQCeViHfv/zy3qzc2+iLr+xjEX61tHPqXZKHIT62A54y8npGP
RQcHE48ZIvKuXx7QiKvKbOhaYcRAoObSe9GeMNje0zTRvBj+54AQH3ADaAOcflNg
Q8ECk64TzJcmJL4Mp3z/0O922nP9tV5PJYLIRqzRWqBnsuCIWcFSFRj/m4qsjGpG
XdUQpdLF5jZNfdPEkLcQzn5rX+nLK2wb6eFrOjEYxjoSYMt52Sf+W/NFQfI1r7Ml
XzpFnsf2NVr1DWZMtTmLQE7vTeiFQBhyY2oJGMkwWveQbZd1VdUJjvzwpOdvPkFt
7nrqS+8Ab9E19Vsd+lMjXqwt1y6gX4TiMvY5+rCw6+D7UO6cCQlPfk9gb70MzaHn
uTRfBd8E3qqnSpab62DDfsSIxhRQ+QQGSaH3d7hLxCtrueurMmAvXmn2CSArrd8k
M45I3Aj2yQ2Ms0ch7UQL6vKWkPTAlSxvYTursULmH12u0TI1yik6MmVShr/Zz9QR
j5WixXnZXmItCVmS0NcdD2UTOM/UIFmyE+dXrhyOf77dPM6nveHb2zAzwwdxoJ5o
DdfJ+QgxLoYAaR8SRQO4
=pdcx
-----END PGP SIGNATURE-----

--O0i8ts1wQXc4Kolf--
