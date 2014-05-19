Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbaESOkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:40:08 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33237 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbaESOkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:40:06 -0400
Date: Mon, 19 May 2014 15:39:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140519143949.GW12304@sirena.org.uk>
References: <1400497954-1012-1-git-send-email-alban.bedel@avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gI747uL8Y9q6BT2f"
Content-Disposition: inline
In-Reply-To: <1400497954-1012-1-git-send-email-alban.bedel@avionic-design.de>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Fix the init of DT defined fixed
 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gI747uL8Y9q6BT2f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 19, 2014 at 01:12:34PM +0200, Alban Bedel wrote:

> When a regulator is defined using DT and it has a single voltage the
> regulator init always tries to apply this voltage. However this fails
> if the regulator isn't settable. So skip this step if the regulator
> doesn't provides any set method.

No, this means we'll just ignore the voltage someone tried to set.  A
bigger question is why someone is trying to configure the voltage of a
fixed voltage regulator in DT...

--gI747uL8Y9q6BT2f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTeheyAAoJELSic+t+oim9k18P/i6bqmzrwjFuGf2U0U7tLzwX
XE/XH5+1IUfbd5TIxbGxeUTiFbGAfb29at3xLFWmskHI5touy0R9yNZRE1A3LpEr
FkIxdJhgpOq4MIX3U61rCVEQXhzyU+XpfK5m5jy3unKDUOzviq2e1P/jb0Ou5woG
x2swsLIPvkm+vlHR3PDV3GJ3WXcw9JL7RxgaPRYcW8KHNePsY5Mi/aPNUe8SHvHo
gHErQ5j/GmoLG5Q9VW5gG/uRK/VEfoWecdt9vcN9AyDLAh9FhN2dmpYWdG3UKzuj
iq7bwKN8DM1piAvEaYyD9ZWS1EE46TmG+Khhn+6YBHVtGH5zf1pbA2vjpjzloqZQ
E4iZ3U+7NmkoDpHGeT8ULcTjr8EZu14B1JVSCbvTuCPCmvs9gOqeFqq9vq98h1G5
G0NNCJGBHJeW1lVlEsTrg9Gw4dP/Y8kQ3vo7eEAcrGzZGCjPH3gVR8heK0f/YdB+
pUthp3HMoN6Je2100AoBEhe/Af3neKA0+YRan/4dR+e5PAUdxds4ekgwfFGkDMQ3
Eg5n/LDiVLqT0pjfW3NzegVLX6G2Su4h5lJNT82gxAUruimJ4ojpDtx6/trdF5yQ
H5k0zYHTWd9d5C76DNdiiM3AmQvhaaMp9M2mGn8ngNKhLk2c3J5WLzkJ86Y+8/rO
IhdZkS/gDSttq6iLymQe
=EMd6
-----END PGP SIGNATURE-----

--gI747uL8Y9q6BT2f--
