Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374AbaETWYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 18:24:45 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34849 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaETWYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 18:24:43 -0400
Date: Tue, 20 May 2014 23:24:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Qipan Li <swingboard@gmail.com>
Cc: baohua@kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Qipan Li <Qipan.Li@csr.com>,
        Barry Song <Baohua.Song@csr.com>
Message-ID: <20140520222431.GL12304@sirena.org.uk>
References: <1399185156-521-1-git-send-email-swingboard@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ucHyEj4p8g/TNcY"
Content-Disposition: inline
In-Reply-To: <1399185156-521-1-git-send-email-swingboard@gmail.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/2] spi: sirf: decrease the interrupt count and
 latency of PIO mode
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7ucHyEj4p8g/TNcY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 04, 2014 at 02:32:36PM +0800, Qipan Li wrote:
> From: Qipan Li <Qipan.Li@csr.com>
>=20
> current PIO tranfer method be described as follows:

Applied, thanks.

--7ucHyEj4p8g/TNcY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTe9YcAAoJELSic+t+oim9rHQP+wZWXbyCeEpwjhZUq98LGlOK
FzccE5IAeJUfyhGI6PnqfrKict6iEHw6jkhTQb98DKJvrkKnu+veF1QwThvtgE+k
/+dY0jXexarqWbUaKi4pNrBxFKi58Am7skpkY9YoqmkFQNi4IVOxevLIM3mwTrQZ
AiBT0kBOOXax/SVC5w1k5DGEBqvsp5KBV+aKLUxjEAHbEzKyBLo+1LyTS5yJAFZz
TG10AVLkRVjD1eXo4QS/3HvwCCGHR1fsFI5RqfZMsszNXRtF8xyc98uiMnfL1tsC
/Mc5d3wodO2Q0l/tTzpJLz2q9Qzen38w3pFcGPgL7nb7rNnj2+fPtMZ6OD855vlx
IaJ57WT4Zqh3vV1WKsCMErOmNkEV64gU0aU1iEVOQd+wgDIkyIDuMUt0DXaZImmw
Y52YqYi5bMwRkYLu2yR/3YtQS1evgEJZkNso1yPpp8jwTSQNNiW5fbGFEXTfhMNP
0KgPtQ34yK82L69y4jxUAWrMTUOk00wFv8NAGvB98Pad+YD4rlxwOI99+aiX9UEL
HXTHA/23FHx6mEQYyR7gUcw8L9koogKlwPiB+4maItfq1MKwXFofhekyXGk5OOBt
wwcKr8W8LUp0zS0HWNOBOsKUicClagQAv3/j7fmh9ahvJ1PhPHSPL42elIE4ShNA
s6+aCQQEyGbQeWQhLK40
=EWWs
-----END PGP SIGNATURE-----

--7ucHyEj4p8g/TNcY--
