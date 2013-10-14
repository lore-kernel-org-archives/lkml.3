Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab3JNO4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 10:56:42 -0400
Received: from sauhun.de ([89.238.76.85]:51647 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab3JNO4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 10:56:41 -0400
Date: Mon, 14 Oct 2013 16:56:29 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] sound/soc/atmel: don't use
 devm_pinctrl_get_select_default() in probe
Message-ID: <20131014145629.GA17351@katana>
References: <1381681071-6021-1-git-send-email-wsa@the-dreams.de>
 <1381681071-6021-5-git-send-email-wsa@the-dreams.de>
 <20131014131748.GU2443@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <20131014131748.GU2443@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> Applied, thanks.  Please use subject lines appropriate to the subsystem.

That's quite a nut to crack with a generated patch series running over
the whole tree. I wonder if it is really worth the effort?


--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSXAYcAAoJEBQN5MwUoCm2tiUP/2VgGzL7AY40+VTdZAQQKGMV
ANe03M+Xppbs+DbQg1nlYOPBSmEzsOQhLE1uwEUvhZtTBrvU2C69UHmCoRcdINeF
bCJQC6jbJesjUQ65g6NLDlSq8j697qU+RvxKHJw4JbHU3HZPpwYgKLTKNAHo5guD
ic6aSXljXFBqeMm6wSG/bxsqBYbBx628sYSFgOw4moLM53gI6CFkbj+YROI6AXlW
fplpf5v3zTaO+5Hh/GswtnbMNDTv8q+hnl4XlHDFUZj0bJEj2FZONkwdB6t5pu7K
qyLP2Lg00nmXhxZZdcZ5O6/2R5Lmxuc8rBSzhCNl5ZXMIJ7uLfzQHfxjXgG2GCcE
IDyAnmb+xYSDOsyRn1loYkSvfrBIXpvOAhk4gSWrlEOZE6PSgdw2GSUDgJREGiHv
hYwEnaovQuQ+QhaawM8A+ye5jAodHQqxn37YF9VnO9+kNGM3PGu9Fyz2MPx+rsym
HNIOY9Yrh4An22yvXrVXedp69hTycyRDOHf/KNmTv5haVOzzziFMsNi2TK0EVtEp
h603xTDn2VJU3qThpLekVIrTSimJ4V9NZRSSVGtjTqUIoNrnzrpcr6ddL97tAvKU
0gJ1svpVqJYovIYvJyNqBUy9fYcE5Vy7UzMzsPMnLCiaN6cnXecYfL/Onuu3XLDM
y+zHrN3ActPJHAxGpEXN
=BIcA
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
