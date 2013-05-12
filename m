Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab3ELO7O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 10:59:14 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45464 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab3ELO7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 10:59:13 -0400
Date: Sun, 12 May 2013 18:59:06 +0400
From: Mark Brown <broonie@kernel.org>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Message-ID: <20130512145906.GC4046@sirena.org.uk>
References: <1368008409-15250-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XWOWbaMNXpFDWE00"
Content-Disposition: inline
In-Reply-To: <1368008409-15250-1-git-send-email-srinivas.kandagatla@st.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.247.243.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regmap: debugfs: Fix start_reg calculation (v2)
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XWOWbaMNXpFDWE00
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 08, 2013 at 11:20:09AM +0100, Srinivas KANDAGATLA wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>=20
> If we dump syscon regmap registers via debugfs you will notice that the
> dump contains lot of XXXXXXXX values.

Sorry, can you please rebase this against v3.10-rc1?  This patch was
against v3.9 and I'm not now convinced that the issue still exists.

--XWOWbaMNXpFDWE00
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRj643AAoJELSic+t+oim9zsIQAJz/tLonV3INcLPtntTvay1s
PRERUpKuJTg2Cfq5bI4VbT1jZ1JfVFd+60wGwv4gG2p1zDx3QBI68ZCfZlB6t0ae
J1jQX1GQ2uR3iM9l4OmyXdj0Q0R6uhoCaE5+/Sy+apRwantd8tEofNdGwtuD8vlv
wEVTu7n89R0SG15mtn++xlyy73VG/VgYr+SilVwUGSkciud8Odcqv8iNJx6qo+sj
ld6FGeq89K9jt/o41Z403n5R2HOYihUvV8OmvhSlDk28itpM/t80Nu2M5sqGf7ge
KLU6f0aX3nXr8IFvk1V0+M/l0J45lu9DcugKFiu65QY7/nvxrUry40nrPE+sxBUz
8/t6Tzh+tpiOTb214u1oRpkjyaT96FdXRCf9frFOsSaQBj9fHedX4tIo3VSrkZmt
vM0RY5D9MrEflG1jYbvF5sJmEUjccSKVZ6iJEbIeOYzF4FAOrs724yJveuOl/GTM
LWHcuiMgl+z5vlZNHx2YuZoP5YwyydMnS9DuBNV4rJoPx2JJrcsP6CMn8v1WnpTL
KLKXH2QxRgk8+npKkyb8hulSV9FOnA3YB6BNsYeJILSYRZ8G2i1b4jqWzWRlZ1hc
vJcz7ZstjnzOJPY/hGQgQr8jy7hqTbrKTTGM18Cf3LFSGgu2RiKs9H2QjnCzFcxy
UJvX2+eAhKGqdraehXun
=qtEx
-----END PGP SIGNATURE-----

--XWOWbaMNXpFDWE00--
