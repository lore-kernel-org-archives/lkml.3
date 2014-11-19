Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbaKSRrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 12:47:41 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54401 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772AbaKSRrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 12:47:39 -0500
Date: Wed, 19 Nov 2014 17:47:09 +0000
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Simon Glass <sjg@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20141119174709.GF22111@sirena.org.uk>
References: <1416246184-29071-1-git-send-email-javier.martinez@collabora.co.uk>
 <1416246184-29071-2-git-send-email-javier.martinez@collabora.co.uk>
 <CAD=FV=Xkei_wxa3jWb8bPvuynbSyq4o=ezjVD0+e04aOPCAM+Q@mail.gmail.com>
 <546C6BD2.4020802@collabora.co.uk>
 <CAD=FV=XpweHvcTsVTMBkv9g4+GxoO8WdngGhfVj0QnOwq3ASdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K/+MhuhYzqQJJ3Xj"
Content-Disposition: inline
In-Reply-To: <CAD=FV=XpweHvcTsVTMBkv9g4+GxoO8WdngGhfVj0QnOwq3ASdQ@mail.gmail.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 81.128.185.34
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] ARM: dts: Add SPI flash node for Peach boards
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K/+MhuhYzqQJJ3Xj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 19, 2014 at 09:19:13AM -0800, Doug Anderson wrote:

Please stop CCing my work address for upstream things.

> On Wed, Nov 19, 2014 at 2:07 AM, Javier Martinez Canillas

> > I see, I thought that it was a common practice in the mainline kernel
> > too since I saw that many board DTS currently have a spidev node:

> > $ git grep 'compatible = "spidev"' arch/arm/boot/dts/ | wc -l
> > 19

These are bugs.  The device tree should describe the hardware, spidev is
a Linux implementation detail.  Provide a compatible string for the
device that is there just as you would for any other device.

> OK.  Please don't take my comments as a NAK on this patch.  I should
> have done the same grep myself before sending--sorry.  I just
> remembered the old conversation and looked for that instead.

Please take this as one.

--K/+MhuhYzqQJJ3Xj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUbNeYAAoJECTWi3JdVIfQo4EH/RcaunwCOce7Jj1PrrMI8VnO
VUJP08dSxzrNLrr158YGR4H2/Sc/P37f5X3e5I57cy7LXDRFV+rQMOCMiccWQ/b8
PyR9o6NBqIspwY2WHCE39EuExK5DYD8OD6lYzq4IXI5/g4UXHV+cvqAeIsVNqT3v
9SC0EvVaNxWyh9tJ5iIHi43myNfKnM3m5y/uyywuCJiKDfLsZgpkHSBqxynSvPae
YhT1fcNCIjV90oGWNTQjXjVQ8CgITaV9RHIw4JoG0Y89Sxs+lbdkJP51aCNpMBr+
PregHOYkJu4CYCd84S12EHp0uXRuEJpwr+480FTYlEb8ew6aGFQvImdp3hRwbDA=
=rTzA
-----END PGP SIGNATURE-----

--K/+MhuhYzqQJJ3Xj--
