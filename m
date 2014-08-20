Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaHTTOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 15:14:50 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:53158 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaHTTOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 15:14:48 -0400
Date: Wed, 20 Aug 2014 22:14:38 +0300
From: Johan Hedberg <johan.hedberg@gmail.com>
To: linville@tuxdriver.com
Cc: alex.aring@gmail.com, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2014-08-20
Message-ID: <20140820191438.GA16364@t440s.P-661HNU-F1>
Mail-Followup-To: linville@tuxdriver.com, alex.aring@gmail.com,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

Here's a set of patches for the 3.17-rc series.

It contains a connection reference counting fix for LE where a
connection might stay up even though it should get disconnected.

The other 802.15.4 6LoWPAN related patches were sent to the bluetooth
tree by Alexander Aring and described as follows by him:

"
these patches contains patches for the bluetooth branch.

This series includes memory leak fixes and an errno value fix.
Also there are two patches for sending and receiving 1280 6LoWPAN
packets, which makes the IEEE 802.15.4 6LoWPAN stack more RFC
compliant.
"

Please let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit 77b2f2865956b7573f9b040db7a9f808b434acd1:

  iwlwifi: mvm: disable scheduled scan to prevent firmware crash (2014-08-14 19:47:41 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git for-upstream

for you to fetch changes up to f161dd4122ffa73e4e12000309dca65bec80d416:

  Bluetooth: Fix hci_conn reference counting for auto-connections (2014-08-20 21:57:39 +0300)

----------------------------------------------------------------
Alexander Aring (2):
      ieee802154: 6lowpan_rtnl: fix correct errno value
      ieee802154: 6lowpan: ensure of sending 1280 packets

Johan Hedberg (1):
      Bluetooth: Fix hci_conn reference counting for auto-connections

Martin Townsend (3):
      mac802154: fixed potential skb leak with mac802154_parse_frame_start
      ieee802154: mac802154: handle the reserved dest mode by dropping the packet
      ieee802154: 6lowpan: ensure MTU of 1280 for 6lowpan

 include/net/bluetooth/hci_core.h       |  2 ++
 include/net/netns/ieee802154_6lowpan.h |  1 -
 net/bluetooth/hci_conn.c               |  8 ++++++++
 net/bluetooth/hci_core.c               | 14 ++++++++++++--
 net/bluetooth/hci_event.c              | 17 +++++++++++++++--
 net/ieee802154/6lowpan_rtnl.c          |  4 ++--
 net/ieee802154/reassembly.c            | 15 +++------------
 net/mac802154/wpan.c                   |  6 +++++-
 8 files changed, 47 insertions(+), 20 deletions(-)


--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT9POeAAoJECQj9vv5qNQSfgUP/3+HHLSsXC9hy7Hp3pnwFHjs
lqLo52Zb3gFooFJpsJNuQXjjg4/NSBiBhy5fIKl2q8Ctfns/d/ayeLEA6qeX0q9J
hFt4HkNa+pufKrg0h9ds9IUOfvlJOLzdUHY2i9MAxvFTeU01rs1p4o5lme8OUwyl
s9nWhhmb0Bk9BfSXMfh19S3ZF4mneqRBX4pYIf1XIcFaSe0uqcNburZ+I0Cjp62Y
zdGQxsFmI3AR6dYV/jn9R10cayB4/OVCHtPERij4PDYHuNarxvzVNn5mQFMfoEyD
OWEdzGbQrp58EIQ2SJqZPf/T3csex8qIfnW6yBCQ/1HOMH6aeLE4o9kCvDsgtN82
b8N4dH6xyZ9lmVLk9AgCXn9jq1Sdq5G53TMleyuuIS6g3tIsvixtuIJc7tAMKPFS
wuhBc2AOtkcu/2fyAwlh4yd7PxKW8kflt1aq2Bq3DnDk8kJ5ZR0TLhPzsrM4Su2w
KH+4stmtttoDHu1gYHC2Oo7UFbGuFKidOx9d3+soH0UGHwkr2/jHHv2cjgFjkMBO
v5vbsT/Er6SQbhpX5d7DmaPoLUUPJ8SzyzRlp+7o4WHpu1m1C8HaVCXLtGEyI70D
Ct3e72hgbS6o/Z9nW9fQnMx7OkA2awO1Gbmc63IJnHVwJwJ9kepW6ZhC74fNXJzq
QtobOojfS8pOYEdv8MSO
=gBqN
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
