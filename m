Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaDDMrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 08:47:18 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51212 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbaDDMrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 08:47:10 -0400
Date: Fri, 4 Apr 2014 13:46:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Harini Katakam <harinikatakamlinux@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Message-ID: <20140404124637.GT14763@sirena.org.uk>
References: <1396523431-14519-1-git-send-email-harinik@xilinx.com>
 <1396523431-14519-2-git-send-email-harinik@xilinx.com>
 <20140403213446.GB14763@sirena.org.uk>
 <CAFcVEC+mpHh_d2j6_sdhWS3d2KyXrDYUq6L6jO2Q=SS68Hda2g@mail.gmail.com>
 <20140404100919.GO14763@sirena.org.uk>
 <CAFcVECLDyfFSZFk9fzFKsr6pM=f1nwzGAhjX17z=NsbvWpiDew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EOP8HhwRQvhZjZeP"
Content-Disposition: inline
In-Reply-To: <CAFcVECLDyfFSZFk9fzFKsr6pM=f1nwzGAhjX17z=NsbvWpiDew@mail.gmail.com>
X-Cookie: To make an enemy, do someone a favor.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/2] devicetree: Add devicetree bindings documentation
 for Cadence SPI
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EOP8HhwRQvhZjZeP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 04, 2014 at 05:44:23PM +0530, Harini Katakam wrote:
> On Fri, Apr 4, 2014 at 3:39 PM, Mark Brown <broonie@kernel.org> wrote:
> > On Fri, Apr 04, 2014 at 08:30:38AM +0530, Harini Katakam wrote:

> >> This IP can drive 4 slaves.
> >> The CS line to be driven is selected in spi device structure and
> >> that is driven by the software.

> > So why specify this in the binding at all?  If the device always has the
> > same number of chip selects it's redundant.

> I'm sorry, I should have explained that better.
> The IP can support upto 4 chip selects.
> The num-cs value here is the number of chip selects actually used on the board.

Why does that need to be configured?  Surely the presence of slaves is
enough information.

--EOP8HhwRQvhZjZeP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTPqmpAAoJELSic+t+oim9R04QAI7uxIX6rvg8RPCBrtsMu9V4
14kUK42WQppfs05BN0DMCqNRPY/w7Et9k1grbaon7BjdZ0NVTyIuovxpYiPuHDWF
mzElgFWr5FExev8vLpiwac5W5GGc2z2ffmJd1tI4LyYvGMpqxP8xa1Qbj/wcq2pm
/5l63fR2k1UEPvtdzlvuG+Hf8fv7Jnkjbvt69M91dEJtiVixzuwxi9888KN+pSIY
D9UMSd7e/6nmSC3117p50mD6bb6YU/UDqGzS9BelOfZy/wiAswX5fQn3/83TC68u
cmAf7C/mUTuq60zhVyhFdb0PYEQ5COumye2SaKhfHymU+457xDF5ctNIZJjWPWHW
oRkQ3kOSn/mIyycBLfZAFs9bHqd++0exgWzod2ri3Hh1bJ39I9kzazXac9CO0Cwm
J6L1F6fML7+Vbr+s8XOjqtRfn3g/9TEXycQpEvE8d1SJKPHs5rG1uSFJTUl8E8S7
i4rl/QDJqAqJ0yx4OilSoAKisFQ0nrQ2T/9OJu4c2aWvCeOchdsP9ix7/VO959Le
3Jzs+YuGEzgM+ZzHRM9LKseftTAqK/wMo2tjS3FgsMKahlb9koxnnD9EBhxyRzVG
J8EDcN55uxsXOpaXK+vh5vk3Hhw87I/IIyWSjDRaoB6MRkKttO+FVxeHwV4wnEYh
YnC44F3xxQKtjbR97a97
=8/gz
-----END PGP SIGNATURE-----

--EOP8HhwRQvhZjZeP--
