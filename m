Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbaIBQ1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:27:15 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46753 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbaIBQ1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:27:13 -0400
Date: Tue, 2 Sep 2014 17:26:06 +0100
From: Mark Brown <broonie@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linaro-acpi@lists.linaro.org, Catalin Marinas <catalin.marinas@arm.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Lv Zheng <lv.zheng@intel.com>, Rob Herring <robh@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
Message-ID: <20140902162606.GX29327@sirena.org.uk>
References: <1409583961-7466-1-git-send-email-hanjun.guo@linaro.org>
 <20140901173245.GM2953@xora-haswell.xora.org.uk>
 <20140902132651.GF27056@arm.com>
 <4816592.tj3on6vUaC@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s3puAW9DMBtS2ARW"
Content-Disposition: inline
In-Reply-To: <4816592.tj3on6vUaC@wuerfel>
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


--s3puAW9DMBtS2ARW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 02, 2014 at 03:42:53PM +0200, Arnd Bergmann wrote:

> The way I recall the discussion, most people were on one extreme
> side of the discussion or the other:

> a) We should use _DSD for ARM64 servers to maximize code reuse with
> DT-enabled drivers, work around the slow UEFI standardization process,
> remain in control of the actual bindings, and avoid the need for
> endless per-ID platform-data definitions in drivers.

> b) We should never use _DSD at all, since doing that would have no
> advantage over using DT directly, and we should force every device
> manufacturer to specify their bindings in an official ACPI document
> to prevent random incompatible bindings from being established.
> Any device that shows up in servers should not need arbitrary detailed
> properties anyway, as the details are supposed to be hidden in AML.

> I can understand the reasons for both approaches, and I find it hard
> to say either one is invalid. However, the worst possible outcome in
> my opinion would be having to support a mix of the two.

Right, and the x86 embedded folks are going full steam ahead with _DSD
regardless so it seems there will be some systems out there using it
even if they're not ARM servers.

--s3puAW9DMBtS2ARW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUBe+bAAoJELSic+t+oim9sR8P/3DUB6yHWvKAo+9FV3srXLHz
Dw5T5OmqTXZY3YBeKsGypAXmJRnI4vAjWGEYK+Z8KKSQLwJW9DVwqpaLjxAfNqg8
GBtXem6nWghp9bFVvyQNCFMKAFvPCV/zSIABQCGp/959tdKJXK088oOGIl0qfGjD
NlPCD9P5mXY4h7T1+0lJLz6+xha7lB9cxd1N3jAYTMWpSqXkWYxCuNYo/80ZJorl
JqNZ1u0FokaUS+TjRk6UDPH9Pe3jdS+T0aNOLykPO7oe0r+DCrS9jeLoQ62UxNcy
JH/jYpSix1hmximYlIvIhTTzBw0uFXFkjS5sg2WzpQEYqv1vDCuhcO1sfar7EtIB
0XczMj6Wl/uj/zCp+gglbYlwAoAS7ZXMOrzn7KntKqkvfY6cOhlXzYfk2S8bIPzM
8vLobNsGrcN4tJu3+N0ZsVIxjq2XrE2AZCarGV90fWRxMQ/H9BWYoOzu3Nez0CFA
HHLE5o3Oqgr6cZ2etnhTcrLF9PxgyRrG+ZRcayD84zUUIZwtxdELGpnwIIdlQoEs
glQY+S3/qInLM42nnKaoPA4axdnfzcXRkzbFNMYNM2YJgcYxDKTftX+wNuo4yH28
GHA/SXUmCxupPq3eaI9QRyp211nI3GJBw4pim1EiMxEjGVXgeEWpXi9aUEQeBf/D
jKjzSpzSbNBpEVG+GNYB
=+au5
-----END PGP SIGNATURE-----

--s3puAW9DMBtS2ARW--
