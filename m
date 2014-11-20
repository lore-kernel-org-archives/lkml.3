Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049AbaKTNwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:52:36 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:62584 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854AbaKTNwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:52:34 -0500
Date: Thu, 20 Nov 2014 09:52:32 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Linux PM <linux-pm@vger.kernel.org>,
        Caesar Wang <caesar.wang@rock-chips.com>, Wei Ni <wni@nvidia.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Mikko Perttunen <mikko.perttunen@kapsi.fi>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        lm-sensors@lm-sensors.org, Rob Herring <robh+dt@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCHv4 1/1] thermal: of: improve of-thermal sensor
 registration API
Message-ID: <20141120135155.GB24778@developer>
References: <1416321575-18348-1-git-send-email-edubezval@gmail.com>
 <1416321575-18348-2-git-send-email-edubezval@gmail.com>
 <CAAVeFu+aUdpV_hj50TAZDO_5JgRmPH2RtJuP7Qozx4RNEzO-6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="c3bfwLpm8qysLVxt"
Content-Disposition: inline
In-Reply-To: <CAAVeFu+aUdpV_hj50TAZDO_5JgRmPH2RtJuP7Qozx4RNEzO-6A@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--c3bfwLpm8qysLVxt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Alexander,

On Wed, Nov 19, 2014 at 05:06:24PM +0900, Alexandre Courbot wrote:
> On Tue, Nov 18, 2014 at 11:39 PM, Eduardo Valentin <edubezval@gmail.com> =
wrote:
> > Different drivers request API extensions in of-thermal. For this reason,
> > additional callbacks are required to fit the new drivers needs.
> >
> > The current API implementation expects the registering sensor driver
> > to provide a get_temp and get_trend callbacks as function parameters.
> > As the amount of callbacks is growing, this patch changes the existing
> > implementation to use a .ops field to hold all the of thermal callbacks
> > to sensor drivers.
> >
> > This patch also changes the existing of-thermal users to fit the new
> > API design. No functional change is introduced in this patch.
>=20
> A good idea even if no ops were to be added!
>=20
> Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>

Thanks for reviewing.

Eduardo Valentin

--c3bfwLpm8qysLVxt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUbfIeAAoJEMLUO4d9pOJWV48H/0hSblonH5J96HEdJgx5O5y9
NBKK0ulyOQMn5xGoD6cvowht+oF3ViTFDpq0/Uvjg2I5QMMyB8JOGNUPlIS58Eq4
OlMz4VGEh77l6HFosEeeXDiOslb+sLZi79LBfaCp4vkPuifRnT6WUAc+QYSXUjuc
5QyL8aXypQr98Vu6YOlnpLNSC0KjkFJcdTviXY7kO3r78MNm1Htt3VGCoW/X5FR9
jXDZWX/P0bq4Kvu5+j+ADPuZjSkAmEUc6Jm5RPQo0nXtVDHGfLojNYHc2kVIlVH8
bXYJXik+Wt5KpAWivF3lTvj6NIMhis5oWJHhZARLz/uL30UjX2Im+wVD1jSAtcc=
=Kf2R
-----END PGP SIGNATURE-----

--c3bfwLpm8qysLVxt--
