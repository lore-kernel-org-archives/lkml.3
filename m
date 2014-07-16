Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbaGPIBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:01:50 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:56541 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756608AbaGPIBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:01:47 -0400
Date: Wed, 16 Jul 2014 10:01:34 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH 01/13] clk: tegra: Add binding for the Tegra124 DFLL
 clocksource
Message-ID: <20140716080133.GI7978@ulmo>
References: <CAL1qeaFF0ZpUFovxTuLXrBPRg2Lbf-754Z=ztD5HFZPbfnDsAw@mail.gmail.com>
 <53C01558.3090607@nvidia.com>
 <CAL1qeaHETQ7kSGNjPiwi_9WNMtr9qZp0KwjZCCxY29+_N4AcuA@mail.gmail.com>
 <53C01D17.2050906@nvidia.com>
 <20140714083854.GO2081@ulmo>
 <20140714091233.GC6800@sirena.org.uk>
 <20140714092434.GA9755@ulmo>
 <20140714102203.GD6800@sirena.org.uk>
 <53C58DCB.90502@nvidia.com>
 <20140715225252.GD17528@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G3juXO9GfR42w+sw"
Content-Disposition: inline
In-Reply-To: <20140715225252.GD17528@sirena.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G3juXO9GfR42w+sw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2014 at 11:52:52PM +0100, Mark Brown wrote:
> On Tue, Jul 15, 2014 at 11:23:39PM +0300, Tuomas Tynkkynen wrote:
>=20
> > That sounds indeed useful for this case. How'd the following interface
> > sound for the register offset / selector-to-register-value conversion?
> > The I2C address would be a bit trickier to get as it would touch the
> > regmap stuff as well, but perhaps it would be a good idea to have a
> > phandle to the I2C device itself, and then parse the reg field for
> > the address.
>=20
> This looks fine, can you submit properly please?  For the I2C address
> why not just have an interface to get the regmap and then provide a way
> to get the underlying device back from the regmap?

Is it mandatory for regulators to use regmap? Also I'm not sure how this
will work with MFDs, since the device may not be the actual bus device,
but rather a child of the MFD (and what we want access to is the MFD).
Perhaps for regmaps that would work in most cases since MFDs seem to
aften share the regmap with their children. However, the code in
regulator_register() at least indicates that even then it's possible to
have a regmap in children that's different from the top-level MFD.

Thierry

--G3juXO9GfR42w+sw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxjFdAAoJEN0jrNd/PrOh9DwP/3dzscoXYXMEY5bwISYqlh72
OAspRRFCWc5DIrmpKCnzZQq8Z/BguxD4Qf3xWpkllLkpGJHJVa4489gPBOLQrxPa
tR0t4fYHFxs4GT1m+LmuLH+yNArhEFcTZI+N7aWB2O+G4s8lvFJPZdVM604GZjXB
9h8CkCyMnNZHRoOKKUt7bFNZ7xXaeV8NghmXUGIXPvqmUIjkzC5z+kNzYUsR6bPb
cx6UJRYkf73IPyd983R57YW/E1mK9Vbz/6rCnfipqcpzHOpOB+n7aniecoe0bYOD
KMHLtySu5IhYow1aNnJFdjKSZakVfnBqD1bgbIe+mCFGOUvlASux7TplreZkL0ST
udY8m7cPyAATI/nL/FIR9cYcxVPJa68+oXeuu+iqTFuPEEAnUwvup+5njS9+u7cm
0ke7hwJwIeGfDjdjkybgacCkf1HWXCkpayfubDpxdpmPf9aI8K1rmb+woHwo9sGs
rstVQVMhg8HpYJnk2UiYGWUAg2C79RC4ZUT3LVDKUkGh69fpbvhTyyP2TqCBNIW7
4fzCH9HBEmgrBnqcm7Z+s5MTuiZfuD5S3a5KAEM8vE0kvGnv/wJWOxfz51L/1Cd0
4HNK5fneKpCx302+5D/ijPdgMF6zQ37wz9Rbe4nGZ2ZkR5L0zcPDe1WeYLy8sNSg
WbSGZw8byksVNMXM2b9H
=RhIM
-----END PGP SIGNATURE-----

--G3juXO9GfR42w+sw--
