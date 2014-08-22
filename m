Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbaHVCUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 22:20:25 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54272 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553AbaHVCUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 22:20:10 -0400
Date: Thu, 21 Aug 2014 21:19:38 -0500
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Sonny Rao <sonnyrao@chromium.org>, Heiko Stuebner <heiko@sntech.de>,
        Addy Ke <addy.ke@rock-chips.com>, Chris Zhong <zyw@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org
Message-ID: <20140822021938.GT24407@sirena.org.uk>
References: <1408668895-1108-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nreWiX4Cj9hiu/Wx"
Content-Disposition: inline
In-Reply-To: <1408668895-1108-1-git-send-email-dianders@chromium.org>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 208.59.64.2
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: RK808: Fix uninitialized value
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nreWiX4Cj9hiu/Wx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 21, 2014 at 05:54:55PM -0700, Doug Anderson wrote:
> The RK808 regulator driver was putting its config on the stack but not
> initting it.  That means that you got a semi-random config.  Fix this.

Applied, thanks.

--nreWiX4Cj9hiu/Wx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9qi2AAoJELSic+t+oim9uO4P/3SqdYEN9T+uiY7MgoQUKgI5
7+SHs9i3cxB66vc0a8OAFBMs+cjBdIuCR4NyUn4v9fC5a08YT7UBjgEyd3xS9/Fr
l9O5gMjdeJQjYGvMocxI8/OUbuzjcgq38T+4j2qVTzVsmdN9j1T6INtkU9KkFnRC
QsRNXK55l7UCR1Yh4kavHEaqItQGeG31/kekZJVclqunst9OYi2ry6bCCrx9gu0a
jQvCS/LjURec0++1nFk+nGIVMZcQs8nU4y6DBhHnL7Cn5IpUq1lynVbTFiKzNJ4q
R1vGVyN0SQnjG62wNTUzx945hyObPbDug6Lm8GshmjmtFaMBshK7GWaTUOH5kjjx
ygyks4zVaW8w3OVOswcYwrM/JvxUDIEtt6bSzFvWer4m0geatykV2L0G3gV00FV7
z0YRUjXxq/+oYugjD9cRafirvKoFazz2CXTwRli0xhA5/ruJMRHYCdHwFCwI6be3
bohB2GrGcUlksBYK0VWxrR+O4vcw7dphQwObYExlpVKqfaLS6syckpD+zZjwLwNL
ofU4R1gMnk6jo/C3bguPecbLgQVLZ8zWGuwIKxE+UuFkM/YZI4l0IrA215zlZbYp
FDUI78vVDZklQ2DcpJiz9S5ipeJQy1l6oSvZKk1lUWxfNaA9Lwn3dNES7A0c316q
iPYHvQ7qokj8A3QtW/P4
=MRYd
-----END PGP SIGNATURE-----

--nreWiX4Cj9hiu/Wx--
