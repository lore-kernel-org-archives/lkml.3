Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbaCGPpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:45:38 -0500
Received: from sauhun.de ([89.238.76.85]:54390 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299AbaCGPpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:45:35 -0500
Date: Fri, 7 Mar 2014 16:45:32 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel@vger.kernel.org, khilman@linaro.org, arnd@arndb.de,
        linux-sh@vger.kernel.org, horms@verge.net.au, john.stultz@linaro.org,
        olof@lixom.net, Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH V7 0/3] clocksource: Consolidate SH and ARM mach-shmobile
 Kconfig bits
Message-ID: <20140307154532.GE28943@katana>
References: <1392897287-11614-1-git-send-email-wsa@the-dreams.de>
 <5305FA60.7040904@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r7U+bLA8boMOj+mD"
Content-Disposition: inline
In-Reply-To: <5305FA60.7040904@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r7U+bLA8boMOj+mD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

On Thu, Feb 20, 2014 at 01:51:44PM +0100, Daniel Lezcano wrote:
> On 02/20/2014 12:54 PM, Wolfram Sang wrote:
> >This is V7 of the SH and ARM mach-shmobile clocksource Kconfig consolida=
tion
> >series. It is a rebased version of V5 on top of timers/core. This series=
 is not
> >just an optimization, it also makes it possible to enable the clocksourc=
e for
> >the r7s72100 platform. I successfully tested the patches on r7s72100 and
> >r8a7791 platforms. The branch can be found here:
> >
> >git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git renesas/rewo=
rk-clock-config-for-daniel
>=20
> Thanks Wolfram,
>=20
> applied to my tree for 3.15

I see the patches in your tree, but not in linux-next?

Regards,

   Wolfram


--r7U+bLA8boMOj+mD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTGemcAAoJEBQN5MwUoCm2K2YQAKcXb3hQPG9uqX3bIlBcZ4nJ
pL5M2cFKx9z+BoTAkwyvwP9/zJOA/ifZhbfrTUpCtzYPVh+A3xe57qmQzmFLeeMw
26lpW2Q5O5GP5t6+nJlV9uuPTTadpDS/+ud+79ue5E3rhLKEovmKGMvBJCnm9MXM
n0aNXeTUjnj+8ebH5/D5ZmwC9dRbceiHhOwgVxCKF3zdCGLcIVRWsXIsQEcE2weg
ZsqOgxqbjuT1xFta1gPvUSYWgCgrMiEIkrle91spq6ZUhK8dHGMlW1Plm42WvfXW
xcI5yaYoiSOodRly1I0TJvDnwoj5XEwyExayMhTsqFYk4uKKsUsETiZHkCRGVlGP
+Nz/6NoecjQ8IcBrwtiKSa18kAo+1W6SnLavrmDdD2gDxJVNu7qhWRE/ItvktGxy
wakPM6/y+AmdR5OLyBtOugWGMmMqV83mxLEdfxs9Ux/eEGeOZLsL7Kp/rUiIyWPV
5yQ05UdL/DWLykmims0tfog3m7/8LBWmUvlQZ4DeNIvwgxZYIzaRUuVm/VazIOZw
+G4gD/ntvukto/LNxa2z37Qt3/sJ+ZvRf3isrShYAw4CMkyasumYI06pCq6KbMxS
xEju5h+L+jZEfi/LB2INSckmOHNc+QQc5bUjHJ7G6B2N4X0nioe2rQ7gCsgI+RpT
6krOjsQrPZ5ucD1prJrp
=a2Vn
-----END PGP SIGNATURE-----

--r7U+bLA8boMOj+mD--
