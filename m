Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbaK0KgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 05:36:18 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:63022 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaK0KgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 05:36:15 -0500
Date: Thu, 27 Nov 2014 12:36:06 +0200
From: Johan Hedberg <johan.hedberg@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2014-11-27
Message-ID: <20141127103606.GA11964@t440s>
Mail-Followup-To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

Here's one more bluetooth-next pull request for 3.19:

 - Minor cleanups for ieee802154 & mac802154
 - Fix for the kernel warning with !TASK_RUNNING reported by Kirill A.
   Shutemov
 - Support for another ath3k device
 - Fix for tracking link key based security level
 - Device tree bindings for btmrvl + a state update fix
 - Fix for wrong ACL flags on LE links

Please let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit a86c02ea38c53b695209b1181f9e2e18d73eb4e8:

  Bluetooth: Add support for Broadcom BCM20702A1 variant (2014-11-18 08:32:14 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to f6af675ef5489c69fc3d4faf8c6f477df3cbf8b9:

  Bluetooth: Automatically flushable packets aren't allowed on LE links (2014-11-27 12:12:27 +0200)

----------------------------------------------------------------
Amitkumar Karwar (3):
      Bluetooth: btmrvl: add DT bindings documentation
      Bluetooth: btmrvl: add DT-bindings for gpio-gap
      Bluetooth: btmrvl: update hs_state in interrupt handler

Dmitry Tunin (1):
      Bluetooth: ath3k: Add support of MCI 13d3:3408 bt device

Johan Hedberg (3):
      Bluetooth: Fix setting state back to TASK_RUNNING
      Bluetooth: Fix setting conn->pending_sec_level value from link key
      Bluetooth: Convert link keys list to use RCU

Steven Walter (1):
      Bluetooth: Automatically flushable packets aren't allowed on LE links

Varka Bhadram (2):
      ieee802154: fix spelling mistakes
      mac802154: remove unnecessary if statement

 Documentation/devicetree/bindings/btmrvl.txt | 29 +++++++++++++++
 drivers/bluetooth/ath3k.c                    |  2 +
 drivers/bluetooth/btmrvl_main.c              | 51 +++++++++++++++-----------
 drivers/bluetooth/btusb.c                    |  1 +
 include/net/bluetooth/hci_core.h             |  1 +
 net/bluetooth/hci_core.c                     | 39 ++++++++++----------
 net/bluetooth/hci_event.c                    | 51 +++++++++++++++++++++-----
 net/bluetooth/l2cap_core.c                   | 14 +++++--
 net/ieee802154/6lowpan_rtnl.c                |  2 +-
 net/ieee802154/netlink.c                     |  2 +-
 net/ieee802154/nl-mac.c                      |  2 +-
 net/ieee802154/nl-phy.c                      |  2 +-
 net/mac802154/iface.c                        |  8 ++--
 13 files changed, 143 insertions(+), 61 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/btmrvl.txt


--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUdv6WAAoJECQj9vv5qNQSPXQP/jckknbn5iFKfmmIGQ30cGZ2
204iVLAt80f8s7k6Vv6+AJHq8P75vvuRjaNrIoOV5c9Liwax6jOEiuYNIIg5ln5e
YqvrrB6fa5MmIVcbooWcs8zLVOEllOmZ7ThB+CmEPj2GDPqlXXgiB3JiNiyxuLwS
jANFkMGuizt7tEW1V0/s+tjRTaxqERx2aWk8e1wXiP6XApFvlUJvU0vTZ6qArQ+9
rh+au7+Zcjb/72e4akhAuL/rbhQS/7H1shVyGnzxRJxlGFNrAp1gDh3mJgMlFtmJ
WHv5AfoNBoYjTnqRuSQEfhbD8tjS/0v1yK0v4KI42efdr/gkzINuRZRH+HqAXP6E
thgmBfsL4jh/cu56bgux06tTJ91IWoJL+TujT5hEKOE0SqSCjB7gfyWjYz3/01Gf
OMHcuwlWyo/bEZuuf/KxDNgw/6dMeK6COu61hf0gi++Fo+i0O32QWL1K/Zrr300x
DtTHT2LPmjCbk06E0T55G8ezme6dsTZKIvU7Rb45V/FDR4kmf891J/gEn44WMPdk
HBEDb5mblHyIRc48BysY6FkaDMF8Yq0QIqVU+1x0EyEbds4w0M7YYKxw+73Fycxu
LzRWu3/N+jLlRGIuX1OQMJ3j2x0h+skoDpbTLc9IR9LW/ELb2OjjBj/JdQ5dUqsw
C70ymmKUNL4RCue+D1Ws
=rjl9
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
