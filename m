Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652AbaD2W3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 18:29:37 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51053 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637AbaD2W3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 18:29:34 -0400
Date: Tue, 29 Apr 2014 15:29:15 -0700
From: Mark Brown <broonie@kernel.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: alsa-devel@alsa-project.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, lgirdwood@gmail.com, robh+dt@kernel.org,
        sbkim73@samsung.com, rdunlap@infradead.org, dianders@chromium.org
Message-ID: <20140429222915.GU15125@sirena.org.uk>
References: <1398243705-31151-1-git-send-email-tushar.behera@linaro.org>
 <20140424133920.GA12304@sirena.org.uk>
 <5359E18B.60600@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dXvu6+ixFx2ZffE8"
Content-Disposition: inline
In-Reply-To: <5359E18B.60600@linaro.org>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 12.104.145.3
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2] ASoC: SAMSUNG: Add sound card driver for Snow board
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dXvu6+ixFx2ZffE8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 25, 2014 at 09:46:11AM +0530, Tushar Behera wrote:
> On 04/24/2014 07:09 PM, Mark Brown wrote:

> > defined.  Why is that?  Also, why is the secondary I2S playback stream
> > not supported (this may be a reason to restrict to only the one I2S
> > interface)?

> AFAICS, I2S driver doesn't support secondary DAI with DT (dai type is
> always TYPE_PRI in case of DT). Hence I could not find a setup to test
> secondary dai with this board.

OK, that should be fixed at some point.  I will hopefully be able to
look at this myself on the Arndale Octa though (or Chromebook or Arndale
once XCLKOUT is implemented).

--dXvu6+ixFx2ZffE8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYCe3AAoJELSic+t+oim9/nwP/1MmemJBQprVgaUGU/1sJ5V0
xffa7Isk0NJTlgsP2doO1yjfuYUu4mCnkgxw/NR6AKVLgTJsu3PPC8tghdf7rTLQ
FQiUOAqhPkjot2DGRXf+2H5TpVKFP/cRWFoBEe4Lvz+XKRYTOBg39OkfLadw4i8T
w33BMwTCqOBsaUgs363z/ZLWcEXPMKGmxecI20Fepb4GUP2bv+/+Vj8uwZxPcrLE
J/MTlffkc/m+9cWU729kKHIklrcrwcpez5CiUN9/KSN9TwfAHyP07cuvhfs1A1Ep
33dPJwijghJeK4fXZ4mFxwzXQ+wINazC3njLRCnYGCD3M7RnpQiRX68ImuNCh4z0
oYE4R4U2BCzC2EQOb45AJgkhEbaZYy5mmoZygADKy29Ext7CIs+HYsRlht74MznX
OnBDmdBiAXRSyYqpnhBjL48zLjI85E9/tc2SmdKHDF+OBs96u9Fy+i519gyzwRwb
zVvq9fsrjbnQP3cxovUKwiH02/5D0xQGacON4C5xJdzbDez5gaYcAMhwbAygiYDD
x9cIpO4qXnlkLS7DBtAbEAuQww/cKQv+FBsSoF1TOyA2JFPw46AI+ANVtXeR5tPb
GwZ4PuIsQtARAbOnd2mqwCxTFkJ46K6jl7Vh1UuDk/ZvjJgf4Wvh7EKZ/Lp3+1r6
4AB+gPNuYWxk/8xMAy4m
=zPmG
-----END PGP SIGNATURE-----

--dXvu6+ixFx2ZffE8--
