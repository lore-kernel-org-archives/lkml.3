Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbaCLNYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 09:24:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51850 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbaCLNYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 09:24:43 -0400
Date: Wed, 12 Mar 2014 13:24:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        linux-spi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20140312132427.GR28112@sirena.org.uk>
References: <1394541891-26469-1-git-send-email-jcmvbkbc@gmail.com>
 <1394541891-26469-2-git-send-email-jcmvbkbc@gmail.com>
 <20140311194959.GB28112@sirena.org.uk>
 <CAMo8BfLTn+pneF6_7XkP66+LzpZgcefnAo_FkwxpvtYdt9yduA@mail.gmail.com>
 <20140312003401.GE28112@sirena.org.uk>
 <CAMo8Bf+dePYf0jW6zaH-4Qiy5oF-bBzHjkfzL1u6pyTS1OE46w@mail.gmail.com>
 <20140312011116.GJ28112@sirena.org.uk>
 <CAMo8BfKFp1kz8S_4JbSh5=f+hMygJL1670fkFfzdArgDqtW72A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vW5M6DBezn0Nx6aF"
Content-Disposition: inline
In-Reply-To: <CAMo8BfKFp1kz8S_4JbSh5=f+hMygJL1670fkFfzdArgDqtW72A@mail.gmail.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] spi: add xtfpga SPI controller driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vW5M6DBezn0Nx6aF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 12, 2014 at 05:48:16AM +0400, Max Filippov wrote:
> On Wed, Mar 12, 2014 at 5:11 AM, Mark Brown <broonie@kernel.org> wrote:

> > So I just looked again - the SPI code isn't in mainline, there must
> > be some out of tree patches here that can't have been tested since the
> > driver was converted to regmap (or the byte swapping you're doing in the
> > controller is buggy for 16 bits per word).

> I'm successfully running this driver with the patches in your ASoC tree
> branch topic/tlv320aic23.

Ah, I missed that during review - the driver shouldn't be forcing 16
bits per word, any swapping that's needed should be being done in the
regmap API.  Though based on the discussion of the SPI driver it seems
like this may be compensating for an unwanted byte swap there.

--vW5M6DBezn0Nx6aF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTIGAIAAoJELSic+t+oim99GIP/11mpaJ2nb6NDiMPuuMr3imb
mDmfRFPkQC0gaYL2DZ8icCBdcGJLTdBcTnUH9WxLvMz+x925DzcInZYdsqvOSVBy
vYkEkT6muBaQElia7FoWv/sEyoK/CRL6y+a6xevV+vCufPfLYJInKBwQE7tslZJM
2Vcw8dCuhV/39mdLmBub9Vc+6Iv8yTcLkOvvIK+cnI7Mb+VpyBA7pc9i0eeVo0vq
GX8eBNOceKF+WUDjk8WGu6oyXzGX+FWfuMPEDpbtpLdR3MEo9xgo3C+5zYCLLXJi
mpuKhAfBJ25vYRh+/Rt92uLquF0eMvgXF5qPZMLqLxUgrhf/Pj8L5iL3G+qUN1or
ck3YMqtkYf0u47UV27apLpuT8g/1Oni2EzRb2mMfVe1iKJj9cb22u7TnscmkTTjf
o+TbyzK2KLUvdMjEG0AqDVN7GH7kMBXRYrQXO8VFNJ+vdoEmB6MtnfIAU5P99GVM
y7HWz3WqE8jipJqZNV9fizf7lO5UKOhKJ/3dGErw9O31jRIyQRlaNZLs6TWShrwx
FLUML0Epc48Yx/R+IsxbgHavDLLLhD5djWmyvLlh9TudP9J4VsdkijkklZEHogfl
JUOu7gY2UmrFjfA6nYYOUXVgzYQPXAsEL4cH/wN3vt9T43kopRcfZ2GAyUlcHypg
+RCkxSxuN2h2wa9taptW
=RQdX
-----END PGP SIGNATURE-----

--vW5M6DBezn0Nx6aF--
