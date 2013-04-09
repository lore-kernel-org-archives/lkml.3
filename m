Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937690Ab3DIKeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:34:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34381 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935814Ab3DIKeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:34:08 -0400
Date: Tue, 9 Apr 2013 11:34:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Girish KS <girishks2000@gmail.com>
Cc: spi-devel-general@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH V3 4/5] spi: s3c64xx: Added provision for dedicated cs pin
Message-ID: <20130409103404.GO9243@opensource.wolfsonmicro.com>
References: <1363157014-9615-1-git-send-email-ks.giri@samsung.com>
 <1363157014-9615-5-git-send-email-ks.giri@samsung.com>
 <20130401125744.GG18636@opensource.wolfsonmicro.com>
 <CAKrE-Kd+YAFmteDdh3odtV+YU1=OjoMuQV9usF4NmUse+TXhTg@mail.gmail.com>
 <20130408101530.GC9243@opensource.wolfsonmicro.com>
 <CAKrE-KevVramLc1n_9kcfHVb=RKT_kexQ8iUP-5+BL3wxpMPbQ@mail.gmail.com>
 <20130408122056.GG9243@opensource.wolfsonmicro.com>
 <CAKrE-KcMy1qzzg1JXqBOvAJTdQM3rLU6dHoQRnyryLz4p0rpaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O7Os1+MGCLLi8F5z"
Content-Disposition: inline
In-Reply-To: <CAKrE-KcMy1qzzg1JXqBOvAJTdQM3rLU6dHoQRnyryLz4p0rpaA@mail.gmail.com>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O7Os1+MGCLLi8F5z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 08, 2013 at 07:19:05PM +0530, Girish KS wrote:

> I will move the populating cs_gpio logic to probe. But the enable_cs
> and disable_cs will have the
> check before calling the gpio_set_value api (because it takes cs-line
> as a parameter),

Yes, you'll still need to have a check.

--O7Os1+MGCLLi8F5z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRY+6CAAoJELSic+t+oim9ndwP/2tC3SeHMBD9NcWgpcftfUab
XCWrgmzF/0roSY/W7/qNEACNMssAD602FflPNAo6FdtArtCPR5VVL8GPZU+jIv0A
gQWoyPJSYeANdFVriRKbCMvqf0ifT/eIpVQAGOjINvPJJDVU3ktrdtjw+eLSTylP
TTeTpaRPHYf0lWXLjz8V3+xgEZaKt8P1+o7wawKfXocE/YYDIwLZr3/KwJlywRZX
tF/0fIUeM4Xn0P56F8Q4DgDcHY01gkcr6pxFeS24+2kf1Msyj7OPsdTs2hE30Oa4
MW1jQhNbjdd2vubI22dFz1l7yFzhiF6GXtj8JbMhQ3jZqoQajba4qIfrdqdyjDRN
eU1do2WYX7/yUdiQS4gmlNmglXoBmhfp+dmg8LftEoZbJgfXnveAjQrcSz5NnPT0
bJWNyc3+KPmhGD+Zw/RRz8Fg9beF838yleHppcE5f8aaS6Hln9Fmg6aP2f49C9hA
if7xAkOfgpOBrqRJUnrYkpX+DftEdFrVKFV2fI8FhEVsxihc9vZ+upugNWvLv50h
iAgqFNCelZm/Y7jGt88yNnGm4UCibtyHRXvfFE0xlBxrMxSSqf9nVD47+NTYKcAx
KdEj6kcVhyqMcFs8bdIG5lXU76QYTyg2v1oFdnz1xTq0hD8gk9NPPU81vwG2Wvlg
bQgPilzwD3cV4Y6cJuJX
=r1AH
-----END PGP SIGNATURE-----

--O7Os1+MGCLLi8F5z--
