Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab3GXOiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:38:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44067 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab3GXOiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:38:11 -0400
Date: Wed, 24 Jul 2013 15:37:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Message-ID: <20130724143748.GI9858@sirena.org.uk>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
 <1374602524-3398-27-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1UHwWMNIfNKl+QsP"
Content-Disposition: inline
In-Reply-To: <1374602524-3398-27-git-send-email-wsa@the-dreams.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 26/27] sound/soc/txx9: don't check resource with
 devm_ioremap_resource
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1UHwWMNIfNKl+QsP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 23, 2013 at 08:01:59PM +0200, Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.

Applied, thanks.

--1UHwWMNIfNKl+QsP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7+a5AAoJELSic+t+oim9EBoP/RO/Xe3zdOCuTi6k6fy0wev9
MvJdJ18KXnYF5kPVPqno2+sZY1JGa0tTpaV/FCd5SFOwiuz2JuYofaZR7NOPmHTS
a4s7vW02GgB10V7RNqhZWP4rfbUzMl3V+AiBvR90m75mcBU5WAGNh87dnJymPdLZ
Tux60MkFuanMG9EJClfXz1vewblLg4NHDwbP6BGk/HD50wPAzpMY2YUvqZZHLSnm
B1Ee0H699EYUNUb3L4weYDJvuvvEt2izJqwNzUcdM18rxut3ZVGmSazRai1r3lyc
7XcYk33jPmetgx2yewB+q+6mHctCgRi7MVv7i8Imo6z66i5qAwGavzfJvXrmxbcL
ATkFv4juyjnBqYsrS8AXls+NG7vrh5nBi1mNoDK/qkLjHDHnhRCyYHIJThSIH0jn
oDh3bS1+bbDlO0ptMiyVZa989iWMj4IfQiBZ/xAm8NgUA+u5XCH6hOlYFyvZmll3
u+zEMzrXLG2nE4dFkswC5WsQ2jNjxGGng/sVfJhqIQoiFSNbvD2noHBN3LMHqfNX
J7EZ/DjWNW84T3OQFkdRlwnqCunhresQIrdNO8In5l65f25wAPvUF16PpQ0wicI6
EDULeVNV7e0ThSzOn7ptUeO04hrQUZQ34YOLXY5qRzliRr4hdQ0XpwSDXPM037rC
0eMdBOGbrJsuKc7mhptu
=18Ln
-----END PGP SIGNATURE-----

--1UHwWMNIfNKl+QsP--
