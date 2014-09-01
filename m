Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbaIAP2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:28:07 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44952 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbaIAP2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:28:04 -0400
Date: Mon, 1 Sep 2014 16:26:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Message-ID: <20140901152644.GC29327@sirena.org.uk>
References: <1409583961-7466-1-git-send-email-hanjun.guo@linaro.org>
 <1409583961-7466-3-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oMfk58fZ06Sy4zVm"
Content-Disposition: inline
In-Reply-To: <1409583961-7466-3-git-send-email-hanjun.guo@linaro.org>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH for Juno 2/2] tty: SBSA compatible UART
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oMfk58fZ06Sy4zVm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 01, 2014 at 11:06:01PM +0800, Hanjun Guo wrote:
> From: Graeme Gregory <graeme.gregory@linaro.org>
>=20
> This is a subset of pl011 UART which does not supprt DMA or baud rate
> changing.
>=20
> It is specified in the Server Base System Architecture document from
> ARM.

Is there any reason not to consider submitting this as a TTY driver now
- are there known problems other than the issues with ACPI in general
(I've not reviewed the code at all)?  The ACPI binding in this case
seems particularly safe since it's a purposely basic and unconfigurable
IP.

I guess we may want to consider handoff to the full pl011 driver at some
point but there's a bunch of stuff with clocks to worry about before
then.

>=20
> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
> ---

Missing signoff here.

> +config SBSAUART_TTY
> +	tristate "SBSA UART TTY Driver"
> +	help
> +	  Console and system TTY driver for the SBSA UART which is defined
> +	  in the Server Base System Architecure document for ARM64 servers.
> +

depends on ARM || ARM64 || COMPILE_TEST?

--oMfk58fZ06Sy4zVm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUBJAwAAoJELSic+t+oim961AP/j48GTfkt8fwiI+T72GjowcL
45pp4TZVwQ8YlNnKZ0Pkjb7nSQZvj/xkTBopbGRS0TmgGLIN0G89mcWOQ8X1560A
FuhJAqvgSaUKemEawWhproN+6t8AeLmWalHFRCrT3gLJs76VK62MGOB+jTdljQo8
qv4maN1mPYhjBaDguKpnStn5S9mymGjz6/NtexWIW5MnnNJSFLtO8E2RyS+e5faN
MJsYwJk0yUS2ypUbu8zNitCK0q8Q1jDKOnsB6sxBP3nyD1i1a86mT9aKa5N8TFyX
gOzLz+c93BehTmFGmwdKW2PMO1Mssgslz6j62vOrE/1HBhoLb8yhbKX/Z4CSiMkt
brdGZK3qchOnx70ae2wLL6rrdPDqzD+ma009k91DuxLgBZ7tyxqaPnHfUGoZU6ij
dR7JHTeerBkGETxdd4HHRP5OFEh47bVUBR47X46VAE+jH8IuuMJbKF1hwZu/Ehn5
X3N2u1fsvf3oVrIPpZraxAkeYvb2nWHmcWk4KrXHKpUvVtX0LWsxP6HXBNlZwqa9
cvtKsAZPmogd41XSc4ZEhaY6m1JTLl9Fo0EmMGzQjf88igKyprqoPOu8LmLhQD/p
2mAy6GeGSavWm8qyva0UTU2iI5eEw2HF7+D5D28XwJLUErRgOFLKAdowRXq986NR
t3SAHRQ0kdlEjbEWeUPM
=6/9U
-----END PGP SIGNATURE-----

--oMfk58fZ06Sy4zVm--
