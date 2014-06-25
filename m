Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbaFYOaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:30:14 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:49417 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756294AbaFYOaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:30:12 -0400
Date: Wed, 25 Jun 2014 11:30:06 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2014-06-25
Message-ID: <20140625143006.GA18018@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

A few fixes for 3.16. This pull request contains a NULL dereference fix,
and some security/pairing fixes. Please pull. Thanks!

	Gustavo

---
The following changes since commit 616a8394b5df8c88f4dd416f4527439a4e365034:

  rt2x00: fix rfkill regression on rt2500pci (2014-06-17 14:11:16 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git for-upstream

for you to fetch changes up to 48439d501e3d9e8634bdc0c418e066870039599d:

  Bluetooth: Ignore H5 non-link packets in non-active state (2014-06-23 18:22:48 +0200)

----------------------------------------------------------------
Johan Hedberg (3):
      Bluetooth: Fix overriding higher security level in SMP
      Bluetooth: Refactor authentication method lookup into its own function
      Bluetooth: Fix rejecting pairing in case of insufficient capabilities

Loic Poulain (1):
      Bluetooth: Ignore H5 non-link packets in non-active state

Lukasz Rymanowski (1):
      Bluetooth: Fix for ACL disconnect when pairing fails

Marcel Holtmann (1):
      Revert "Bluetooth: Add a new PID/VID 0cf3/e005 for AR3012."

 drivers/bluetooth/ath3k.c  |  2 --
 drivers/bluetooth/btusb.c  |  1 -
 drivers/bluetooth/hci_h5.c |  1 +
 net/bluetooth/hci_conn.c   | 12 ++++++++++-
 net/bluetooth/smp.c        | 60 ++++++++++++++++++++++++++++++++++++++++-------------
 5 files changed, 58 insertions(+), 18 deletions(-)


--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTqtzuAAoJEPs3PUX4s20oA54QAJD3YwZjoL5ZCb6CPz09/Fnf
pdWxKLc1qzoMtWnn5bWro/ujEZVSNrQ1GFYIPE7pkBxIKRveGiQ7qe21PyT4jPpN
RObiuFFyqpyTa8+VyXqdasMYbYKCd+K4QV1fGP0AOOOc0qosXcYl9CuerIx2v10H
1ecw59M/XMhBRqGx2zKXNshPNQQKc/33pDdwVqmh728+Lza9HQdZ2nJHJK6IFxT5
rteav6H5I7hQACcGyLcMCloLpa4TxOrj98Fq34NIDipzC6Tuue+6UBIOVLlOsjgI
WaK5DqzDleWDSwpxosmI52hcYrg5/OSE9jEevPH5V1X9za1AFCM+ISCIfdWugz2W
6RGeKKTBET+uL7agSLooIQfYBZ49jBbxlN0UeZcTPGFvNRLIcMAx6XoYesiPNViK
hsQNpwg51viyL8BauXfS4972rbcEh4SYfQhphD+EmBsV3GpVL1711yyZytiu+mLd
ECTzm62qc+1yEpE7hP5aBcYnFpce2wl8S4IA4MifZ6YwMMOOvXZg8agwiEdxWw5b
66EocXmdYH3eTfdNbfxQ75QWuph0dNqpuJAFYOQmN1l8TCzi9Yu1RYAJWqHI18Zb
e79yaJnZkUwbnXjawk4NjJm1IPwYmJ35VQrroAQ6Fg/XVPEdhAMvsGU1P4RTURAj
qyyKydv+5DIhUBy093BG
=ZbpF
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
