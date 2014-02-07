Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbaBGSMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 13:12:55 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38417 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbaBGSMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 13:12:52 -0500
Date: Fri, 7 Feb 2014 17:57:08 +0000
From: Mark Brown <broonie@kernel.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Kumar Gala <galak@codeaurora.org>, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-spi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Alok Chauhan <alokc@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Kiran Gunda <kgunda@codeaurora.org>,
        Sagar Dharia <sdharia@codeaurora.org>,
        Andy Gross <agross@codeaurora.org>
Message-ID: <20140207175708.GK1757@sirena.org.uk>
References: <1391705868-20091-1-git-send-email-iivanov@mm-sol.com>
 <1391705868-20091-3-git-send-email-iivanov@mm-sol.com>
 <20140207073952.GA2610@qualcomm.com>
 <20140207165127.GV20228@joshc.qualcomm.com>
 <20140207171834.GF1757@sirena.org.uk>
 <20140207172051.GW20228@joshc.qualcomm.com>
 <20140207173108.GH1757@sirena.org.uk>
 <20140207174643.GX20228@joshc.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VJJoKLVEFXdmHQwR"
Content-Disposition: inline
In-Reply-To: <20140207174643.GX20228@joshc.qualcomm.com>
X-Cookie: Colors may fade.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] spi: Add Qualcomm QUP SPI controller support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VJJoKLVEFXdmHQwR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 07, 2014 at 11:46:43AM -0600, Josh Cartwright wrote:
> On Fri, Feb 07, 2014 at 05:31:08PM +0000, Mark Brown wrote:

> > That's not ARM only and I thought we were getting generic versions of it
> > anyway?  ARMv8, MIPS, Microblaze, Hexagon and SH also define it.

> Okay, that's fair.  I'm only vaguely familiar with the generic _relaxed
> variants, but until they land, how do we appropriately declare the
> dependency to prevent breaking COMPILE_TEST builds on architectures that
> don't have them?  Or should we either bother?

> Do we need to introduce a HAVE_RELAXED_IO_ACCESSORS selected by those
> architectures with support?

I think that or just getting generic versions done would be the way
forwards.  Right now it's a bit of a shambles.

--VJJoKLVEFXdmHQwR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS9R5wAAoJELSic+t+oim9Hy4P+gKNAZOVgTiqUkpUzJAW36n1
0s/00KzbZPD5/Tq1buJgjgSQhSCq3wPnLFAJyMVu6Us3lhcto7Dem+qrBvBRgfJf
V7pYNlFDAEkYWfAaXupmyEl+4EKCqJhkIvm4lyWsik5zELnLSFVXadT+6AqYWg1v
zdqDNB1DFXfmk/qFxO9ozcP1i22ywDA35shVtmHJ4HLO7c8P+9T7y6YMJ8CLVusK
KTrbNBzO7x9bOC33CfZMP9KloEt4LjCJf+m7sZx04CZcw87Abya7m7L4kwbt1HZc
RKjFF2VkdRitCubOq8tdINsCzaRNZzINXIA3sIQXUPJcaK+qfzNeJfofhQquPEXS
jrMqt85X9769XNaI9lbTv92mwbnSE/0YJrVAgo//ynBCY69NqJl4mSbqQB7Ky/7E
pLVaAn4A6Ig+Rrcdbee6389t46+F0ugfzILN4cap49lyGIIrhshlQiu7HgjpoPkD
M1hbHXXD9StFabjj2YgkrcbsmxfQibsu27S4sSdQDQGMw26FfdoELLKyuueMKKqQ
XAgebKNElfxh2ZP4LupvfCoSwmbji/jtXFCet4wl5vY1xO366isZF4alatzKgTtW
+Gm1XPyxdBDO+ny+RjwAnaJt53m8dRqQD6Sq1/5WMWbc4CkmZpD6MrZykaDqRQVM
+y0xkxNC4353rPhMMBq/
=Fyb+
-----END PGP SIGNATURE-----

--VJJoKLVEFXdmHQwR--
