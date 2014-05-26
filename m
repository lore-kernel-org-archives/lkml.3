Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaEZVla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 17:41:30 -0400
Received: from mail-yk0-f172.google.com ([209.85.160.172]:59916 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbaEZVl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 17:41:28 -0400
Date: Mon, 26 May 2014 18:41:22 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2014-05-26
Message-ID: <20140526214122.GA2034@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

Some more patches for 3.16. There is nothing really special here, just a
bunch of clean ups, fixes plus some small improvements. Please pull.

Thanks!

	Gustavo

---

The following changes since commit 22e70786413ed05950207eda7be420c280b776d7:

  Bluetooth: Remove hci_h4 unused defines (2014-04-24 11:55:26 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to d7b2545023ecfde94d3ea9c03c5480ac18da96c9:

  Bluetooth: Clearly distinguish mgmt LTK type from authenticated property (2014-05-23 11:24:04 -0700)

----------------------------------------------------------------
Andrzej Kaczmarek (8):
      Bluetooth: Store RSSI for connection
      Bluetooth: Store TX power level for connection
      Bluetooth: Add conn info lifetime parameters to debugfs
      Bluetooth: Add support to get connection information
      Bluetooth: Avoid polling TX power for LE links
      Bluetooth: Store max TX power level for connection
      Bluetooth: Add support for max_tx_power in Get Conn Info
      Bluetooth: Add missing msecs to jiffies conversion

Johan Hedberg (8):
      Bluetooth: Add support for SMP Invalid Parameters error code
      Bluetooth: Make SMP context private to smp.c
      Bluetooth: Fix setting initial local auth_req value
      Bluetooth: Remove unnecessary work structs from SMP code
      Bluetooth: Rename smp->smp_flags to smp->flags
      Bluetooth: Update smp_random to return a response code
      Bluetooth: Update smp_confirm to return a response code
      Bluetooth: Clearly distinguish mgmt LTK type from authenticated property

Libor Pechacek (1):
      Bluetooth: Convert RFCOMM spinlocks into mutexes

Marcel Holtmann (1):
      Bluetooth: Increment management interface revision

Petri Gynther (1):
      Bluetooth: btusb: Add Broadcom patch RAM support

 drivers/bluetooth/btusb.c        | 155 ++++++++++++++++++++++++++++++-
 include/net/bluetooth/hci.h      |  21 +++++
 include/net/bluetooth/hci_core.h |  11 +++
 include/net/bluetooth/mgmt.h     |  15 +++
 include/net/bluetooth/rfcomm.h   |   6 +-
 net/bluetooth/hci_conn.c         |   3 +
 net/bluetooth/hci_core.c         |  64 +++++++++++++
 net/bluetooth/hci_event.c        |  61 +++++++++++++
 net/bluetooth/mgmt.c             | 236 +++++++++++++++++++++++++++++++++++++++++++++++-
 net/bluetooth/rfcomm/core.c      |   2 +-
 net/bluetooth/rfcomm/tty.c       |  20 ++--
 net/bluetooth/smp.c              | 153 +++++++++++++++----------------
 net/bluetooth/smp.h              |  30 +-----
 13 files changed, 653 insertions(+), 124 deletions(-)


--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTg7UCAAoJEPs3PUX4s20oMQ0QALApbMjC4Ylk5+WKaRyuRIr5
fEbkbe9Mnvn5IOVq3SDJamQ9CMf6+4b3J0qYSs4yug1435AbLpR29Q1rAwCNhJ50
WdbzOI7VOfRod/mpB8TzbCxLH2X0/RaKNXFW0tW9VET3mRXvTPJH6OS+YKRIJ+N8
tHfhwxy7HXHdFSszK/AnL9CLVv8b30lcKtSaoW2DDZ76AzKnNneVMKzLvUO5ICVG
0SzBo96c/ci9weE1Edp5PG7upl15AqjMVizJYrXnaQ6+CGATIIp1SxaQEU4vXNSN
dEckVpgUpCM1eXHziB9Yf70r1js31/c9QAVEoavmC/9c5Q6rJ2g1JcMZN8vNHv55
JVMsfsGpMXenDNX+uzfMxYrpKn05PPqzyEAlKit8Hw3DXZEYD1azKqHID4uyBfVo
YI0D/Xoef8ZA1/Ctu1tKGnOnpn+smcEoukFRqKp7+Rve+aOKXqnjW1zyHJGci8cM
/ctynJh73UBz/NUwQO6Os+W4vJ1NrPnFgVuJs8R+fVLa1PF5quDe+tH0F7MjISQn
J6VECehz8VbwBjaz9miedzA7qM7V8CiNo1ju8gqu/6eyUJtiJh7Tdns0QwRGuJH0
OFuZUMYfKijxe7pooKcx4kiB+eswm2FYdNk3YnKL66i0SqYhDOLjE+dYUdvZ8IEW
nKpzpLC+L7PhfgebJwhU
=XSPz
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
