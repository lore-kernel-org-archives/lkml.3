Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab3JBPeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 11:34:37 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:43750 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab3JBPee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:34:34 -0400
Date: Wed, 2 Oct 2013 17:32:46 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>
Subject: linux-next: Tree for Oct 2
Message-ID: <20131002153245.GA4273@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

I've uploaded today's linux-next tree to the master branch of the
repository below:

        git://gitorious.org/thierryreding/linux-next.git

A next-20131002 tag is also provided for convenience.

No new conflicts today. i386, x86_64 and ARM default configurations did
build fine. Well, the same issue on i.MX is still there, so I added the
patch on top of today's linux-next tree so others won't have to deal
with it. I'm assuming it will make it into the i.MX tree eventually.

One small change, I have removed Joern's bcon tree as per his request.
Furthermore there's now an rr-cache branch in the tree linked to above
which contains an orphaned branch with the resolutions recorded in the
.git/rr-cache directory. There's also a new script Next/rr-cache which
can be used to setup the .git/rr-cache directory from an rr-cache branch
and manage it using git. In a nutshell: it's a wrapper around git with
extra handling for the "init" command.

As I already mentioned, Mark has volunteered to do the linux-next tree
for tomorrow and the day after that. I should be able to resume doing
them on Monday.

Thierry

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSTDydAAoJEN0jrNd/PrOhV3UP/Avm++u8WEL01vja6vXqah9T
PNKi+WiLs+p6Y19ggzIbLlurn/VDHB3T1FMFz1gsidjasXeAKfPtI8Afpx/aZ0r3
Nwvxkp3Ub3N419ZVkcuB/1RehbKRXuNz3DkDyvcral4h/BkHk4lNiKTrdv32eqlE
Bkx7QQC4MoVFKek9qyZ4/iTVQ7s8ceC/Gj0vndN40ZzLsHupRV3MgpyDlWWE9By8
GXJmTiL1w94eDTO+WVS72XRdyIpW6DoCkID5iH5Mj1MFd33iMlRKLWlq1efQyN4J
UbSC3Kg9vwEYotpcxN/X2kbG4YYNZvStTre7sVrm4QqSsOexbz+4hCrByfhnTDsL
OM5Dxrz8ti8x7zla9DGeDr0phfowlWhLDeVLxmICbvD6P28rboHYMLnba6sAj2Ru
EQomQpbn+DLvTJJKXXkv7VcoTiFrkZdmxbSX28Owgc7QXQnMp2Ru0z1ei1iJm54F
V1Y9L7VOk8M4hywdMl+fflLuHjvKuUTO4sh+R1cQzOi73cDXLgD6kiX3VSa0VcxW
4A5eFUSyHR6K0jiZEE6auHmu8s0ayjdcoqygieFeLEAxiXOWMfcoieuCY1RyaP3D
TBaw2WnxGu9q0zxTLrfd4aUI1+9TydY2ae1Y3vWR3Iq/ssLttwQCwX7CG1Sfu22w
pvwe3Ph7uKFwKF9fdLZQ
=tX1W
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
