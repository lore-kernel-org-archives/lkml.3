Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaDDOpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:45:16 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51291 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbaDDOpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:45:13 -0400
Date: Fri, 4 Apr 2014 15:42:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Harini Katakam <harinikatakamlinux@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Message-ID: <20140404144244.GV14763@sirena.org.uk>
References: <1396523431-14519-1-git-send-email-harinik@xilinx.com>
 <1396523431-14519-2-git-send-email-harinik@xilinx.com>
 <20140403213446.GB14763@sirena.org.uk>
 <CAFcVEC+mpHh_d2j6_sdhWS3d2KyXrDYUq6L6jO2Q=SS68Hda2g@mail.gmail.com>
 <20140404100919.GO14763@sirena.org.uk>
 <CAFcVECLDyfFSZFk9fzFKsr6pM=f1nwzGAhjX17z=NsbvWpiDew@mail.gmail.com>
 <20140404124637.GT14763@sirena.org.uk>
 <CAFcVEC+FAAxxxxA8PgcTzLU5UFu=pkDEM4Li06dRmEwA95sz_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dtsE+6jMZxJpedRo"
Content-Disposition: inline
In-Reply-To: <CAFcVEC+FAAxxxxA8PgcTzLU5UFu=pkDEM4Li06dRmEwA95sz_g@mail.gmail.com>
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


--dtsE+6jMZxJpedRo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 04, 2014 at 07:38:14PM +0530, Harini Katakam wrote:

> OK. I understand.
> Can you comment on the case where a decoder is used?

> There is support for adding a decoder where extended slaves can be selected
> through the IP's control register.
> (This is not currently implemented in the driver but will be in the future.)

> How should the driver know whether it is 4 or 16 select lines for example?
> This has to be written to master->num_chipselect.

That's the sort of case where it's useful yes - depending on how the
implementation is done it may be sensible to just have a property
specifying if a decoder is there (if it just changes the encoding in the
register for example).

--dtsE+6jMZxJpedRo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTPsThAAoJELSic+t+oim9RxAP/R+P3uXit2uGGj9y6epVIFGy
KKUyK68OB2vWV9GOmWP+8NatKin/akQGahfzZwgRG8uq6u4j1SXh7zpXmWSPDY6u
/Bb28xEIKqUrIe+WDagnM7I6w1CB7N2RGOG6cQLhbYC4OCQZD/dQ/yAd0Mtr8Itw
LQU/z+f9PGlBQ/4X12ohsQn+xThsoO3pM43ylrYaXQOX8J2JvhvAqA6Sg9PmaUaS
IXgPPUq4ySg/wV1eRGsiR4rPy5PtWvFgvuN/2RcWMc13Suld+5SSrKgEFp2LtB3y
qH6lZhWCgdXqUGwz9+n5svbyuP1opTGMbx9EWUw4gP2w82+MEwm0P/Le+9Tj0we6
yBBiVIWOxs0u7nz6Mh7ayrV3OrXed0wKH6zFL0TSeS6nspt4SPWR4h06mqy5MzHz
FbtB1aEXpmX8NfSrGSCRFkzV0hZPdaasTT6ZJQoCTCCJnUhytcY2/sphDjY1Wa5h
f/IdZE8J4eglTSfY61u1SL4zQA8JUGfqbZB8ozqwsirOUaVvkWvsNVDhO2lIqFm7
SYLwuyPfaw+zXwRBaxROO5r261BmoiQNHvQh2+1n+aO5FHlnMbIFQ8NpQjC5CRmQ
A64n7vnAPwrNB//yV4QUyahCjVey0oKzFVGcgb62xvlDPGp1ff0ifMckLt4NFTE3
rtikGpIgJ7B89NAduJaA
=aOmE
-----END PGP SIGNATURE-----

--dtsE+6jMZxJpedRo--
