Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaAMQKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:10:54 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53583 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbaAMQKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:10:50 -0500
Date: Mon, 13 Jan 2014 16:10:39 +0000
From: Mark Brown <broonie@kernel.org>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Cc: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140113161039.GA29039@sirena.org.uk>
References: <1389319550-12238-1-git-send-email-Li.Xiubo@freescale.com>
 <20140110110900.GC29039@sirena.org.uk>
 <8ea36054cbe745cf9ce5c5d4a786f9ff@BY2PR03MB505.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yHgig3XI5r20tkjN"
Content-Disposition: inline
In-Reply-To: <8ea36054cbe745cf9ce5c5d4a786f9ff@BY2PR03MB505.namprd03.prod.outlook.com>
X-Cookie: May I ask a question?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl-sai: Add device tree nodes and its availiable
 check
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yHgig3XI5r20tkjN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 13, 2014 at 06:15:24AM +0000, Li.Xiubo@freescale.com wrote:

> > I would expect the of_device_is_available() check to be done by the
> > driver core rather than by individual drivers - every single driver
> > should have that check.  Is this not happening?  The check for np is OK
> > though.

> Yes, I hasn't found the core driver does that for now...

Are you sure, we actively use the ability to mark devices as unavailable
on some systems?

> And IMO this is needed since the SAI driver is only base dts. And maybe
> the device is not presently operational, but it might become operational
> in the future (for example, something is not plugged in, or switched off).
> Or A serious error was detected in the device, and it is unlikely to become
> operational without repair...

I'm sorry but I don't understand what you're saying here at all.  These
are all things that might happen but I don't see the connection between
them and the benefits of implementing things in the core - surely the
more functionality there is the more useful it's going to be to factor
all the code out into the driver core?

--yHgig3XI5r20tkjN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS1A/7AAoJELSic+t+oim9Z+wP/15s3Uzm929OYV4BNSH8A27Z
wAyG+i3772RgeySypsKg0k5GITomLMTbcbtLH8vn/UL2P2z9J4qfFAGokuN2t5o1
0KB2VFVd1WqeU2PyiF7VoZALc05lNG7fAgNawaQU8UQ9CTkryN+iTcmEkpII1FcL
6Uw4yFNvRxxBgjDDWMlcixObN+U026R2wG2SLz9wgk5lvm06MUpaMPpWXpFOZMkT
FentX5pMOlFxzE/Ca3WuCFrldUsBlpyn0o72NVs9Yuea5OLO3TTS12hLJvuI63MN
vN6EoivyydX1pTICp+RJcvg9F7CxvYvzbzoP6OuACELMso0e2oFV7029oLW9Xhjf
8/ez1VZcLkCq0Pz3gEarZVeMCwcSjjxx4h/RlyZ4IfcVMaop70Rs1tU4e5gNwjoB
HYwzhAUXL+5QN+uQJxzzzJmqGcGo5Jq2MssOafcGkfY3U+Ec/6foQ7B9r82s96h2
HiOiL3/pfYHvuSn/rbv/VCu+2gNHym/DRcykvvykdXspbGvTo+TEvscF6sdfjMPX
OGDl2zqJsaf5WH76BbO4KBzLz8x7ykm8V4e/zYkqbQunQU0kgpGLpmr7bits9Udx
zYLhc2KjTfEfNJhsJfCyoXhVkkljVySpN8HF2m0rT4b0Fgl66G2QL0TqJ+gNuZkJ
azfb27qy3C7srozylGN7
=r134
-----END PGP SIGNATURE-----

--yHgig3XI5r20tkjN--
