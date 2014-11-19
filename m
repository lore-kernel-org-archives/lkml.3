Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbaKSNmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 08:42:01 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:51159 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbaKSNl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 08:41:59 -0500
Date: Wed, 19 Nov 2014 08:03:22 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Linux PM <linux-pm@vger.kernel.org>,
        Caesar Wang <caesar.wang@rock-chips.com>, Wei Ni <wni@nvidia.com>,
        Mikko Perttunen <mikko.perttunen@kapsi.fi>,
        Alexandre Courbot <gnurou@gmail.com>, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        lm-sensors@lm-sensors.org, Rob Herring <robh+dt@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCHv4 1/1] thermal: of: improve of-thermal sensor
 registration API
Message-ID: <20141119120320.GA10180@developer>
References: <1416321575-18348-1-git-send-email-edubezval@gmail.com>
 <1416321575-18348-2-git-send-email-edubezval@gmail.com>
 <20141119092139.1965e44e@amdc2363>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <20141119092139.1965e44e@amdc2363>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hey Lukasz,

On Wed, Nov 19, 2014 at 09:21:39AM +0100, Lukasz Majewski wrote:
> Hi Eduardo,
>=20

<big cut>=20

> >  }
>=20
> On which branch should I apply this patch?
>=20

This is based in my -linus branch. That means I will send this for the
next major window, not rc. The branch -fixes of thermal-soc include
patches for rc windows.

> I've tried to apply this patch on top of newest linux-soc-thermal/next:
> git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.=
git
> branch: next
> SHA1:4027494124fd88e5d51127eebba315de5d8d57c8
>=20
> Unfortunately, it conflicts with:
> "thermal: fix multiple disbalanced device node counters"
> c2aad93c Vladimir Zapolskiy

The -next branch is intended to contain patches for linux-next testing.
I include the content of -linus and -fixes together to be tested in
linux-next.

However, as this patch has not been merged yet into -linus, I haven't
rebuilt my -next branch.

>=20
>=20
> --=20
> Best regards,
>=20
> Lukasz Majewski
>=20
> Samsung R&D Institute Poland (SRPOL) | Linux Platform Group

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUbIb8AAoJEMLUO4d9pOJWkwgIAJVX3QS2UiIRUV9KeE20LzYW
cMcbbGVEbqn6Vib/XW9zarPN5djBUTmXU+qTUM6Z4794uRME53/rXtUaCwbocKtZ
fTjHnVMDHWQ//LDdXkwSgrfhbG8iYklo8MD4T6Er3Joec3BMv1JCo/GcM9n1d2Nr
1dm6CiKWIbLKAim+3kZhCQmEFLXIWB5lH9ZAPTCLfn9jXN156UHPUc5tKij01S9D
hIzhFFJ2mx7oQpiW3Ecj2Pq7zxHsvGTibi5RlWA3RcBTqYA3rAi50DTF0HWXvtCq
ydWgShJxpTGd/oKjyvyEd+6u9PstW8mxFpQ4zG3zcNFlLWMy7HwO85hVBlTfGXc=
=qst+
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
