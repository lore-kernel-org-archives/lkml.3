Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaKKAed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 19:34:33 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58923 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaKKAeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 19:34:31 -0500
Date: Tue, 11 Nov 2014 00:32:36 +0000
From: Mark Brown <broonie@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, Liam Girdwood <lgirdwood@gmail.com>,
        Wim Van Sebroeck <wim@iguana.be>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.cz>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Message-ID: <20141111003236.GS3815@sirena.org.uk>
References: <cover.1415645476.git.joe@perches.com>
 <c8249a5c6504275a0e22704dda83b34002a89eac.1415645476.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YW0vl6bOwYQ/J4Ih"
Content-Disposition: inline
In-Reply-To: <c8249a5c6504275a0e22704dda83b34002a89eac.1415645476.git.joe@perches.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH -next 1/2] seq_puts: Convert to return void and convert
 uses too.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YW0vl6bOwYQ/J4Ih
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 10, 2014 at 10:58:56AM -0800, Joe Perches wrote:
> Using the return value of seq_puts is error-prone, so
> make it return void instead.

Acked-by: Mark Brown <broonie@kernel.org>

--YW0vl6bOwYQ/J4Ih
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUYVkjAAoJECTWi3JdVIfQpMYH/2Kbn9+gPddauhOdQJ0BGVz8
85A17JrLFg6lHJwNli66Oht8PMGCs4gKsdkG7+rfLr4SurZsBH//g8mym6ohWkr9
8tvBo1z74oJDu1JuzDIgRA9uMlKFIJjb3ClhgnGjDWTNCAqzuOwrdf243/+7KlJ4
gvHAi3mASlkI6uh3qCgmIHcIsDT8mcK8hY+I9TnDB0KusBTmNsyOaloEF9iOHs+A
UJHCH/gpq2nI/RAr77B1sJwgf7QlqW7zd6M0CllstDQIlqH5LCms73wXXBGdzSxs
6dFtTlH5ccibzhTYVa/n21WM3RLiPIV6PKzQQwV12GMmMxuHreH/AJcP1RZdmzE=
=8knI
-----END PGP SIGNATURE-----

--YW0vl6bOwYQ/J4Ih--
