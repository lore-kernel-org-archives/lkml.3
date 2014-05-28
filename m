Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbaE1U0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:26:07 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45947 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbaE1U0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:26:05 -0400
Date: Wed, 28 May 2014 21:25:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20140528202551.GL5099@sirena.org.uk>
References: <1401306088-10136-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kkRamCq5m5VQq0L6"
Content-Disposition: inline
In-Reply-To: <1401306088-10136-1-git-send-email-sboyd@codeaurora.org>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: Fix regulator_get_{optional,exclusive}()
 documentation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kkRamCq5m5VQq0L6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 28, 2014 at 12:41:28PM -0700, Stephen Boyd wrote:
> regulator_get_optional() doesn't hold an exclusive reference to
> the regulator. Fix the documentation and reword the exclusive
> documentation to fix the grammatical error "this reference is
> held".

Applied, thanks.

--kkRamCq5m5VQq0L6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJThkZMAAoJELSic+t+oim9iMAP/iocG/id/U5fjZ24Iniw5B4N
q08Ib2I0yF7i2j+qMyhicqSmfq6dLOYKR4jONE7rLmelslvDmjbjGTancAU//Y2M
O+OlnMk4wpRtj2KNyhjsmW/UWDfKYB1LqslKN5yX5hUZe6Leep1xjlo56ZOESfnd
7uy8LbubHfLv0YnlDNKXAySnsXykKywbRYZmRzC11szVxS99SA0iDlOgnhxrUcFN
Vwtl4DkOnSKV75OwCRFyjw/mb6VL60j3k6OJoCV3tDwjD1KrdjQGeB5Cot3Q9Mhk
VUUCIqNRYd8SNxXIZYTCF3XdP54PgbmWu/xi/ePJYTnZgRAw6MwEkp6wg49M8NbW
aL9ANLrt4rsNA/ksWtYyNjnPr28yc74fwNBfoz8bIUa8o8Yxp5oOt02iYCOoy1Ks
/q3gCsP3irn7OJUibe+gx/p4hxN21IVGgnX74BHi6qYaaRMcuAxrMexgZOQRZNdu
LFCq72/wMA0TWU+ruXO6ddH4N5a6BG2C7E6omvpMPS+t8E+QHCLGa7CmrzKcVCba
qLRgwVVIgTVwqo3GB5+5HZvSANP7+Nz2WWeigfkCU9oc+Ivf2T+qN+/jw/krQ6EM
KgF4iNuEZ6LgmGU+yC2BoCq4T+mwqjZ9KbBtHXTrvyEbRrofiHF0oapcVroKLgMP
bfoHW1OoWYhCKEqrUDCE
=yR3a
-----END PGP SIGNATURE-----

--kkRamCq5m5VQq0L6--
