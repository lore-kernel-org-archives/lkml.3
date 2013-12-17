Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab3LQNYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:24:19 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:33847 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab3LQNYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:24:15 -0500
Date: Tue, 17 Dec 2013 14:22:48 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, Xiubo Li <Li.Xiubo@freescale.com>,
        mark.rutland@arm.com, s.hauer@pengutronix.de, galak@codeaurora.org,
        swarren@wwwdotorg.org, t.figa@samsung.com, grant.likely@linaro.org,
        matt.porter@linaro.org, rob@landley.net, ian.campbell@citrix.com,
        pawel.moll@arm.com, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Alison Wang <b18965@freescale.com>,
        Jingchang Lu <b35083@freescale.com>
Subject: Re: [PATCHv7 1/4] pwm: Add Freescale FTM PWM driver support
Message-ID: <20131217132247.GB2329@ulmo.nvidia.com>
References: <1386925027-16288-1-git-send-email-Li.Xiubo@freescale.com>
 <5295539.cCkPY1PpyC@flatron>
 <20131217124505.GB17210@ulmo.nvidia.com>
 <1500339.E8bGm7xZUi@flatron>
 <20131217130435.GV4360@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vGgW1X5XWziG23Ko"
Content-Disposition: inline
In-Reply-To: <20131217130435.GV4360@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 17, 2013 at 01:04:35PM +0000, Russell King - ARM Linux wrote:
> On Tue, Dec 17, 2013 at 01:54:35PM +0100, Tomasz Figa wrote:
> > On Tuesday 17 of December 2013 13:45:06 Thierry Reding wrote:
> > > I fail to see how that would eliminate the problem with the types. Th=
at
> > > said I don't actually see sparse complaining about any type mismatche=
s.
> > > That's probably because the various macros implicitly cast to u32.
> >=20
> > Well, in BE variant you would read the register using __raw_readl() into
> > a __be32 and then get an u32 from be32_to_cpu() and return it. Similarly
> > for writes
>=20
> __raw_readl() returns a u32, so you'll get a warning trying to assign a
> u32 to a __be32.

If sparse doesn't complain about the original code here, does that mean
we have a bug that should be fixed?

> We do have ioread32() and ioread32be() which do the appropriate conversio=
n,
> as well as the write versions too.  They both include the barrier if you'=
re
> overly concerned about that.

A few years ago GregKH commented in response to a patch that ioread*()
weren't supposed to be used for memory-mapped only devices. The original
purpose apparently was to allow drivers to work with both I/O and
memory-mapped devices.

Thierry

--vGgW1X5XWziG23Ko
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSsFAnAAoJEN0jrNd/PrOhFHAP/18QBTQBzsFYKMuPA3mxwEFc
9WMVB4Bs7HPvm1y7kvESmbxcKIZX/CIqwJUgr0Z1pEnu19Bfe98/whOzg0VdLfUU
H2K3d2u2OtZzfEY/0U+HDxQXXefbCJ39it2xaYZvKkwhP3oNzB3wXzAMUtdOAoWn
2/abpdleVg9a1lo6/A8SJyaBTEXsDWdOHkEUcQeO/tB6XXF+Ab1OrYJWAJm66lzG
zAy47pcuC3sU4/RmIEeIGzRlNbZcB9NUbOHYZvhygnE1Gw8IpgOnGGUQdI7BJ8NO
eb01ZubOZfi2KHN4+UM3G5uWg+HJoji5b8h02h6VXYJvyI5NO7Jo5oXK1W/w+uGG
zeEKJmkk6XDNQy6stDx94jbKt9BAoZ4fwNqEPbQ1Tgqn9Ac2mTedgtfeY3hARxHq
IzcYfKFjqvFXI1zLzLS7MwPO3Kadjrp5c706KO9nBJsz2T7LIKQ/eGNSKDRZYAWX
u8L/6VaFYapqDMwpKMYjwvCQdXy/l1qrWRUsbEF74+lYrsnVCYTdx7wPKr9YNkl8
yFHbDtJm2ESw0l5TNtBuAkIX6GwrzxUs6G4sj5AOPnvMjpIEP0NhZV7B9EwhEMIE
isRKwJkkYX/M6q1XcVHj/AVZkyqNZwKq1I/ThbySlz8T5AuavmSwiRF7JIYYjZx1
djaIzF+fbk/kUVBGa4y7
=1O70
-----END PGP SIGNATURE-----

--vGgW1X5XWziG23Ko--
