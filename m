Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab3LJLPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 06:15:32 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55489 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab3LJLPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 06:15:30 -0500
Date: Tue, 10 Dec 2013 11:15:05 +0000
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: Nicolin Chen <b42378@freescale.com>, lgirdwood@gmail.com,
        alsa-devel@alsa-project.org, tiwai@suse.de, perex@perex.cz,
        linux-kernel@vger.kernel.org
Message-ID: <20131210111505.GE29268@sirena.org.uk>
References: <cover.1386344000.git.b42378@freescale.com>
 <105d07ac1a77bf99872d75608c97b3342079bfb7.1386344000.git.b42378@freescale.com>
 <20131209175640.GL29268@sirena.org.uk>
 <20131210051740.GA10655@MrMyself>
 <20131210102523.GB12042@MrMyself>
 <20131210104745.GC29268@sirena.org.uk>
 <20131210105135.GC12042@MrMyself>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I9vJvZLOUpy8mCjG"
Content-Disposition: inline
In-Reply-To: <20131210105135.GC12042@MrMyself>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/2] ASoC: fsl: imx-wm8962: Grant hw_params/free()
 permission to control FLL
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--I9vJvZLOUpy8mCjG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 10, 2013 at 06:51:36PM +0800, Nicolin Chen wrote:
> On Tue, Dec 10, 2013 at 10:47:45AM +0000, Mark Brown wrote:

> > For this sort of question you should follow the DAPM graph...  the
> > headphone and speaker mixers have IN4 and MIXIN as inputs for analogue
> > bypass and the STL and STR paths provide digital sidetones through the
> > ADC and DAC.

> So I could test it merely by using 'amixer cset' to enable those switches
> without doing anything to power WM8962 up as long as my operation follows
> the DAPM graph so that the DPAM would automatically turn on the regulator
> for me?

Yes, as soon as you have a complete path from an active input to an
active output the path should get powered up.

--I9vJvZLOUpy8mCjG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSpve2AAoJELSic+t+oim9wRkP/3nGtH11Vu7mPD5WiGzUxZw7
DojbN7+pImi9XwvnhPO7IipCRIGF6wRY3DVfeqV/sMxqb6zFSYYFm0+aX/kvsbQK
rAss9vd+umLfGDDDCjoc//sO3/DfakfxGtLWUgEj0TLvGpQ7olRnbraXGS7jIPRA
wq1oKlQcqaWw/snyVrETZWoD5bSRpWoDfkDjyJaepWgZYRxj8mHthxqRS7Rc5aGq
3Kd0T5hj3Cahk3xgsWaBydrjI40hzNu++K718yiYtpicmo+8LZJeJS9oXBs7DUPf
kdfpfgh9abb0pUJ8y/SaabMOYEPQJHT6ovZKUT8O+zihw67ZgyE2hkvnv9b5cjvZ
aA9L3MJJRvehOHiLQQ/XNFex6eUzZdguIRXLUCFTSZtt6dS0FdCnNso3cVzJ7zH6
sRROo0Jrhr44Bk2e4FXEea6g5dK2SfjjbELNZ/0HzwdZOfvN+lIvqrO6BCosz/95
lPUeiSTi6ijKE+Hi1FlcDWZzV/BGi8s5Mi8H7rW1hVhhrxNCXAlxLigxxLkSZ/I2
1zxEFR6yLa0KunjAxIPdKaefdGbzQ3co6VAf9Nww2FYffCmN0iZTwo1Y33rpBiA1
Mf0yAqceU3ss+og6t5LeKWRIHREbkhfFVOWk6vjGdERwySH9fBHUDkQ0Ab3hF/3R
qPcYvhyLDTWTEUsb/Zmb
=SXDO
-----END PGP SIGNATURE-----

--I9vJvZLOUpy8mCjG--
