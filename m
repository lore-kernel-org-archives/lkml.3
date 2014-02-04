Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbaBDRAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 12:00:13 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35268 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbaBDRAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 12:00:09 -0500
Date: Tue, 4 Feb 2014 16:59:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Matt Porter <mporter@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, Wolfram Sang <wsa@the-dreams.de>,
        Tim Kryger <tim.kryger@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux I2C List <linux-i2c@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20140204165906.GC22609@sirena.org.uk>
References: <1391516352-32359-1-git-send-email-mporter@linaro.org>
 <1391516352-32359-4-git-send-email-mporter@linaro.org>
 <20140204132951.GE13529@lee--X1>
 <20140204143119.GA4627@beef>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XOm/PSfQoTjkIR/P"
Content-Disposition: inline
In-Reply-To: <20140204143119.GA4627@beef>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/6] mfd: add bcm59056 pmu driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XOm/PSfQoTjkIR/P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 04, 2014 at 09:31:19AM -0500, Matt Porter wrote:
> On Tue, Feb 04, 2014 at 01:29:51PM +0000, Lee Jones wrote:

> > > +static struct i2c_driver bcm59056_i2c_driver = {
> > > +	.driver = {
> > > +		   .name = "bcm59056",
> > > +		   .owner = THIS_MODULE,
> > > +		   .of_match_table = of_match_ptr(bcm59056_of_match),

> > No need to use of_match_ptr() here.

> Will remove.

What using of_match_ptr() should do is allow the compiler to figure out
that the table isn't used when DT is disabled and discard it without
ifdefs.  Not sure if that actually works yet but that's the idea.

--XOm/PSfQoTjkIR/P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8RxWAAoJELSic+t+oim94AgQAJv8M2BLpfEouIDGeCFeqsXl
TVdBev9aPbChqd+9ujjyPjmSfmLMrVGCNtiIoHv1TnGOSzrdm1Ffj8kQM9d/dgP9
RLxC16kcL/HtjTtLy5BAmGoqItnu/kN+6hpQ4b7xYRvRzIFxDvHo+RSo+NsbAC6S
e11FnZVuA/wzYGTbM9dLfTaeWbkfqKenvoTH3TDJXBzvdBaOMwvnSwLVroq2zrMv
o0lDqaIU4liyO2Tx7KtxLIkrtpJ6TJI6YwIwq987fEGw91AnjVty+k3canRtdYSG
Q70iSCyWcW8E9f0XOznnHFF7Bu7+vwdAI1Ta7yFVlQklfYszbs7RPLnBeWMTXlwt
p/HiAuJz7UWvPH4T8vo1U2NX0+1+72JAf58KK6d2FNa+6/2/JLM9avCXv88duEgG
/g4LZNxv82IBR/vcR1i7tJACuFlEcLZLSJcd8SqWY+cPQ5/jQfKYDM1LN9zJJmPO
FtLDxKe4qlE5AkIB8D0KNSHoTJqgm29UnWrV+awgfqunUXLChwFVUMDsn4VfWI0y
KRUJkmZkPdapDgTZoiG9IPeNegteXJMF18YYNUNBww6QzVXzOUV9UMO7M162vuYn
7uLYaYScdh5TgRpNBn8h+jb18RnBLv17lSwm/TsobBDMOznpaBCWFRRe//9fu3rT
18LVdyQdcCkV+NByZ1Fk
=z1QW
-----END PGP SIGNATURE-----

--XOm/PSfQoTjkIR/P--
