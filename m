Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934300AbaFSR47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 13:56:59 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49407 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934267AbaFSR44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:56:56 -0400
Date: Thu, 19 Jun 2014 18:56:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140619175643.GR5099@sirena.org.uk>
References: <1403164154-1362-1-git-send-email-acourbot@nvidia.com>
 <53A308C8.2070004@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CFQN6Iaevez+I9dc"
Content-Disposition: inline
In-Reply-To: <53A308C8.2070004@wwwdotorg.org>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ARM: tegra: TN7: relax some regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CFQN6Iaevez+I9dc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 19, 2014 at 09:59:04AM -0600, Stephen Warren wrote:
> On 06/19/2014 01:49 AM, Alexandre Courbot wrote:

> > Remove the regulator-always-on property from some regulators that do not
> > need it. On recent kernels fixed regulators which supply is always on
> > fail registration.

> That sounds like a bug in the regulator core, which should be fixed there.

Please actually describe the problem you believe you are seeing - I've
seen no reports and I can't tell anything from what you've described,
nor can I see any obvious way that a regulator being fixed would have
any effect on its supply.

--CFQN6Iaevez+I9dc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJToyRYAAoJELSic+t+oim9c0oP/jiCLyF4BZVcp9FshcBaTixR
VRbJ0BhzWPP9eWvdQgm16bKv3f2oPe2jav/jwNXX3mob4eB4QUsWfwATdNDNZS1s
uh7GnZeG+buCVKR8VmVBDdfM43yzaOiJQf/uStBFVbS9Ib95GfhZGOH765L8Js02
NjdwHFr0KnWGRyqCWO/hBM61YFYmi4QZ4AHPONon1zV9WmxkkQ8nYLD80ABBVeXc
incGynisThTLtzhAwnz+8eS58sLoqH7/58CBnv6RfHAbvA+36P206fO4wM3SqCvH
sD4oFElO24v9bERI+Xsvf7P1Z+0TZ4idt44bZ8WbRpIoLi76uBn98VoIb4LdkBnl
+6oICmt2rpGJpt5gzJS2KYePahMQ/vdqwGyH5zCnNE5fKw1X7+S9IXPk7A7xFUGQ
9Ef2hQ4ak7bf2lgtb2c1Sb+p8bS6qtfEfY15rALjadJft2CVxgxd6NMHo2o/YpP4
IgTxtPYeaBybxT1olfJ6THQ+k+gHdFjk9M80NKGRQbI54gG5GoI0M67tnZPmFfZj
hLJxFRE6lhKtCTPS1JRCue06OW3tuYXASvbfTrdOOyz6pi4ExWodExLCs4AsEpB7
J/SZM0OenhkAhCgxXGub2emlEf/IpAQ9EVwffbPYAIkKExi+/m388iMGuQEwcIR6
gbYNAoJ0tic5WsOwq7qC
=AZsZ
-----END PGP SIGNATURE-----

--CFQN6Iaevez+I9dc--
