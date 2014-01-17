Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaAQSrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 13:47:22 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56122 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbaAQSrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 13:47:20 -0500
Date: Fri, 17 Jan 2014 18:47:02 +0000
From: Mark Brown <broonie@kernel.org>
To: Florian Meier <florian.meier@koalo.de>
Cc: Daniel Matuschek <daniel@matuschek.net>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Dimitris.Papastamos@wolfsonmicro.com,
        Liam Girdwood <lgirdwood@gmail.com>, perex@perex.cz,
        Takashi Iwai <tiwai@suse.de>, patches@opensource.wolfsonmicro.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140117184702.GG17314@sirena.org.uk>
References: <alpine.DEB.2.02.1401142030110.23472@parallels-Parallels-Virtual-Platform>
 <52D95DA2.7000509@koalo.de>
 <20140117175927.GZ17314@sirena.org.uk>
 <52D97120.8030606@koalo.de>
 <20140117183332.GC17314@sirena.org.uk>
 <52D979F2.8070202@koalo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IRIOLc8eTv1AOxGv"
Content-Disposition: inline
In-Reply-To: <52D979F2.8070202@koalo.de>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: wm8804: Allow control of master clock divider in
 PLL generation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IRIOLc8eTv1AOxGv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 17, 2014 at 07:44:02PM +0100, Florian Meier wrote:
> On 01/17/2014 07:33 PM, Mark Brown wrote:

> > Setting it to false increases power consumption since the device is
> > kept more powered on when idle but reduces startup time from idle.  For
> > digital only devices like the wm8804 there shouldn't be any reason to
> > keep it powered up when not in use, the startup time is generally
> > negligable anyway.

> So a better solution would be to set SND_SOC_BIAS_OFF instead of
> SND_SOC_BIAS_STANDBY at the end of probe?

Yes (making sure that it is actually in that state).

--IRIOLc8eTv1AOxGv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS2XqiAAoJELSic+t+oim9QiMP/jC5Y/+ZmGsu+tqb61SfPyrI
OJKq3/7fwixfBeY+V3B+6wMgMfdhpZnNXd7R0yJ9uC2sSSwvASWV3HhnDSv69FC9
YWWfaf3iJTqGmWpnXnhI/yrJzJ+8trtc/ntLECGU1NnNWbcZ17JFAwbLPSHaAmd1
v9AEoT/SKyPhgGYW0S6hVK7CjGxnSr9p+duDZm4BphEpXqpGhVyjUEMsWtyJzVQj
Y4bevGSHgmJGB+RsAQLll328NEQEkh5/a/ykgeLOxbdCL4k9o4eijJw5Vrjsm00q
bL2wgtwC3a3YbiAWiNONJrNMHz3zWGKyGUqU5XU7PBsAAlS3WBBdqYh4kAEm7cIY
t2Y0aFNxEZeH09tgUt/EthvoXS2FSHIM91rm8I1c1pa9HFn+L+Wz9O+Ufycr3Ia4
PfneTtmfa1sDYLdnVp8+ONKaeFuVMJO8XR7tipi4SCmsijaUo+yCfyTgteQgqJs+
tmiO05n9bQlesoKRCy9R126qybgG9ofjnYXLGvvEmF5PsFEgH/K1OMnfGjcXXWN4
c5M7HhXDOqhPiE57VURRSWqaQd3rEi9KhLaBVBkqCfcC6Kwh8c9DmYB6eBfJmvMR
BlfvCZO5WG3xIaSLdwRIy2d6p7rN4wQp+NiRUn0RNCFWaqfKIZgQm2MTTQGeuDK5
P+G/fdK9n9uwtwWq9P7h
=EVT0
-----END PGP SIGNATURE-----

--IRIOLc8eTv1AOxGv--
