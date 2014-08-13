Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaHMKgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:36:23 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:63394 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbaHMKgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:36:19 -0400
Date: Wed, 13 Aug 2014 12:36:14 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 0/3] Thermal reset support in PMC
Message-ID: <20140813103613.GA7624@ulmo>
References: <1407226380-747-1-git-send-email-mperttunen@nvidia.com>
 <20140813080744.GD7735@ulmo>
 <53EB1DF5.301@nvidia.com>
 <53EB250D.5070207@nvidia.com>
 <20140813085728.GF7735@ulmo>
 <53EB3556.9010504@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <53EB3556.9010504@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 12:52:22PM +0300, Mikko Perttunen wrote:
> On 13/08/14 11:57, Thierry Reding wrote:
> >* PGP Signed by an unknown key
> >
> >On Wed, Aug 13, 2014 at 11:42:53AM +0300, Mikko Perttunen wrote:
> >>
> >>
> >>On 13/08/14 11:12, Mikko Perttunen wrote:
> >>>On 13/08/14 11:07, Thierry Reding wrote:
> >>>>>Old Signed by an unknown key
> >>>>
> >>>>On Tue, Aug 05, 2014 at 11:12:57AM +0300, Mikko Perttunen wrote:
> >>>>>Hi,
> >>>>>
> >>>>>this series adds support for hardware-triggered thermal reset to the=
 PMC
> >>>>>driver. Namely, it adds device tree properties for specifying the I2C
> >>>>>command to be sent when thermtrip is triggered. It is to be noted
> >>>>>that thermtrip won't be ever triggered without a soctherm driver to
> >>>>>calibrate the sensors, but I'll follow up with that patch.
> >>>>>
> >>>>>pmc.c required some juggling around to make the match data usable in
> >>>>>probe, since I didn't want to put the code into the initcall either,=
 since
> >>>>>the soctherm driver won't be initialized by that point anyway.
> >>>>>
> >>>>>Series tested on Jetson-TK1. Should work on Tegra30 and Tegra114 too.
> >>>>
> >>>>Can you describe the procedure used to test this? We currently have a
> >>>>bunch of features in Tegra that some people have tested at some point
> >>>>during development but the test procedures never got documented. That
> >>>>means whenever we want to test something we need to go and reinvent a
> >>>>bunch of tests after the fact.
> >>>>
> >>>>So what I'd like to start doing is collect tests (preferably in some
> >>>>scripted way) so that they can be kept in a repository that people can
> >>>>easily clone and run on devices.
> >>>>
> >>>>Could you provide something like that for thermtrip?
> >>>
> >>>Sure. I'll see if I can make a just a test script or if a local patch =
is
> >>>needed to test. Btw, I also have a pretty nice test script for EMC
> >>>ready, and I agree that such a repository would be very nice.
> >>
> >>Here is a test program. It it works, the device with immediately shut d=
own.
> >>
> >>https://gist.github.com/cyndis/66126c9c176b5f94a76f
> >
> >Is there a way to set the trip temperature without going through
> >/dev/mem? I'd expect the device to have a sysfs interface of some
> >sort.
>=20
> The thermtrip "device" isn't currently exposed in any way. If it were
> exposed, I suppose it would be exposed as thermal zone devices, each with
> one trip point. Even then, the thermal framework doesn't really support t=
his
> properly; none of the trip point types really apply to this kind of trip
> point, and x86 systems don't expose their trips either.

Okay. The reason why I asked is because I'm not sure yet that having C
programs in the test suite would be good, so having something that's
easily scriptable would be preferred.

> Anyway, since debugging is pretty much the only use case for modifying
> the trip temperature, I thought adding the tz_devices would be a bit
> overkill.

An alternative could be a file in debugfs.

Thierry

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT6z+dAAoJEN0jrNd/PrOhWk8P/0t5YQTWexFH7y6bhKc2nC52
51sc6A28bhFNNGa4h1Dzc4kIwHDp1tnZjCud0sLgM9ot7zJ1OZINaZE/hhNARJ9I
bVp6U40hh3WW9YLrI19Zug7cxPaiN06zcpUldHKMMsYYjTtIQPhtPhp8DIwH5WcW
xkEN3fcoTfVJyxu0U26ProqrWspgeozDPH6vtpXMt7lwibnuKGcenj31uG70P4DB
Ju25BV6ezQgt/r0msWARu2AC2L5BXy3Ldg6G66WDX72kHyxhBFYmXYyiC4kjAQ/l
Mmw4pBZWaAlU7D/bQ65cKMBuunX4kKeu+2qYWhKRhdCJ/FhVyoyVav5r2mZ9X9Gq
4Dq0qOpw9+lkm+S9N0SPkW8jyLnAjnQnopCbD/5ihNmGw873Qond+8DiS/F356U9
cYOzXtpumKy4STnfEnX6HKFj3y4pING9+6sRxv8szdOZJC6NT0t0BFaNQyIJEjvy
wdAgl7Za47h6UXMokqNVR5wFbzXQch1D0aADSEocrqHioDiu0CpGIvn8mK3R5ieK
S8qN30ot9GI7G/2cXiGPYwE3Jl1mZJdBGUcs1n6V5FX2chYU1xrjtdcn4FgSBOQw
DehbUOlwZ+xX1uYGjiaBTmkpjyUV9FTVTHgRgAm3doGgdX5RuQLmUR2GhJwWYGPT
4WVgl0JngMOp4jzxgbU+
=V11i
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
