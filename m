Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbaHMI5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:57:35 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:57703 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaHMI5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:57:32 -0400
Date: Wed, 13 Aug 2014 10:57:29 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 0/3] Thermal reset support in PMC
Message-ID: <20140813085728.GF7735@ulmo>
References: <1407226380-747-1-git-send-email-mperttunen@nvidia.com>
 <20140813080744.GD7735@ulmo>
 <53EB1DF5.301@nvidia.com>
 <53EB250D.5070207@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="27ZtN5FSuKKSZcBU"
Content-Disposition: inline
In-Reply-To: <53EB250D.5070207@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--27ZtN5FSuKKSZcBU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 11:42:53AM +0300, Mikko Perttunen wrote:
>=20
>=20
> On 13/08/14 11:12, Mikko Perttunen wrote:
> >On 13/08/14 11:07, Thierry Reding wrote:
> >>* PGP Signed by an unknown key
> >>
> >>On Tue, Aug 05, 2014 at 11:12:57AM +0300, Mikko Perttunen wrote:
> >>>Hi,
> >>>
> >>>this series adds support for hardware-triggered thermal reset to the P=
MC
> >>>driver. Namely, it adds device tree properties for specifying the I2C
> >>>command to be sent when thermtrip is triggered. It is to be noted
> >>>that thermtrip won't be ever triggered without a soctherm driver to
> >>>calibrate the sensors, but I'll follow up with that patch.
> >>>
> >>>pmc.c required some juggling around to make the match data usable in
> >>>probe, since I didn't want to put the code into the initcall either, s=
ince
> >>>the soctherm driver won't be initialized by that point anyway.
> >>>
> >>>Series tested on Jetson-TK1. Should work on Tegra30 and Tegra114 too.
> >>
> >>Can you describe the procedure used to test this? We currently have a
> >>bunch of features in Tegra that some people have tested at some point
> >>during development but the test procedures never got documented. That
> >>means whenever we want to test something we need to go and reinvent a
> >>bunch of tests after the fact.
> >>
> >>So what I'd like to start doing is collect tests (preferably in some
> >>scripted way) so that they can be kept in a repository that people can
> >>easily clone and run on devices.
> >>
> >>Could you provide something like that for thermtrip?
> >
> >Sure. I'll see if I can make a just a test script or if a local patch is
> >needed to test. Btw, I also have a pretty nice test script for EMC
> >ready, and I agree that such a repository would be very nice.
>=20
> Here is a test program. It it works, the device with immediately shut dow=
n.
>=20
> https://gist.github.com/cyndis/66126c9c176b5f94a76f

Is there a way to set the trip temperature without going through
/dev/mem? I'd expect the device to have a sysfs interface of some
sort.

Thierry

--27ZtN5FSuKKSZcBU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT6yh4AAoJEN0jrNd/PrOhPy0QAIZoTCfTGGbdc/8u8eRIX6h9
Ow9DihnbKM/x/PVZlNt2lg78LP3abY8tELRtRLnWAt78TKrH/UGbsUL9VDZ88/bm
FCitUu7tP1hubFKGlQT6xIQbV2pfC0S9yjqCwDgaYG9wNjfvvrKMpb4nnH9bbe9b
e1xs20YsAd0jBq6oM/eFbP9Q6n2nidoBqKBNKAJFsr0NfImvcjXsxTv45WJLil7z
6S9H7Ix7jn7gg1s3FR9jONqE1jUm9v/VnifhMkCrImPzAa2R0dcrC0d4KcBReMKO
l4aVz+582gaeoB/AFXj+u6ZJKoWmNP9W5i2m+JwHMYD6LzRLNcCp6po4pGa73mnV
ywCeqCs2neiDxUFKOkZSEbOCTSLb9wgSC7poZGDGhKTXRyGYceN5oQ6BcBYs0P7t
DM2k9u7joaClRoSABnXe9s/PKWReeECZ2HQkYPNJV2CyjXcLE+qEjck6h2pUxEx9
G9ylJXtRs6LlRReqHc123+Sup82opm+H/ThiImedbmP1ETWBkqOOXgQ3704CF7ck
lXLVGnT9hIP8I1gTGW+UpjffvZP9/XYESD9r82J4my7fTc0rLY0iFbZxGUvI0irL
gX6s5nOnvmTQNnKDcRPtyYLashs9jQswI0sZNR9s9rXJT0icRyloqFfGD0N0PPkX
momUHkmbdD6eoFFgMsWm
=EfLR
-----END PGP SIGNATURE-----

--27ZtN5FSuKKSZcBU--
