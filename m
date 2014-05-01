Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbaEAQka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 12:40:30 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54057 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaEAQk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 12:40:28 -0400
Date: Thu, 1 May 2014 09:40:03 -0700
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Tushar Behera <tushar.behera@linaro.org>, alsa-devel@alsa-project.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        sbkim73@samsung.com, Randy Dunlap <rdunlap@infradead.org>,
        Mike Turquette <mturquette@linaro.org>
Message-ID: <20140501164003.GC3245@sirena.org.uk>
References: <1398243705-31151-1-git-send-email-tushar.behera@linaro.org>
 <20140424133920.GA12304@sirena.org.uk>
 <5359E18B.60600@linaro.org>
 <20140429222915.GU15125@sirena.org.uk>
 <5360E5E7.8090807@linaro.org>
 <20140430180314.GA3245@sirena.org.uk>
 <53623004.5010805@linaro.org>
 <20140501141510.GW3245@sirena.org.uk>
 <CAD=FV=Wa4CovkxBng0SkUUAryiFqa=m63tro1Yv1jRgp4e95aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mZSo2Zk6iB5ZAp9g"
Content-Disposition: inline
In-Reply-To: <CAD=FV=Wa4CovkxBng0SkUUAryiFqa=m63tro1Yv1jRgp4e95aw@mail.gmail.com>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 12.104.145.3
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2] ASoC: SAMSUNG: Add sound card driver for Snow board
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mZSo2Zk6iB5ZAp9g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 01, 2014 at 08:54:14AM -0700, Doug Anderson wrote:

> This is exactly the thing (expected clock parenting) we agreed could
> be put in the device tree I think.  ...but I don't know that anyone
> proposed exactly how that would work.

There's patches been posted by (IIRC) Sylvester Nawrocki for this which
I think Mike was basically happy with - I don't immediately see them in
-next though, but I may be looking in the wrong place.

--mZSo2Zk6iB5ZAp9g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYnjgAAoJELSic+t+oim9lBIQAJQUra6tu0BGp+zrd8wIkiY7
0JgXRUwJq0QOrRupH/K4PxH/RULBBklp4gWH4oLQoawfXVbSExKSWgQLNV0/HY7C
p0oVpo18BswlaoubtacrBBaVbckxw8mz7QDIpZQWbfp+FjItbjL20yW882+IsrwR
jll0rO6o8JtJExJqJF6Gi+VjNaXJ9qDOIDxdaS8U4BPcHW5lSCsG4HclY9JcBBLB
L1pIdZYzZhKEaXUnu2Y0f2fvOOrODXGUBlYxbOG34w3X5oQ2MqfirU5rtymRGAe6
e/Kyp2IE39myv/z9T8XhR/mJtl+L+MKL36NFb42N8/z2cTGIePYM7ZwVgLjq9s92
Uz6CsAm3Xb93QsRBRnRDTtuVCxySHpXfL9fTTLllx2YUfgyRTcbL+WrSm8LO7y6D
JGQ1Rz4nRP3tH5grdGjWvsXTsZMXkPJJcfoAYhz5y4/iA0g8uaUTovd24Zf/u4aW
NFa5EgrvSnWbPBzdBwGzNVSBjoC/evWwkWZCNiHty9MdixQjzGbw1Di+UGTDzthQ
AlrSGXONcpAYPl4FhFs6kACvcT3/b2VBgH+tp7joJEOWq4ljPixdeeDfSNWsL095
Hu/1q0M37an/yWuhBgApiq8GG+24+WH4BKbbxSExLkCKWMYbSe6uB/JCs43rpJyb
nXdVVK770BWoTnap9xRy
=w8r/
-----END PGP SIGNATURE-----

--mZSo2Zk6iB5ZAp9g--
