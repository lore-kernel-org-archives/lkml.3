Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161773AbaDPPW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 11:22:27 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34852 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161133AbaDPPWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 11:22:25 -0400
Date: Wed, 16 Apr 2014 10:19:48 -0500
From: Felipe Balbi <balbi@ti.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: <kishon@ti.com>, <santosh.shilimkar@ti.com>, <balbi@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] phy: core: make NULL a valid phy reference if
 !CONFIG_GENERIC_PHY
Message-ID: <20140416151947.GF28035@saruman.home>
Reply-To: <balbi@ti.com>
References: <1397648901-4450-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EDJsL2R9iCFAt7IV"
Content-Disposition: inline
In-Reply-To: <1397648901-4450-1-git-send-email-grygorii.strashko@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--EDJsL2R9iCFAt7IV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 16, 2014 at 02:48:21PM +0300, Grygorii Strashko wrote:
> This fixes a regression on Keystone 2 platforms caused by patch
> 57303488cd37da58263e842de134dc65f7c626d5
> "usb: dwc3: adapt dwc3 core to use Generic PHY Framework" which adds
> optional support of generic phy in DWC3 core.
>=20
> On Keystone 2 platforms the USB is not working now because
> CONFIG_GENERIC_PHY isn't set and, as result, Generic PHY APIs stubs
> return -ENOSYS always. The log shows:
>  dwc3 2690000.dwc3: failed to initialize core
>  dwc3: probe of 2690000.dwc3 failed with error -38
>=20
> Hence, fix it by making NULL a valid phy reference in Generic PHY
> APIs stubs in the same way as it was done by the patch
> 04c2facad8fee66c981a51852806d8923336f362 "drivers: phy: Make NULL
> a valid phy reference".
>=20
> CC: Kishon Vijay Abraham I <kishon@ti.com>
> CC: Felipe Balbi <balbi@ti.com>
> CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

I thought I'd already acked this one... oh well, need more coffee:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--EDJsL2R9iCFAt7IV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTTp+TAAoJEIaOsuA1yqREJb0QAKDbKUmldYg4DaF5bIcQYQNa
rmQ/IVElUJXsEjEj7rIotC7i36u4ST5ewEUPZKGdZLB5IBq0bl35IAgQq67HCb3s
8OZsPnbwQ+bBgMTJ6039/ppHgY4hI02aNmghHCAOnPBAgN23+vPA5455BhS5hpdL
+XoprpZ7qqdve8MS08dcqwDOEtySryFAUmhkc0I5mEv+WFWV9uFQV+ftW+z8oHC9
17c/R1MiwaOm4QiFTvYMqXlRcHdf9q9HI/tmH7k7ij4frfNqYqyHKPN0pEMHWiN4
OYEON/4QuNRjQ264Zi3V34biJuthtcTEwV4cKhunXm2gfc4FxvWBeKUi96IKo/kH
duofg5MbW7Qe4JkScjwyk6iHBdB4CuQeoXiubgLoL5X5oX8r+KBUpzkLaxTCoBtS
r0fh6d6BHCP+B2lpQus2L8hVRRMhgKjjCnPAiUw1+cKJB4eIwXUpUESbARnhDbND
7rZlYLu1y9O3/itnbnrv5xL9hyn5CYzvxndZC1WZ66LZDC1X4J/8Sz1BNxqqouIb
uR+WFFeSI4F4DDpvfqMwbD83trITzAQ4A+YVPUVaV2MjMG6soWwtzgSJ88AY5iNA
j+hiTxJzq73d9v1RObErhLUadIVJi0nTB8Jwdd/xAItDDJLQsHK38k0iU40ubv6p
Gx1DqihIXAgIGIaqP7Xy
=Mnq6
-----END PGP SIGNATURE-----

--EDJsL2R9iCFAt7IV--
