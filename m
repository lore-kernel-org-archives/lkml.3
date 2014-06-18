Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966382AbaFRMVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 08:21:39 -0400
Received: from sauhun.de ([89.238.76.85]:53267 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966305AbaFRMVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 08:21:38 -0400
Date: Wed, 18 Jun 2014 14:21:34 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.16
Message-ID: <20140618122130.GA3108@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Linus,

here is a pull request from i2c hoping for the "new driver" rule.
Originally, I wanted to send this request during the merge window, but
code checkers with very recent additions complained, so a few fixups
were needed. So, some more time went by and I merged rc1 to get a
stable base. Please pull.

Thanks,

   Wolfram


The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-next

for you to fetch changes up to f0b1f6442b5090fed3529cb39f3acf8c91693d3d:

  Merge tag 'v3.16-rc1' into i2c/for-next (2014-06-17 14:37:31 +0200)

----------------------------------------------------------------

Boris BREZILLON (3):
      i2c: sunxi: add P2WI DT bindings documentation
      i2c: sunxi: add P2WI (Push/Pull 2 Wire Interface) controller support
      i2c: sun6-p2wi: fix call to snprintf

Dan Carpenter (1):
      i2c: rk3x: add NULL entry to the end of_device_id array

Max Schwarz (1):
      i2c: rk3x: add driver for Rockchip RK3xxx SoC I2C adapter

Wolfram Sang (2):
      i2c: sun6i-p2wi: use proper return value in probe
      Merge tag 'v3.16-rc1' into i2c/for-next

 Documentation/devicetree/bindings/i2c/i2c-rk3x.txt |  42 ++
 .../devicetree/bindings/i2c/i2c-sunxi-p2wi.txt     |  41 ++
 drivers/i2c/busses/Kconfig                         |  23 +
 drivers/i2c/busses/Makefile                        |   2 +
 drivers/i2c/busses/i2c-rk3x.c                      | 763 +++++++++++++++++++++
 drivers/i2c/busses/i2c-sun6i-p2wi.c                | 345 ++++++++++
 6 files changed, 1216 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-rk3x.txt
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-sunxi-p2wi.txt
 create mode 100644 drivers/i2c/busses/i2c-rk3x.c
 create mode 100644 drivers/i2c/busses/i2c-sun6i-p2wi.c

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJToYRJAAoJEBQN5MwUoCm2WwwP/33wXICImx/rJhow7bXi62T2
oLvIDcnXo+EdpZTgrBRUTI73xPHU8DEK2suW7uTpCJohbj9pJho/n0OLWq3r36jH
Gre0ZjeV0PB83CqNZ02D4T70RxA455pEmIHOEBFw++KVOmEfjnxpWtBo9UpGioJL
3NXtNs4pe/Q30moR3y7TzLAL6V2b2jTwUyvy9qG8DxwWkZ0DLxnodlJ22kWmk/xX
RCKDLq4pT4TZdEEYlwppC2WBsQiQxhV56PmX33+KInY6XEeD+L4YIh+PTzMKwiud
3SSTzasGIjHfxESrF0l2mV05mHkb12YICNbN2Wm5Oy/bzMAApaywZhhSOv7ByV9T
iaSADefdWxOPVPrhfZze2fFWactaX8DD4r7ZMi8KYL6x7Yvvo4Qz2AFbgpR7K2jY
d0ZK47rrd7ZMKKcSPIUiVHbuDq7EKlaettCLPhUN4Ub1V123OaFX1pPij1hCmniQ
ETJQrS8FxaMVmctCYTUuM+c+9doNAZAxd/Evv9AV8ZUnETbLFn9wb3xvc623rZPG
pRUq1LPNd9k9A9Gn/9Eh/Ip/eI34ObujIKGOPbv1LIhlvvjRq0pXVQ0Aig4ZE/Ix
+We/RDu23uQLReuoVOe/cWVWAneyynWPU075nh4vFP2bCCAUYhuc0x1lyXoUH3XM
U3Y+rOmuHksanb2frboR
=2HXT
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
