Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab3K2LEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 06:04:36 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:56394 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab3K2LE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 06:04:29 -0500
Date: Fri, 29 Nov 2013 12:03:40 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Marc Dietrich <marvin24@gmx.de>
Cc: Alexandre Courbot <gnurou@gmail.com>, Rhyland Klein <rklein@nvidia.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alex Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 1/6] ARM: tegra: add gpiod_lookup table for paz00
Message-ID: <20131129110339.GK22771@ulmo.nvidia.com>
References: <1385460350-17543-1-git-send-email-mika.westerberg@linux.intel.com>
 <1752117.77jQLaML2y@fb07-iapwap2>
 <20131128110636.GA22818@ulmo.nvidia.com>
 <1441981.OvF23sGttd@fb07-iapwap2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qo8f1a4rgWw9S/zY"
Content-Disposition: inline
In-Reply-To: <1441981.OvF23sGttd@fb07-iapwap2>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qo8f1a4rgWw9S/zY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 28, 2013 at 01:54:10PM +0100, Marc Dietrich wrote:
[...]
> Yes, rfkill is just an interface for userspace to able to control the gpi=
o.=20
> E.g. backlight of medcom-wide seems to be related to the pwm controller, =
but=20
> is not a subnode of it. Instead it is a device of its own without parent.=
=20
> Hence, we may include rfkill in a similar, "free-standing" node. But this=
=20
> approch was rejected in the past. Maybe this changed now.

Indeed. I think we really do need ways to represent this kind of device.
If we can't then how are we supposed to get rid of board files?

> Thinking a bit more about it, rfkill is neither a hw block nor a function=
 of=20
> the wifi driver, so I guess it cannot be added to the usb controller (or =
a usb=20
> device).

I guess it depends a bit. Some rfkill-type devices may control more than
just WiFi (bluetooth, NFC, ...). If it really only controls WiFi, I
think it would still be reasonable to represent it as a child of the
WiFi device. It is, after all, a mechanism to control the WiFi hardware.

Alternatively I suppose we wouldn't really need to have an explicit
node. The WiFi driver could simply instantiate an rfkill device based on
its own properties.

Thierry

--Qo8f1a4rgWw9S/zY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSmHSLAAoJEN0jrNd/PrOhLYkP/iKC6LI2LuPV2l8HKpb66GZX
6Z1jL3BdUR+cDxHLIzUEEbdEtpYxj3bkL8pyYxBKI8UCs2xnIowjjU/YAf+I/pt2
ZgdrG5z9gDM1TRTVSfIgYAa57KZG31TIVdZSZbrJ/r38UbohkdIrxAYkBbqmAkIZ
W4FDvgkaUm6+SMfZVlIiRDmMx5lM9VqOTfJMs34cqRUZm9QN3yk77mIFqDc1F2Yb
u7ac634AmvxmUabZsZ91FyOQB+ne5NLwV1hjIwHUr0qwBd/ZIqy9fLgOYMNtCUN6
p0uVddGuVJf8ViBZgY5M796rOaxHTRJRZFACvS5kU+wvW1dglB6baCfa+4dPclkX
N1/qEJM7LA9RHTkMOF07vYVSiC0BBYWhzRl1jXhlmDv0pmzxMv+we6iPBbGUNv1M
kUFbrVK6ubsiaaA3nfQB//N/2DW8QO2cj3ZzRZ+B0hQtHdQZY6RmiioZX/hy5zF5
apRjLFnfw+jUglD2qrzgAqdRadk/xYFRQW/J/ZVZ89nbau5FkrRtEJZ//ELOlhDX
XfRBqMBXy0JEFHFTlKmw+SfNnK4EuAYwnBIlkUG1jjNAbTIj74KJz59fq21QvA14
JVD1Bnp43cF+zqxfw9c0dkyPZYMT7WCKEfl+butSo16LUz3wlRtTgNVrO1Ey4cGG
RbxiybMrNI3YFCNjli2n
=cEez
-----END PGP SIGNATURE-----

--Qo8f1a4rgWw9S/zY--
