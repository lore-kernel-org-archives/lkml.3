Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbaEQNbE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 09:31:04 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59911 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbaEQNbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 09:31:02 -0400
Date: Sat, 17 May 2014 14:30:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, Sachin Kamat <sachin.kamat@linaro.org>,
        Axel Lin <axel.lin@ingics.com>
Message-ID: <20140517133046.GA22111@sirena.org.uk>
References: <1399358258-21536-1-git-send-email-k.kozlowski@samsung.com>
 <1399358258-21536-3-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SnACAX3oZLWUNEDt"
Content-Disposition: inline
In-Reply-To: <1399358258-21536-3-git-send-email-k.kozlowski@samsung.com>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 217.44.186.29
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 3/3] regulator: s2mpa01: Use rdev_get_id() to access
 id of regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SnACAX3oZLWUNEDt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 06, 2014 at 08:37:38AM +0200, Krzysztof Kozlowski wrote:
> Use regulator API rdev_get_id() to access id of regulator.

Applied, thanks (I did actually apply the v2 of the first two, I just
replied to the wrong version in my mailbox).

--SnACAX3oZLWUNEDt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTd2SDAAoJELSic+t+oim9LdoP/3t7VwT4Oi52s1OLJkDirF0U
5btDW6E385deZolYpfzhtnyYL20YIb1SjP5ciey5IuKcf13XRMRDHR3pF0iPsgXT
OyCGhKytm6jsa/GAgxHPt8fTATk2j6QsR4ilegOF9ejOeNcw7OAQYG9FqiZviz2J
7yDoaWrLrt1HgaSH1ZQHsGUexvAtMbG74NpXWfOOpzHdYkmaCLJmulFhNqlT3Tgq
baHhMAxrh7DjorHh+vDMe7QZZ4QfDpMLkUCSf5GNEwlA7rvcGG287Xg/jHiO0h5K
l46TptUtjTou63uFvjB6NphLk6LC8a9P+O5oKBKiWszS+A7VLTqED2o4ZvlEat8a
+94clYmWwAKaN4X4yJcAv4QcbTTXRdR1gpHSjgKwavYznWH1IxsjWHNylxJb1mkn
ywbycpalLGrc8KdbcsTODpt7L0B7yXteoC6pmB0ZRRDgRQtjY+exvAygQTMmCRe8
VFV+PMhQq1qqOu+4SgGhNwX2PtxwoCtM1SWnj+v9/h6oQ5VhCKgPhkpxPhVO4PZz
N+oWFU8y2c2w3blTmLNSIh4VTbeoi+8Zu9Gv+bt26zROTmUaV83bkZ222B83Woit
AISQkD4myhgIwascatQ6TI4BPcb8DgynTREOvEhQlE2CJ8hWdO+dt3rtP+POThmQ
kF3K6+E9DuZaDIsceH3a
=Tdpn
-----END PGP SIGNATURE-----

--SnACAX3oZLWUNEDt--
