Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab3EXSY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 14:24:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757284Ab3EXSY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 14:24:26 -0400
Date: Fri, 24 May 2013 11:24:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.47
Message-ID: <20130524182425.GA3173@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.4.47 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 +-
 drivers/gpu/drm/radeon/evergreen.c       |    4 ++--
 drivers/gpu/drm/radeon/radeon_ttm.c      |    2 +-
 drivers/gpu/drm/radeon/si.c              |    4 ++--
 drivers/hwmon/abituguru.c                |   16 ++++++++++------
 drivers/i2c/busses/i2c-designware-core.c |    3 ++-
 drivers/media/dvb/mantis/mantis_dvb.c    |    6 ++++--
 fs/btrfs/ioctl.c                         |   10 +++++-----
 8 files changed, 27 insertions(+), 20 deletions(-)

Alan Cox (1):
      media: mantis: fix silly crash case

Gabriel de Perthuis (1):
      btrfs: don't stop searching after encountering the wrong item

Greg Kroah-Hartman (1):
      Linux 3.4.47

Mika Westerberg (1):
      i2c: designware: always clear interrupts before enabling them

Niels Ole Salscheider (1):
      drm/radeon: Fix VRAM size calculation for VRAM >= 4GB

Wei Yongjun (1):
      hwmon: fix error return code in abituguru_probe()


--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRn7BZAAoJEDjbvchgkmk+KYsP/153C2f7rmoN9IpOySPswIGi
uKy77gvNKO0RUiAPFWAvmj4Vij0MbvqgYLbDMtvCJ5wc7Z17TYcjBjrXr/fPP42b
aLg3/WaYK+Q0ZUfvHWmtji+i1GRnPzX6v8d4imbOuHb8HdyUsw2cUOFBOAjkC2VV
GV/+z3/hmG8i3uvJ9QjoCQn0JXgWWtLWq51yUP/o7EdcArs5qd/DnMyE/kRyu4GN
S5A4fhDbVtRgsYAAts246gXjoblPq82vDa6AP9Cu8ZfRu4bVPZ2iOcEulTs+TGfR
Z7mRJh1vXSKI/+wZyyC/zyrZjXxx2h0/1lo4+dgvywDs7xGiesz/OmFZHHt9SLRX
H/Y6m8rWoR8xeYE+LTe9N1t4S3GnB8rfebiSrQe2oX2NFebVy6jWNnaaaM1B0Oih
t2br/EgW3UhAEvaT+LreKHaBZ1Sbh69xyI41dULxrR1aB3MiSMrIdES9zrWdkx7o
NorlAWtal/sr20HuCZ4/N5s6ef0E0ypTunVmPjtgFocx9hfYb67Ag0y6oF7uw4Aj
iCji4srYZUplDyDpCrqr48cU1zKHfMwiNU09N39WYhK83p0FY73tNQZhllQ9V33B
RtIaZ/UTOHHShks3gckZEY3QSL/A27rr8bUNx44BBDpk9vtE1XveJbQ3PgmZVXfb
lhtXmDZo+Rcf4X78vdkA
=Gfso
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
