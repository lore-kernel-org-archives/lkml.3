Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbaIAQ7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 12:59:46 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45092 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbaIAQ7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 12:59:44 -0400
Date: Mon, 1 Sep 2014 17:58:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Rob Herring <robh@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robert Moore <robert.moore@intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lv Zheng <lv.zheng@intel.com>
Message-ID: <20140901165853.GJ29327@sirena.org.uk>
References: <1409583961-7466-1-git-send-email-hanjun.guo@linaro.org>
 <1409583961-7466-2-git-send-email-hanjun.guo@linaro.org>
 <2861461.8zNpLC3I2n@wuerfel>
 <20140901152854.GJ2953@xora-haswell.xora.org.uk>
 <20140901165333.GE608@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vFj1JTFBn4Zx1dEI"
Content-Disposition: inline
In-Reply-To: <20140901165333.GE608@arm.com>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [Linaro-acpi] [RFC PATCH for Juno 1/2] net: smsc911x add support
 for probing from ACPI
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vFj1JTFBn4Zx1dEI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 01, 2014 at 05:53:33PM +0100, Catalin Marinas wrote:

> Confused. Then how come smsc911x_drv_probe() has this line:

> 	acpi_handle *ahandle = ACPI_HANDLE(&pdev->dev);

> without any #ifdef's.

There's a stub smsc911x_probe_config_acpi() provided in the non-ACPI
case, Arnd's suggestion is basically to remove the stub.

--vFj1JTFBn4Zx1dEI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUBKXKAAoJELSic+t+oim9w4YQAJgqBp4ZZK1g0TnNamLLxEmY
tEkKtzlmTTWl3YWpa+1OLjpm1LXQIM7Ysnaev90/1OiTLM4huPEjG/jwBZ//siyY
c90Js4fL9BtBXhSc1Zp6ua+DbYp7b2/iyCMWR202jykgYtRJz6OiS+rHXzXRKaPo
PzUol1WD69SonUAcEaRsOPDrvbQUytSx6P//cVYy811iRAboCSiIMHBwBmcREslc
AobrG7FCJENHGXZzJAeSi59xwbgGPY1m0Zaim8CXwoGT9EhAMXcj6VO1Ie5l9ohv
hp+ocZlmcTX4FpUrfBL9lpOZwNSbErj2OqhjmsHNdgJrW7anTuJ7V9VnntD4BYti
/eRd0dcJl+t1MyBxeiAz2k2uJXo6LB8gTH5n9fbUYZKmVS50AB8O+PMti2UYao4S
wzzPtDdZ+AiHxwMjpDvCsP88Oz3mX1WVvAb3/K+xsGjkWP4pF/fcdNmL0+wauHL1
MieKpFz0l83BGCLYfC662q+n13oPbd3eBFTXdWEM1fVpHPQ4CFR4pY4oWiZ4HsIb
4oW2c4nTB78teMS3vHfbO/y/r7EWE1Ig7FjVvdFnhMm/76iqmTFfWpkrm6pKZ15U
GQEZPWj/T61Ryq8vpnRvI3NU/7AW6MaPvSHZPqEe/wP/HqR2ExR0NtSO7A8315Ot
7PhCFNqUOVJ5RgUzwmeC
=wNA1
-----END PGP SIGNATURE-----

--vFj1JTFBn4Zx1dEI--
