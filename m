Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbaC1KWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 06:22:38 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58729 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaC1KWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 06:22:36 -0400
Date: Fri, 28 Mar 2014 10:22:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, rob@landley.net,
        olof@lixom.net
Message-ID: <20140328102220.GU30768@sirena.org.uk>
References: <1395984022-8284-1-git-send-email-tushar.behera@linaro.org>
 <1395984022-8284-3-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kSOhxpxUsM1s2qz/"
Content-Disposition: inline
In-Reply-To: <1395984022-8284-3-git-send-email-tushar.behera@linaro.org>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.45.252.252
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regulator: core: Add reg_ignore_unused to keep boot
 time regulators enabled
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kSOhxpxUsM1s2qz/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 28, 2014 at 10:50:22AM +0530, Tushar Behera wrote:
> Keep all regulators already enabled by bootloader on, even if no
> driver has claimed them. This is useful for debug and development, but
> should not be needed on a platform with proper driver support.

That's already the default on non-DT systems so I'd expect that if we
were doing this the code would be joined up with the code for that.  I'm
not sure this is a terribly good idea though - we already display a
message just before we power off the regulator and having an option like
this feels like it's going to encourage people to write bad DTs and tell
people to add this to their command line.

--kSOhxpxUsM1s2qz/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTNU1SAAoJELSic+t+oim9t1sP/0JVSZnIBmg+yC9AW3jnDywD
YZ2+e4aTsnyzNZoDCX1nf6OEzLTr3k5eJkDw8HDnqDjRTGsyVcH/IQxpvKUSd6ux
DpDwYHGQ9od+zfhxdgZ54pjOEAUvfS3HmX7i8XN+JoN635SDNfCti7jfnkKbWWUU
xfE9Im0usX5ynwuxx+Kz7HYC/km8yKMil80L1NY2w/kQUc3m1Z1W0RbvA02Tr+lY
n+JRKuQCUz0zuTVVrQMg9o4MRvijQX9FRHqpzZ1CrkxIqKiAji0kOgBzmUxts0Hv
BiKH0E2Bo7S1dGzCvZv79F7cNuYSffw6LVHRhqdiiTHg02rn+7L/eIsipTSWbEYV
PQXqSDAg15Dfm+GVWc/YR8OSXU4X5gUmPle5LwnryQP5A17Uhhi3qXl6QVPy+N9Z
Et28Mx7CXckK0NpHqNPvxnPHu7xnkL0Mi25s1Xsji5faxUbOqqblIZbfp1VqTMvL
5zC7H+KvQ3Bi/CuSygG6JvdyuBVKgsc5dL589nTOamJ7Ac9lEDvWMSdlJqZydRyB
HnjO+Hhf4egeNYZCMA9Z91Oawh69rI9+51le+LXuW3l7E0Cs40e3aaQ4p8uMK0Lk
tIKoVidMGm1PphPyNwfLDfMrikV0FkzGyn4FwzCpgXcBTNnr0TogTXT0wmE7YN4D
byfueDe7njl6BhE/i2jI
=lXPp
-----END PGP SIGNATURE-----

--kSOhxpxUsM1s2qz/--
