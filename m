Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750917AbaCUSUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 14:20:55 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48961 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaCUSUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 14:20:54 -0400
Date: Fri, 21 Mar 2014 18:20:39 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, joshc@codeaurora.org
Message-ID: <20140321182039.GQ552@sirena.org.uk>
References: <1395397296-8196-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CVXKxAdNG2kQIXaJ"
Content-Disposition: inline
In-Reply-To: <1395397296-8196-1-git-send-email-lee.jones@linaro.org>
X-Cookie: Contents may settle during shipment.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: Add new driver for ST's PWM controlled
 voltage regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CVXKxAdNG2kQIXaJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 21, 2014 at 10:21:36AM +0000, Lee Jones wrote:
> On some STMicroelectronics hardware reside regulators consisting
> partly of a PWM input connected to the feedback loop. As the PWM
> duty-cycle is varied the output voltage adapts. This driver
> allows us to vary the output voltage by adapting the PWM input
> duty-cycle.

Applied, thanks.  Please send incremental fixes for the things Josh
mentioned.

--CVXKxAdNG2kQIXaJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTLIL0AAoJELSic+t+oim9TMgP/2lU31I+hVdWrO4DJloGoe6w
OwIN4c+fr3FfernXm4UjeUPGUogr/li1oqETyQfi1Qkwl6P0163is9uMKeoULfHd
Hjn/9IcQ470r9cWwRxluQHIJrs1CZ0PJZMWXSNyO+Uc7EN+scnIFzfQ9dgg4cbi3
zBa2UD6wLtFYlSSvjzH7SHXSGI00sMElXkm3A6mkXR8w4EupoEaNlaVSZ6LQFJfz
lZ9/0FRam3dk/QNu38ZXiOMeCrMY14PWkdzqJGRQUvxtgaU1cZHXRiuicJbavfs0
JIgM7qETZGgZ/UikbHg4NHdHMPKkrt4KfBVdL+vf8l6TqlGRI/rZ4dRE9kmi2+9o
kOCv2zGl/kKyXSSm8GJV0GC/lmJHTinv9VGN3HZeBWDKaVmYCV2X51gHaiNB1IKK
LONrBMK5vtR3cgOZ7inCvew2CFJV+wtdM2jqTcQalHr2EJu5rD+buVNtCXKjEYva
3WTh7LQvDDYkDOhTyvoqGM7jWx08rZ65iOtEq8LTgE47ERPOqhrvcOf5qZs0gpJT
5NxMvAxS0p0jYO1F758jgVrO0dO+PKwZBfmZe7Pa+NkNx/SDYUgUa+GCUafdC+yp
djiPt0OayQknEkEzi+RgxAdCyXsNoBPv0Elm/WNmMMgIVlc6DrACpiXDKayHlFMc
ocAtV9zv3w/PlhYNIcAL
=4s7A
-----END PGP SIGNATURE-----

--CVXKxAdNG2kQIXaJ--
