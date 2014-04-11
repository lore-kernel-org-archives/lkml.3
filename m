Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbaDKJsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 05:48:05 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48546 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530AbaDKJsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 05:48:01 -0400
Date: Fri, 11 Apr 2014 10:47:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Harini Katakam <harinikatakamlinux@gmail.com>
Cc: linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        michals@xilinx.com
Message-ID: <20140411094748.GM6518@sirena.org.uk>
References: <1397134229-2380-1-git-send-email-harinik@xilinx.com>
 <20140410173616.GC6518@sirena.org.uk>
 <CAFcVECL-G_JPZXmzBLT_cFo3vmjYZd8xGFf-7Vv2uXWa9-O37Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VSJGZE3ajDCqFLUt"
Content-Disposition: inline
In-Reply-To: <CAFcVECL-G_JPZXmzBLT_cFo3vmjYZd8xGFf-7Vv2uXWa9-O37Q@mail.gmail.com>
X-Cookie: This report is filled with omissions.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: core: Increase timeout value
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VSJGZE3ajDCqFLUt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 11, 2014 at 08:39:54AM +0530, Harini Katakam wrote:
> On Thu, Apr 10, 2014 at 11:06 PM, Mark Brown <broonie@kernel.org> wrote:

> > Ideally we'd use the actual speed the device set rather than the
> > requested one too, that'd help.

> How would you propose to do that - driver should write back actual speed set
> to xfer->speed_hz?

I'm thinking something more like having a variable in the driver struct
for the current speed (like you do in your own and some others do).

--VSJGZE3ajDCqFLUt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTR7pBAAoJELSic+t+oim966EP/jJxwVQ47imosEXNSHm3d1NH
gmG/sfGFNU6rmL9TCFbqGQh8R/J7wPuBLtW1xj7vOPvdtppBcVph+CvTSESaBpEq
v3J+5s3TEMEHATLC2fZucrJLjiwxeONxiYIZV43F2v/XIwlo8/YQ/dzYeklGdOIr
rpJZ2LTxgqsPU+ZQhJijCFjcFJjtKwxkXIBQ8Inkc2lXpdo+HIYThkDAD2G3lDlA
pljnrbj6PDbYcal+vNYtUHjTCXIv8BKvK3pUHrqjSLmToXXRJAU/wwc62u9VMMAm
ZPgS4qhs3nFXWaiVvLCsKFCsr6bDqMl3tcMJkCEQDQQLQNH1HOa4T55Qut1PYrK3
v9AzHVCc8bjKInWOCWnRAQDhzqrVmQGMTbHUYKKDUt405BlGFKo4nMKPoMd6Zc+J
HSygwb/YDVWATq1AELvtzpHQiroD+pOaIyesPPM2hn4DbLqt4eL7T9AWBuxE64Ud
6ajiOwMK2SPjhZGPh+D+y2UbQJnMTi7VF8HijUt6etWjIhku2wXx5SpV2WzhpEbU
e/k3tAXQMdKNZFfs1AKNndfap2pMepZqEGcKSzmTS3nd89siu1uP4AIYFDts0CdI
l4LXOm1mYdgFGdwDhxGf69IIa52eeXCYKW6RZK0a7w57uj6BpQDmqOrczKs+KWbI
qOKNrR2Rdkn1ojoaacXp
=AzHw
-----END PGP SIGNATURE-----

--VSJGZE3ajDCqFLUt--
