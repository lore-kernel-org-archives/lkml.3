Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbaCJRMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:12:44 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47971 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344AbaCJRMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:12:38 -0400
Date: Mon, 10 Mar 2014 17:12:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: Lee Jones <lee.jones@linaro.org>, patches@opensource.wolfsonmicro.com,
        Samuel Ortiz <sameo@linux.intel.com>, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140310171228.GR28112@sirena.org.uk>
References: <1394468977-23149-1-git-send-email-broonie@kernel.org>
 <20140310163811.GA16697@lee--X1>
 <20140310164904.GO28112@sirena.org.uk>
 <20140310170524.GN8570@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XkoPKth3RhjOwNXF"
Content-Disposition: inline
In-Reply-To: <20140310170524.GN8570@opensource.wolfsonmicro.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] mfd: wm5102: Mark register 0x19 readable
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XkoPKth3RhjOwNXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 10, 2014 at 05:05:24PM +0000, Charles Keepax wrote:
> On Mon, Mar 10, 2014 at 04:49:04PM +0000, Mark Brown wrote:

> > It'd be nice but you'd need to ask the Wolfson guys to tell us what it's
> > called, all the information I have is the read in the driver source.
> > Meanwile we've got a bug.

> WRITE_SEQUENCER_CTRL_3, seems we should add that in since it is
> required for that 5102 boot stuff. Slightly confused as to how
> that ever worked without the register being readable, but guess
> it has been a while since I have fired up 5102 on mainline.

It just prints an error message, it doesn't actually care if the read
failed and will fall through to polling for boot completion.

--XkoPKth3RhjOwNXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHfJ5AAoJELSic+t+oim9M00QAISYzWg7Cp5RKeawhe44FZcv
82a5ySLFwJ5aloEAw9s4p+/bwyN+H8VBW9UBJfQ9wflDLHGjFwPH3X14akwe2b02
pO2D3vx/XdpbFowJyagwcRliugk6bOgQfbt190hJuWVHpjygppWVAsqqY5+LzJ7L
7qSBO1dNRBvyLd868cNXZL8j73eOwxGRgsTG2DJI2K52fOBk1JZ6SGb4sf2jbjIT
aErKkLFSETjMirCvCZ8mjMPMgD7LjTrf6kBjjHNS43p0JKwirFK9rlK4vuvUDhXr
HiZoNjF6d2VYuuF+M/wgBPZOqixntUnuvtDUh2auI4Sp+RtBfQ/rJ9nfLRFeKD4e
GFaGIbxvqXPfR4Pm1o6Py/d69Gn6wl4MFENLhwTWMdOMALkKFVwniJ7m9wLI8RlP
84BrROdqR20FVUjRj1LGmDjvQAY5AuEauAGsXsnHOq8abY5YG2wVf/JpGWDB/9xI
YCDzH68SOzEHdu+Dp6FSIN6CNwQqxCPvbCCI2usselI/NuyNuf5J2joOkzHgjzyR
ghHB2+TZZ/fD2uueKYvS/EBDHr4hDl2QtfVw3lycA1VGp4z0N2k7tm1Zz/LWFWMX
mutkBcHL7XdlW5FQz9akfvha0PFZxJ/COH2CrrXS4oJ/87AQpjvelqMBwqtnI5UH
OEBCZUtlcPmgWq/5Xj/m
=m0/E
-----END PGP SIGNATURE-----

--XkoPKth3RhjOwNXF--
