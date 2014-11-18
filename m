Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964796AbaKRPCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:02:20 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48777 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131AbaKRPCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:02:18 -0500
Date: Tue, 18 Nov 2014 15:01:58 +0000
From: Mark Brown <broonie@kernel.org>
To: Masanari Iida <standby24x7@gmail.com>
Cc: linux-kernel@vger.kernel.org, tiwai@suse.de, lgirdwood@gmail.com,
        perex@perex.cz
Message-ID: <20141118150158.GP22111@sirena.org.uk>
References: <1415721143-13914-1-git-send-email-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WYfJCIN5rqlfy3K0"
Content-Disposition: inline
In-Reply-To: <1415721143-13914-1-git-send-email-standby24x7@gmail.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 81.128.185.34
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] [linux-next] sound: soc: Fix warning while make htmldocs
 caused by soc-jack.c
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WYfJCIN5rqlfy3K0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 12, 2014 at 12:52:23AM +0900, Masanari Iida wrote:
> This patch fix following errors while "make htmldocs" on
> linux-next-20141110.

Applied, thanks.  Please use subject lines matching the style for the
subsystem.

--WYfJCIN5rqlfy3K0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUa19lAAoJECTWi3JdVIfQvhAIAIWTN/ApfUrroL3gWPuHSpC4
Vr82lu70dVjCeSqdyQzD6pq5iqae2wFY+B/OSsQGcn5I12zPi/77bYgRv2gmUVR8
nHMW9VbJnlUrcuqns0LvpUDFbNmNEEye1vL+KsUKYixnQW+VKKlBgL3hSCkVFb0K
/yv9qxLkbEHFgIhNNg6htCNHT90UuHOdR4+pORGc+/7fqfS0+V1uPEJE/NVbU9Es
8hEj2Hjt41m65eIn8Fqr0bsVa8iNL79ObvZjI1Tysq/xmlPgw+g5xvR1BQi2J2gV
ruB99aO0BhIQby5jGYD98YYIDp2povS150Re7+AkGGKvriKQG1JA+eeCw6v0LuE=
=c4w9
-----END PGP SIGNATURE-----

--WYfJCIN5rqlfy3K0--
