Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbaK0K42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 05:56:28 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40628 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbaK0K40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 05:56:26 -0500
Date: Thu, 27 Nov 2014 10:54:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Message-ID: <20141127105411.GD7712@sirena.org.uk>
References: <1415180871-25293-1-git-send-email-k.kozlowski@samsung.com>
 <20141110110022.GX21424@x1>
 <20141126204304.GB7712@sirena.org.uk>
 <1417075182.14847.2.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qSw4Ma5StZvKK9sI"
Content-Disposition: inline
In-Reply-To: <1417075182.14847.2.camel@AMDC1943>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 0/3] regulator: max77686/802: Cleanup
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qSw4Ma5StZvKK9sI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 27, 2014 at 08:59:42AM +0100, Krzysztof Kozlowski wrote:

> Do you want me to resend the 3rd patch (mfd) after 3.19 merge window?
> I've got also some next changes on top of this series (adding GPIO
> parsing to regulator core and to the drivers).

That would seem to make sense.  If you're adding support for things to
the core you should probably be sending patches sooner rather than
later...

--qSw4Ma5StZvKK9sI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdwLSAAoJECTWi3JdVIfQx7gH/3USx/FFQHYGIZbrdEDvCv09
eNQAmxwtqU9gQccMwMWgMu2Fh9aQ/FLMgsykMuzScOG7T4bwemvYK8/2Lcu/yZ3E
Fn+I07up6ZC+Goahdw+OqHp7x5anSQDx+6z/NZygiqzAi0+EYP6Bhup4TX4g7sC2
hLnF5RET6Z34P4uAN/AY75Tf4Dvh5HVicsD6nNVx+HuUhN8ofj/n5M/PMpnF13IN
8Jt27LVMp8CrDCyXtiADYslm2oUmq4TDD/q5zogqCdmv5IJj+gUqzDaYaWCB16wx
C5BUDmeJ1Njs6I6AbZ85iz5S9THr8EwWM5l2b1cVeJW0dLD/TyoUCNtgaZqHJdo=
=0S1s
-----END PGP SIGNATURE-----

--qSw4Ma5StZvKK9sI--
