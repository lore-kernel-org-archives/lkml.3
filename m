Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab3AKK7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 05:59:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57516 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752133Ab3AKK7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 05:59:41 -0500
Date: Fri, 11 Jan 2013 10:59:38 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, haojian.zhuang@gmail.com, chao.bi@intel.com,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 05/11] spi/pxa2xx: make clock rate configurable from
 platform data
Message-ID: <20130111105938.GU20956@opensource.wolfsonmicro.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
 <20130110133319.GT20956@opensource.wolfsonmicro.com>
 <20130110135852.GS13897@intel.com>
 <2426125.yN3kXlp07z@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oGy11dVowAZA6eXT"
Content-Disposition: inline
In-Reply-To: <2426125.yN3kXlp07z@vostro.rjw.lan>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oGy11dVowAZA6eXT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 10, 2013 at 10:56:36PM +0100, Rafael J. Wysocki wrote:
> On Thursday, January 10, 2013 03:58:52 PM Mika Westerberg wrote:

> > Well, they can use the same LPSS block with a different CPU but then we
> > expect the ACPI IDs to change as well (so we can then make another set of
> > clocks for those).

> Also, as I said in another message, even if the LPSS block is used, the SPI
> may not be exposed to us by the BIOS, so SoC enumeration is not sufficient
> in general.

The clock is going to be there in the SoC - given that you're just
exposing a fixed rate clock it's not going to do anything except use a
little memory if its' there.

--oGy11dVowAZA6eXT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ7/CTAAoJELSic+t+oim9wR4P/20DinaSuzLXchBW6XFK04IC
kny5jRECVpVhLTjxQi4ESkWjK7//9blsw+z84SQZdjyC/CIZ38gv8Nz3Nhe70MKH
EoKfZcNjobTqTeg3XC4sA48OlzjJL5SdwjhGSlUxYnAdJlJUcNlOJ5OTcWSSYKF8
lYYdE+bBPAeLQiJWcQMIBvANBdA9xk3TRdb1nIQxseawDnMOfhz1aBPZZW0Ycafp
QPG9VmYd01lHXbKnkZHLn3YdlYgWR+iKskZ29rW1ExBQxvYGgBaO1aveLmlGOY2M
vhTrJCN/IC9PIWx7HLzJz1/pHCuZoknfW2EdRJfCqctlDem1YEWT/X2Yfd53MTJg
4qI9R90mTVkV+RWhxhmL509JF1siztCdsQ8GGZCOLZYfz38E4w71sLMVm7fcYucw
fB6qBTzwGBRXL0UseSPkQKsMQx+N6rzEhPJvq9bidQTpJFAZo6KhOqg1JYue64Qj
LpDu7UdM402Cw7BNDT2lJSB/zutfscgb+aLlx3h/9bMyIER9z4fzHOZ8+0PLajWI
S4uypNgmadGQTMHqUUXPBYK+Hx7S0cvtcISmtYB1UAJ6vF3oHZ8O4nbs/BpClbdu
MLf6vivcNSX79HJcoFJgj/xRTm4USHRJ+H6UbPR5w8HDr/msq751DiJklnsdPHQa
he2A2uc6KTz7yhyJZyHd
=6Ckl
-----END PGP SIGNATURE-----

--oGy11dVowAZA6eXT--
