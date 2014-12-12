Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760024AbaLLF1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 00:27:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44940 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758608AbaLLF1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 00:27:23 -0500
Date: Fri, 12 Dec 2014 16:27:14 +1100
From: NeilBrown <neilb@suse.de>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] TTY: add slave driver to power-on device via a
 regulator.
Message-ID: <20141212162714.3a2378df@notabene.brown>
In-Reply-To: <548A29A4.7060908@hurleysoftware.com>
References: <20141211214801.4127.93914.stgit@notabene.brown>
	<20141211215944.4127.4186.stgit@notabene.brown>
	<548A29A4.7060908@hurleysoftware.com>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.25; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/nGuruU7=j8u7iA3sSe52jru"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/nGuruU7=j8u7iA3sSe52jru
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Dec 2014 18:32:52 -0500 Peter Hurley <peter@hurleysoftware.com>
wrote:

> On 12/11/2014 04:59 PM, NeilBrown wrote:
> > The regulator is identified in devicetree as 'vdd-supply'
> >=20
> > Signed-off-by: NeilBrown <neilb@suse.de>
>=20
> tty_* is only for tty core functions/data.

I think you are just objecting to the function and type names - is that
correct?  I suspect I can come up with something different.

Thanks,
NeilBrown


--Sig_/nGuruU7=j8u7iA3sSe52jru
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVIp8sjnsnt1WYoG5AQIF9RAAkoi+pYauHtj3C4ERmiZ3mJQZITlYnXE1
WmmnqAxLBa+hhLc/iUNGNmHFCgVCquuxQiwrWjpK44FZfJGnTmy/iVotGo4uWjVY
wGGQd/XSJvnvVppJh/8ycO81ryxFXqj3/zSoaJK0tG9hDRTNeFVIfzP+w9Q1pALT
DYHz7j4gz8w3bK4h3cJCgshp6dNoFMIrgHWAZDMfioUbJMkuPJAfKkwdnH8qCY9M
DcmZQV7uelG42hr+aw9sG6ULt1RvwjY/B/JRhnHqwZJugCz+P5hGy/MdgfM0k5F5
uzQ/p/d1ZfyGUlPCbGKOHgmvRGeS9BnqoeanyqRAdMeJ7jgWrkMtBIkr7cYnI2+u
3BPx+6F26ENyUUJvsjGp/S95PqmygXVG1j7PgDq0ffBFP3ORDBS8HHcGucqbs8YQ
niDxYqMYiJXYAKOH/KiD0H3pm6yhtrkJsYznZNCN3pxkjvFy7wDKI95JtezD8R+9
PQX+LPhfoMXfWbD1aE99Nda0bng37iFMOiDhw9wf8aZJ/6yt2Zz1VFKKX5I+0BVt
G1HSoCCr0KCdRtLgwQwuJTqQxjCgAoNCtnLeWrMt1CbFRreTqQtOH4beCWfqbuVJ
qt8yZzlOEjXIGWdA96l+9OVrydl/N0shf0Xh7e5KXBl6d/bzUDBj28yYzN2S4yPJ
suWpFNRdTds=
=/YQJ
-----END PGP SIGNATURE-----

--Sig_/nGuruU7=j8u7iA3sSe52jru--
