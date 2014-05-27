Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaE0LUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 07:20:43 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44137 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbaE0LUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 07:20:42 -0400
Date: Tue, 27 May 2014 12:20:24 +0100
From: Mark Brown <broonie@kernel.org>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: lee.jones@linaro.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Message-ID: <20140527112024.GS12304@sirena.org.uk>
References: <1400805629-10322-1-git-send-email-lejun.zhu@linux.intel.com>
 <1400805629-10322-2-git-send-email-lejun.zhu@linux.intel.com>
 <20140523174925.GH22111@sirena.org.uk>
 <5382D8A7.7010704@linux.intel.com>
 <20140526145127.GM22111@sirena.org.uk>
 <5383E0FA.5060509@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WEs1Fi1/lVc+yikr"
Content-Disposition: inline
In-Reply-To: <5383E0FA.5060509@linux.intel.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RESEND v2 1/4] mfd: intel_soc_pmic: Core driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WEs1Fi1/lVc+yikr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 27, 2014 at 08:48:58AM +0800, Zhu, Lejun wrote:
> On 5/26/2014 10:51 PM, Mark Brown wrote:

> >> We created these names to hide the implementation of how read/write is
> >> done from other platform specific patches interacting with this driver.
> >> So when we change the implementation, e.g. from I2C read/write to
> >> regmap, we don't have to touch all these patches.

> > This sort of HAL is frowned upon in the upstream kernel.

> We want to do what other MFD drivers' been doing, and make it easier for
> the callers. A couple of similar examples are intel_msic_reg_read() and
> lp3943_read_byte(). We want to do the same with intel_soc_pmic_readb(),
> and I don't think it's too odd.

The odd and problematic bit is the global variable part of things -
these wrappers are usually just doing lookup of the underlying I/O
handle in the struct for the device and can be implemented as static
inlines in the header.

--WEs1Fi1/lVc+yikr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJThHT0AAoJELSic+t+oim9JQ0P/j2bCvyDTX1xleXx7CDa3osQ
YsW68yWc3tyVHxvABrp7iOlBCD/rfaxF6VieDze/Dt0FyXKFw8GzpDUhFU7KtC0N
zuZAp8XgDZULcYOAfjomyuPc3T5KSdgNSCwQovVVHJyDNyshIjaiLYcX0TaZN34Y
N/nTsuyHbZqGk+kCbMeo01o6Y0XE7/PYCNPddR7sR+xo5AflnlR7JiZJQk3XlfZD
JapUcdXj4O9sPMBmqDjhke+KLsPEAmie9gLCMxJzPIcS4HxETKXkUWsOqjsxYlEt
f4BzeUjFvM879yDKBGaps+2BD7t+4QLbaHBcTsHRXLnmjFbHC8RCzLEFxvd0Hhr4
6pngxk+8LzLwqMZLVBz71MsdJklTgjKCU7IFJgs5F/cv4ZjxrqmuojLvjC/+5MqC
OmOSnGx8UqZW23Y30dRglsmJC0mpLtIAO7/ar0eXg8nalYsnO1UDqX5hx8jqlwjq
VmcnZ80JCXG91OIpPn2yYDvzh4wm4mYxl9ywsIP8zMVYfdTFUEqa9NmwSilo+hbw
DVjjf9AlUoz6SKXMv+g4u6FjY686Ku2eWNyvYi6lAfIA7gytB6atDygX9pmt29kH
npkZP01ik7mPvLqwSLov50otbtU00g7xNWClPPm6dhFx5921LvUHKGX7ysgDZ8U7
jasVkBVOWDa3E3S7Zzq9
=oUNV
-----END PGP SIGNATURE-----

--WEs1Fi1/lVc+yikr--
