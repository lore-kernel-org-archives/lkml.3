Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994AbaFCPwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:52:05 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52187 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172AbaFCPwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:52:03 -0400
Date: Tue, 3 Jun 2014 16:51:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140603155143.GH31751@sirena.org.uk>
References: <1401808652-20524-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bda7maMjJbTZ4Ov1"
Content-Disposition: inline
In-Reply-To: <1401808652-20524-1-git-send-email-thierry.reding@gmail.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 109.148.252.180
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: as3722: Make 0 a valid selector
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bda7maMjJbTZ4Ov1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 05:17:32PM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>=20
> As of commit 064d5cd110f9 (regulator: core: Fix the init of DT defined
> fixed regulators) the regulator core tries to query the current voltage
> of a regulator when applying constraints. This exposes a bug in the
> AS3722 regulator driver which fails to read the voltage of disabled
> regulators. The reason is that the hardware is programmed to a selector
> of 0, but none of the voltage tables include 0 as a valid selector. The
> datasheets indicate that 0 is a valid selector when the regulators are
> powered off.

Applied, thanks.

--bda7maMjJbTZ4Ov1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTje8LAAoJELSic+t+oim9UlgP/iYtM/z+xuDGmTgeDSbv58qf
3pT+i0NS+YAYyXw71iWJaWhfpsNZNsNLJEndXvN4InGBArigoBgSN0hOTfZQLHMD
u3fqLQnfa9XPFqH5zjawC1sHA9oLAYyfCly50W/uu6K5k8VaaKF2AX7xfDm4Q4dU
lf0NlAMF55GwPPtck7BSx6kgqRcf728ku9mFynO3pPHNW/83n3NhgYnXmTQHISSp
WPZAM6h3Dcm974Wk1Q5/6ioDTmTLqveRTq1SaMjmk0OAWgRGwbATaQnZa4whocgL
ZMJeVMQE28bIxjyGJ5lixVT4KdguYiu4gi3cpjklHbpczYZFSSChyXgBs8m6olCn
o4veSRWuEW2H7fuI8SfJ5jmJQDJYJlod4juD0VbNOsW94Mf75Ln7e5M14V+MapC1
cjZAE7oTs3H40/DfCBHWqYVCvEhKp/ZXWpL7kwGhRf+K9PKz6aDxOqyowmq+fCH7
VJYhvzyUIAwjisAtz8CZQ6PJbCb4x4NrBWArXCH+AVpZlCj1EA7XE4qTfflszugl
TfZJlqe9gF8XDW+nCaT9L1TGEHA3TxZGmEGUhZPYNZtw4onhDWJoJp2sB2/KEApA
0xpkw3KBNyeN341CxQRELgtANMcRkUO0qIKb3x8xhxHk3X0Iu9GaH+vJ9z4iQD7E
62ipDInQBdisuHJFJr5z
=MQS0
-----END PGP SIGNATURE-----

--bda7maMjJbTZ4Ov1--
