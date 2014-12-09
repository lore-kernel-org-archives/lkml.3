Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407AbaLIQPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 11:15:55 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53317 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296AbaLIQPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 11:15:52 -0500
Date: Tue, 9 Dec 2014 16:15:20 +0000
From: Mark Brown <broonie@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        Jaroslav Kysela <perex@perex.cz>,
        Brian Austin <brian.austin@cirrus.com>,
        Paul Handrigan <Paul.Handrigan@cirrus.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Timur Tabi <timur@tabi.org>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        Xiubo Li <Li.Xiubo@freescale.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Message-ID: <20141209161520.GK1934@sirena.org.uk>
References: <2064254.7lXiTpmK64@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vk/v8fjDPiDepTtA"
Content-Disposition: inline
In-Reply-To: <2064254.7lXiTpmK64@vostro.rjw.lan>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.171.30.28
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] sound / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vk/v8fjDPiDepTtA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 06, 2014 at 03:46:27AM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>=20
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> depending on CONFIG_PM_RUNTIME may now be changed to depend on
> CONFIG_PM.

Acked-by: Mark Brown <broonie@kernel.org>

--vk/v8fjDPiDepTtA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUhyAXAAoJECTWi3JdVIfQ+gAH/RtO167WNmJph1mXUpYcElXu
I4EZb20uXYY4zTHiKzXAYlq/9zJM+IkpW7+3MSe00lA8hQxD03VzeiocmVamMaJX
PWXGu6ifGJU0sMv+Zvxejxjd2dlhhr9Rd8z85luIKi/70a+3i6cJIUtit0DxSWD/
ZSPoPJU/qrsFNVLzUy7iXt0ryYBdEUsnTQCCmekRWPQzkTcfQA1OpCH6dpaS2Pic
yXhZ4fJwl4oQSOVP/XoRPp7SyBgCskwk/dJnz2WRcHqq2tPQkjsE3XSzIBo957NO
DCXIvFBfM/YvSJQQHGkU6DGhr7tVJYxFxfea0lmtHxk8wfyA3q7agqUxNyu6WaU=
=wspE
-----END PGP SIGNATURE-----

--vk/v8fjDPiDepTtA--
