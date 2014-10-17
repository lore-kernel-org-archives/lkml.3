Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbaJQKS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 06:18:26 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:32931 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaJQKSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 06:18:24 -0400
Date: Fri, 17 Oct 2014 12:17:34 +0200
From: Mark Brown <broonie@kernel.org>
To: Gyungoh Yoo <gyungoh@gmail.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, jg1.han@samsung.com,
        cooloney@gmail.com, lgirdwood@gmail.com, jack.yoo@skyworksinc.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Message-ID: <20141017101734.GB1820@sirena.org.uk>
References: <1412657745-7812-1-git-send-email-jack.yoo@skyworksinc.com>
 <1413179262-27636-1-git-send-email-jack.yoo@skyworksinc.com>
 <1413179262-27636-8-git-send-email-jack.yoo@skyworksinc.com>
 <20141013103512.GJ27755@sirena.org.uk>
 <20141014011112.GB2751@jack-ThinkPad-T520>
 <20141014075606.GN27755@sirena.org.uk>
 <20141017091950.GA3233@jack-ThinkPad-T520>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4SFOXa2GPu3tIq4H"
Content-Disposition: inline
In-Reply-To: <20141017091950.GA3233@jack-ThinkPad-T520>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RESUBMIT PATCH v4 7/8] regulator: sky81452: Add compatible
 string for device binding
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2014 at 06:19:50PM +0900, Gyungoh Yoo wrote:

> Wow. I understand.
> I missed .supply_name. I think I need something like
> below, before devm_regulator_register().

> 	config->supply_name =3D init_data->constraints.name;

> I will resubmit it.

No, not supply_name (though you really should be initializing that
anyway) and you definitely don't want to set supply_name to something
=66rom constraints.  The supply_name should be the name of the input pin
that supplies power to the regulator.  I was referring to of_match and
regulators_node.

--4SFOXa2GPu3tIq4H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUQOy+AAoJECTWi3JdVIfQwDIH/0V5M79k7yEMjvBYqBmQitzK
JdSGk5SMX1gnp9i2GwOTJrHBegdHF9asyfyskW9j7iNeNUL2pKdCm4YgFsxiilhq
NlCdt8CJmB0oxznoHQZ4yKT7vOr1FRI/kFp/JEZAodY885Tqd0cvwcVAlL9L9wgF
IBVnfrmNngxfAQtFn+1BKwB2zJKYivfR2fCwwbmH6qcpRRZPDRahNVQFUdm4tZrv
ecaNLC+gDp86lbF+yEP57ZbOgQK/z+iv5iyLzgLTLUPF4nXCK3Uw0K3bpuZPsFZg
6yMX7cu1lXgzyuf6A1Z3RjHk01XKqjI24RkhfzUyrxoTCTSge+bu+kqXSJe/dfs=
=h7Eo
-----END PGP SIGNATURE-----

--4SFOXa2GPu3tIq4H--
