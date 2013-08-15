Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab3HOLJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 07:09:50 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40107 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903Ab3HOLJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 07:09:43 -0400
Date: Thu, 15 Aug 2013 12:09:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20130815110919.GZ2401@sirena.org.uk>
References: <1376521502-9370-1-git-send-email-khilman@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+DRhDX4TDhSuvTBU"
Content-Disposition: inline
In-Reply-To: <1376521502-9370-1-git-send-email-khilman@linaro.org>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: Add another missing header for !CONFIG_REGMAP
 stubs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+DRhDX4TDhSuvTBU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 14, 2013 at 04:05:02PM -0700, Kevin Hilman wrote:
> The use of WARN_ON() needs the definitions from bug.h, without it
> you can get:

Applied, thanks.

--+DRhDX4TDhSuvTBU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSDLbcAAoJELSic+t+oim9RdQQAJ0oTPRRe3WsJwoXkhBD8yGf
vuWmZCDvN2DL73NjEdFJhgUEhqMJGkcdsM0MNf2Y+cpbiumsKq9V60WZoAcNVp0S
AzXZXPY3mv3ucjl0ZVaEMnkHJTWWeT38f99mYZGHuOfKf/l2ZMwFJ2jayFcOvASE
NGDoslAy578V+rPj3UuJFbcXPCr9xLQFRB86qSxyqRZseHDfBpSbQU6M8cHSs1UE
DC5yB8ykWdXXy07UAKlssQAqpLFeGqJ/AGX1FyPjXo1vQ9Y0GOOA0XiCtNq3j6tc
ZN4d3HwP9a4w5odPZmRAiVMJ95n5piAzYxIngrifRGIuLkVukbmRqx7hd5OOPdVc
QtEouac7UyB2AaI8cXQsb7+wtTF2BxbTYejsx5K3ogS3iSJlWct0QOJcNQENuqbv
Byo8/sVSeg0y6zzQ/RsPUyGWwvch/+6NJwXOze0VjTRYGH1lUb/CFdTQ+JExqHIu
fuze4mU0LM9MaIJRIYkKqHrYWJBIk4xY89o7xQcRdkY1S6/IrohSdF4l+02ZP/tn
UdQMdD8GvEcUvcvvvmkJK6sNBZ5HoNF9dSMdRB/sR5TuglVoLxF+qWpXNuzIbLOZ
1NaGQ4DDB9nPn2dkFu4yUn1F/GjbkLEuhUIbZwF5NRMWOrSqyOPdU5gkrvVNhITn
/n9SJCXZHxu+eXoEK4xx
=HgpN
-----END PGP SIGNATURE-----

--+DRhDX4TDhSuvTBU--
