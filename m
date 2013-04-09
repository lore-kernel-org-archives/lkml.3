Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763105Ab3DIRcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 13:32:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38801 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759682Ab3DIRcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 13:32:18 -0400
Date: Tue, 9 Apr 2013 18:32:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Mack <zonque@gmail.com>
Cc: Josef Ahmad <josef.ahmad@intel.com>,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi-gpio: init CS before spi_bitbang_setup()
Message-ID: <20130409173215.GX9243@opensource.wolfsonmicro.com>
References: <1365525613-27198-1-git-send-email-josef.ahmad@intel.com>
 <51644A98.1070904@gmail.com>
 <20130409170800.GW9243@opensource.wolfsonmicro.com>
 <51644BB9.4010908@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CjAlqr6ZqJYkDGFX"
Content-Disposition: inline
In-Reply-To: <51644BB9.4010908@gmail.com>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CjAlqr6ZqJYkDGFX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 09, 2013 at 07:11:21PM +0200, Daniel Mack wrote:

> The reply was fyi only, as the patch also went to spi-devel-general. Can
> you pick it from there or should Josef send it again with your address
> in Cc:?

Please make sure stuff goes to my inbox, I *can* pick up from
-devel-general but it's generally painful as my list traffic is going to
a different e-mail account and so on (plus I'm heavily backlogged on
list traffic in general at the minute, and sourceforge is full of spam).

--CjAlqr6ZqJYkDGFX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRZFCZAAoJELSic+t+oim9zbIP/2UpEn+bGen2OxGwv4rUquL8
RSkIRBnG//TvMG82amdPiwlIE1LQoFokFjR80Xc3LOTaGaWSBKNXw2hZnMGn0sbL
V7sgeEH8PexESDIZQN57R8oHbS1x/hHizOuobYyQadkUJzs4ooCLvR9PCNY+fZCm
SsnXNiuwhgFicATWUB/TQ/uRQJAFoPRAb1JZxoNxQIEfoBF4xRACIc8wOA02T1i1
GirJcEspd2J90w5oygC4EwdbQOCjkDukV17UmJxtP/+tpl9RMzUABwjQfkHdnwK9
qIdD4de4cxMeNoNgvtrIhfuxJFteRPxyMUtVw8e/T5BdaVYy/ZHRTRW1ghSxPFtH
wbc29J4n/Awozx7lNGYPVsNQFMwog69Fkzuu7jd2LHbKAWfZsHwihoHUb8OrEYfG
F7zylAW/ogdvjynrktPJb3+G0wfdrKUX6YwQdLyYyblMQFNhX+zmrprqb0LZ2ZyW
yjguMZFF1pN+7ULw/tWZhARiuhInvb+c3w/ddaBN5nYCYHnZsOamt12w60xWuzao
ksB7AlwSID415oeIhafKQdpEll3lwIO02++9sZeSkNrOAxVKj+xGfC2e6HAQ2QV9
4W4vy40ByKo0yaey33vpDTQYiU8Ltc7Y+x7wAZ7q/AQveVqOOd92vMscyeqqPfWU
Z5Tg17uRb9dbP0eSTXuV
=8KW5
-----END PGP SIGNATURE-----

--CjAlqr6ZqJYkDGFX--
