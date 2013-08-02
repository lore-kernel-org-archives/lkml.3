Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab3HBMbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 08:31:03 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13401 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab3HBMbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 08:31:01 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 02 Aug 2013 05:31:00 -0700
Date: Fri, 2 Aug 2013 14:30:57 +0200
From: Thierry Reding <treding@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ARM: DTS: tegra: Add USB entries for Tegra30
Message-ID: <20130802123057.GA10282@manwe>
References: <1375369218-11288-1-git-send-email-ttynkkynen@nvidia.com>
 <1375369218-11288-2-git-send-email-ttynkkynen@nvidia.com>
 <51FA8F2E.8080105@wwwdotorg.org>
MIME-Version: 1.0
In-Reply-To: <51FA8F2E.8080105@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 01, 2013 at 06:39:10PM +0200, Stephen Warren wrote:
> On 08/01/2013 09:00 AM, Tuomas Tynkkynen wrote:
> > Add device tree entries for the 3 USB controllers and PHYs and
> > enable the third controller on Cardhu and Beaver boards.
> >=20
> > Fix VBUS regulator entries on Beaver. The GPIO pins were wrong.
> > Also, internal pullups need to be enabled on those pins.
> >=20
> > Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
> > ---
> > v2: Use internal pullups on the VBUS regulator GPIOs.
>=20
> Thanks, this version looks good.
>=20
> Thierry, can you please validate that the gpv group pull strength change
> doesn't have any negative affect on your PCIe patches. Thanks.

PCIe on Beaver seems to behave the same way whether that patch is
applied or not, so:

Tested-by: Thierry Reding <treding@nvidia.com>

I wonder if perhaps a similar change can be made to Cardhu to see if
that helps with the PCIe link disappearing. I'll see if I can find out
what the implications are and what the correct values would be for
Cardhu.

Thierry

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR+6aBAAoJEN0jrNd/PrOh6g0P/ivjQRqyPahZ+7nRc4cwQ+GS
dMWcD1Ua11AaLSSRJbhzG0JJiavdQY7gjU+9CpPeYaakCBCYDTTzpLw+OvphhkKZ
7clFvwrbfFXP/k8OG+uF/CeFawZEfga+xEMSorzCyzquiS4C2WPm9iJPRKx/g4s9
Xfc5qiTJ0gVjn+aS9oo/eSrcUIbEJzVGxnjlXk8WY9YbnV/ni/SBPTBiNhWxj5Y/
JZrzkphMGaxatMqfy53nyVbl+dtrCKGx+WwVOMIC1X5Z7QpOgEvCmwetX88YuW6k
V8z1JOv25hPvVzPjYnR6BFWYkHrbbsSKcnYwohtAX/kF9ZOTUaQXI9jKMT5tL+5c
fBXIQYkak/M4aSORU/TeHjtiSDnFNpx4R/oIMqel51dfcWHrANNnpMMI1Ri5Mkcw
8tTtGQM7CfV1aAL9JhnSpmjAiNz9gN2W4YT+cEu+7TEaCALzr4cj3D0A64is1D0D
4ZrFM/m2AOEKkD418hdXhxXHMxFxiMcgBoyCm2TQY1eGC0k9C6V3/M6EHUvgzHGd
FPc9xqLAQtK4PMiEGfqGvNLldPVXvgBQ3o4/fI7Y6tMD8WkJ4BVKo2j1YQD/tCTB
v+lLvGdwmrIAutc8MfYArotjSes7KvLc+hlkonqmAmJB2h2aIHjfbixIlBnHp23R
XPn+ho5ldtP14xUIrBoE
=1OcS
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
