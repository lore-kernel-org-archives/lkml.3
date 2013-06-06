Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab3FFKzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:55:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52329 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab3FFKzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:55:40 -0400
Date: Thu, 6 Jun 2013 11:55:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Message-ID: <20130606105530.GT31367@sirena.org.uk>
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
 <7380889.l4hHqCT0mm@dtor-d630.eng.vmware.com>
 <51AF8730.4010507@itdev.co.uk>
 <1717403.GgHsbyUkDZ@dtor-d630.eng.vmware.com>
 <51AFA02B.3000604@itdev.co.uk>
 <20130605210715.GA16013@core.coreip.homeip.net>
 <51AFAF6D.7050204@itdev.co.uk>
 <20130606100346.GC1883@sirena.org.uk>
 <51B0651D.3090902@itdev.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dZflLWwKqQHwno8z"
Content-Disposition: inline
In-Reply-To: <51B0651D.3090902@itdev.co.uk>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 10/53] Input: atmel_mxt_ts - Add memory access interface
 via sysfs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dZflLWwKqQHwno8z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 06, 2013 at 11:31:57AM +0100, Nick Dyer wrote:

> Having to define every parameter in each object (there are thousands) in
> the kernel driver would be impractically technically, since it would result
> in a huge, and constantly updating API, which would be always out-of-date,
> and impossible to support.

> Also, I'm afraid it would also be impractical legally, since it would
> breach the NDA terms that Atmel require on these parameter definitions.

If that's a big problem just put the data table in a section of the
firmware (or a separate file that gets requested as a firmware).  Or
have the firmware be able to enumerate itself when asked.

> >> product-specific complexity to user space. Hence exposing the register map
> >> and implementing user-space libraries to deal with this kind of customisation.

> > This sounds like a bad design decision for Linux, it's just asking for
> > fragility if userspace can go randomly poking round the entire register
> > map of the device with nothing coordinating with the driver code.

> It works very well in practice. This same abstraction is used across
> maXTouch products on many platforms to provide tool support. I agree that
> its use should be restricted to system programs.

It works well so long as people use the supplied binaries in the way
that's been proscribed.  As soon as people start upgrading kernels,
customising things out of your expected flow (because they can or
they're on a tight deadline) things will get more fragile.  This sort of
stuff is really common, the approaches I'm describing are fairly
standard solutions.

--dZflLWwKqQHwno8z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRsGqfAAoJELSic+t+oim90hMP+gLkNCyFRPU/h3qBc7ev5JNC
nHq3U+v/v6/V0XB7EbGH2Wn2jpuWCaZ50yaIt9UAznp1XugtgaHXdrupZn61PXSV
B13zFCtCyZ7y2hKXg5RqHECSedxjxE0/87jwqNduamGqb/fhgD2WXAPmqB86j4kt
Fn68FFhrN56R7iFaLPoDnqGD64/fULma6GcEl7lxXFvqRutUyeyHG9i5vt+k5plb
VmuNzSVUR2kzoGWMHo39qhshoN8/F7OFsGYE0OHxuJsnsSV0RisH+bjM1KnfCJvH
4Zod23ZY0sxiZMPFXYqj0/VguZ0ixklKK5BP6zZmv+EPmLHGdWcdQVgyN+ZmzUuX
6jUUWJqTxj6nmcoswiM3qTV3uf5JZso/z0tmVQrSsyEKBcXMDSXHfVatbljqgGu+
veu/l+8oHaWESIK9mo9xXz6A5Xd/bsPdEplKX9z+iZqyjO1oadEYNnEad5M3oc2w
kknDuVugx90YFUkNmvHdwQYIPF0oO3PZAoOOiPuVVk9nTgkrWKKHD1iYtP+Lsb8w
N9xUNvqtIZUlzb/3ltjtOCT6ndpH8g1Zlos0519SMXNZJPo2ZWNxv5yXE/qSlr1E
hoyUcNq1V/9JNPjIWANfsZTHnZV+AWnC/r1ylK2Nw6NkPvrvHG8zNu98gUFoc808
X01UNGBp7nzhnNipRVcd
=f89C
-----END PGP SIGNATURE-----

--dZflLWwKqQHwno8z--
