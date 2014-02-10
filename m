Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbaBJMvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 07:51:47 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39967 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbaBJMvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 07:51:45 -0500
Date: Mon, 10 Feb 2014 12:51:13 +0000
From: Mark Brown <broonie@kernel.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Message-ID: <20140210125113.GZ1757@sirena.org.uk>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
 <1391529538-21685-8-git-send-email-ulf.hansson@linaro.org>
 <20140204191609.GU22609@sirena.org.uk>
 <CAPDyKFqNdw-6R12cUOre8UOTOnB-PpxHD5rPAMCwuS3i--Sesg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+mQruWSI2c46YBtV"
Content-Disposition: inline
In-Reply-To: <CAPDyKFqNdw-6R12cUOre8UOTOnB-PpxHD5rPAMCwuS3i--Sesg@mail.gmail.com>
X-Cookie: Colors may fade.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 07/17] spi: pl022: Don't ignore power domain and amba bus
 at system suspend
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+mQruWSI2c46YBtV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 10, 2014 at 01:33:50PM +0100, Ulf Hansson wrote:
> On 4 February 2014 20:16, Mark Brown <broonie@kernel.org> wrote:

> > This seems like a fairly hideous thing to be having to open code in an
> > individual driver, it all looks generic and like something that most if

...

> > Putting it in a helper would at least mean that it's easier for the
> > mechanics to be transferred to the core proper later on.

> I agree, a helper function would be nice. I have earlier sent a patch
> to the PM core, that is similar to the code above, though it was
> rejected in it's current form. Let me follow up on this again.

> At this point, would a way forward be to still go ahead with this
> patch and then convert to, when/if, the helper function from the PM
> core becomes available?

It's definitely *a* way forward, but I'm not convinced it's a good way
forward.  Since it's something that I'd expect us to be doing in all
drivers we'd want to replicate it all over the place which is obviously
not good, or conversely if there are issues that prevented the code
being added to the PM core then presumably we're just adding problematic
code to the driver (you've not mentioned what the problems were with
doing this in the PM core).

--+mQruWSI2c46YBtV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+Ms9AAoJELSic+t+oim9vVcP/iddVl/HH7sK3ZbvHoVRZLuQ
o8Z3SPc3B/MkiWNzw9JDDNrXh4UC1n50ywadFLBts3eCd4xu4oh1fww4O6zi3w8Q
EyEdBMLhi+jt0XyELq5iXVjZJQhyVhT5/jsZSmXKuAVAE1wJWOaGHQ4TcOl0twaI
KGFhovubhQUSpUYuuui1E6n5/70lUngQyunS4zNEdzzAp/lp336/K258umpPllJG
tl0FyxZpj+/NNBNuac9xCkcyRlE/nKhfRD3SGFBiXZf4C9tp4WgOrQO+CdRmWdfQ
d5AGgRJdO6oOiMW7HEsWdvT1a5sVC8yP3tRUbDMYXuJZbjArY7IYFiZfKyJcMG3v
z1B1tLanG6XrTHKNKnkwUETp/8poipFXx2m/lTFqI3MXt5jr4DXbPcbQ+fdWpgYE
+l1P0JlVa559TXLytp8Q92st/q7JtvAappjOQdojgeORK8AbhkWsTS9YSjaUn4Ma
k1xCrH2IUdy4hV5usRo/ecxNEmrNruNou75fyxByhAhr48GKxd13QyeomJcOwBJx
y62CUIHC8zZWo5Qzm/hip55OqPVBtw8W/nzd/jFqE1Y8jNg/CJsiidWgh2cPP9qk
3pWwXP0+NqVLaAluYH+C04eeuScrCxmJR5pYYP1I+pTfZ93qF+mtvifyXWfewRaI
NI5qUJ0lQKC976EI7GbM
=coWM
-----END PGP SIGNATURE-----

--+mQruWSI2c46YBtV--
