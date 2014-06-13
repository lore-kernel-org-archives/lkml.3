Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbaFMWHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 18:07:38 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40527 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbaFMWHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 18:07:36 -0400
Date: Fri, 13 Jun 2014 23:04:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@google.com>
Cc: Tushar Behera <tushar.b@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Kevin Hilman <khilman@linaro.org>, Tushar Behera <trblinux@gmail.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Message-ID: <20140613220421.GD5099@sirena.org.uk>
References: <1402464739-19044-1-git-send-email-tushar.b@samsung.com>
 <1402464739-19044-4-git-send-email-tushar.b@samsung.com>
 <CAD=FV=XqqP7+xDOAKCixivzgaO0xvJX7L+CCN+unAEuf-6aUbQ@mail.gmail.com>
 <20140613170511.GA20112@sirena.org.uk>
 <CAD=FV=VvkvH1TPiKttm9VXbBRnBo7kmTVK8bZZvexK=bAvaO4Q@mail.gmail.com>
 <CAD=FV=XCk9E-7VPV=LQrdLU5fKsFHviQf79MBmC8va3gsg=Ydw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lZ/I5ubSOvRSGe9j"
Content-Disposition: inline
In-Reply-To: <CAD=FV=XCk9E-7VPV=LQrdLU5fKsFHviQf79MBmC8va3gsg=Ydw@mail.gmail.com>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] ARM: dts: Enable audio support for Peach-pi board
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lZ/I5ubSOvRSGe9j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 13, 2014 at 02:58:26PM -0700, Doug Anderson wrote:

> Anyway, suffice to say that the i2c core needs to be extended to
> handle the idea that a single device has more than one "compatible"
> string.  I'll leave it to an eager reader of this thread to implement
> this since we can also fix our own problem by just listing "max98091"
> in "sound/soc/codecs/max98090.c" like has always been done in the
> past.

Why do you need to register multiple compatible strings (I guess for
fallback purposes?).  A quick fix that is about as good is to take the
first compatible only.

--lZ/I5ubSOvRSGe9j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTm3ViAAoJELSic+t+oim9u4cP+gLyrS+envDYQbCSY/eJAnXp
a9lLZdgtRF9Xy8H+ong5D2qiMGJ0aQv5Xs7o3fxECrYQh0jHbUxoP41AacXzgcsq
kGKOT3jt+nXbG0nFG6IkjasWcL7QzSXvFu9ziU7Fb3hridPMe8UHfLWcTtsL4iLO
GZHn5sF3RGd+6JOSOP5dOi8cTfT4HFAD21aAhchLUTPor4VOEL6PG9LQ7/ykOxjl
MrwHbUXAAeTjsmFOIU5aLyEyUEePL5lgteV8DTaWq0IyLN5DKssdI4/KCbg5+lbc
8rVfvRsARY+hQrxzYSqz5dlTBPSglcIDepLk/Fqad3OtT+0Vufe1WXAwvWrTcC/x
er+2C7qKnFuOHcl0tM5BFSjodChqM84RqkY+lWN2SEKBRXjnpryIpCMKPs4eLpwR
jZoNGZ/umb/LYuzOy59ZUyZVcrk2Y4bbhUv8LHeS7hwmKLkFgeDI15RI8YfrAbCJ
yPV0/RY6gBdT+jZ6NZ2jQWz+zr+GJ4YxmfJio4uMRyIVzsHg80q6fgy3oCtFn94F
z8MkTh+8LhRTQcbYxo4w10JBgVLTq26QKrmWbll/wiKH0pLWHMsJAX9cgnXH2XBA
qSqoO9hbQgEXqUVdADWWsGwSLqk/pjZDI6zh7yTMk56sDCS9xtN25sxqsH/o2c3R
L5DkwPYca0G1ieVtySdY
=YGt1
-----END PGP SIGNATURE-----

--lZ/I5ubSOvRSGe9j--
