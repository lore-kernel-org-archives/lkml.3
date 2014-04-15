Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbaDOMN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:13:59 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33851 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaDOMN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:13:56 -0400
Date: Tue, 15 Apr 2014 13:13:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        sameo@linux.intel.com, lgirdwood@gmail.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140415121325.GX12304@sirena.org.uk>
References: <1396340845-24060-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1396340845-24060-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20140415101200.GC27091@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OtXN0xDA1zr/oUEL"
Content-Disposition: inline
In-Reply-To: <20140415101200.GC27091@lee--X1>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/6] regulator: arizona-ldo1: Move setup processing from
 arizona-core
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OtXN0xDA1zr/oUEL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 15, 2014 at 11:12:00AM +0100, Lee Jones wrote:
> On Tue, 01 Apr 2014, Charles Keepax wrote:

> > +#ifdef CONFIG_OF

> I think "if (IS_ENABLED(CONFIG_OF))" is preferred now, but I guess
> that's up to Mark.

Yes, it doesn't matter for booleans though.

--OtXN0xDA1zr/oUEL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTSJiAAoJELSic+t+oim9Me0QAJTrUpGzSbRISrS+gCHNkSPl
6WLtN6Zi2MbdvAwvDtfZhbUse1aw7SvZNU3uLUhDDs4EdXLsrJNzyo3V6TH2sbF2
l2JXTKUbkZu4Dsc8Y2RCBkASEI5CA2ngmjEqReU0sr5zAqx0+9pext/u3PbPJAWo
pwo35aWk+jV6CHiDhgoMerQmOgg7dkkJvgyd8iSx5ViNl2QRq6OX1oFjIL8RJP/+
VglJZiMI9VOOFPTqklTwOiJ1Y0DDVg+k3RM5KkleUhLslSpukh7z65Rhfl2hS9uu
TJfJiPL9VYsb5pdWnH9sDi2Ry3i9gOZDnSHKhMsAcbsLgwTzDwgg8vskzj0UDceo
QRA4S89dQjH1bsmB2O6+UDqZAicpcCvuMJeXuGau0ioFLU0UYjGekdHHxJ/TKknz
UZ618SB5VS0giQMlF2uqUW150Nj3fV6KqkfVYKNf+Km40MRjAITcROI1NGY3B+yE
J3SfwPgvXj2YxYROuvMquvel7+6AjwsH9eFJcoWQe9TYhm51u7Jul+OR/zeY0uNE
iSZSMDccu0mVfQW9BY2MEFgtmOHfWF7frJawmM2/nb1aVjBrNcOaS+PxzyHN8phQ
mh5zZEBPmNxO3RvmDFZ5Iq+OY/6QmRTGha79/UT+Jw5x5+NZu+Ql0nQ7eCw7sB1I
lpqa5aBvwEr3BhaBjFC8
=+lY2
-----END PGP SIGNATURE-----

--OtXN0xDA1zr/oUEL--
