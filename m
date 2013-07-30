Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab3G3Mi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:38:56 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:53491 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab3G3Miw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:38:52 -0400
Date: Tue, 30 Jul 2013 13:38:48 +0100
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2013-07-30
Message-ID: <20130730123848.GE5975@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

A few fixes and devices ID additions for 3.11:=20

 * There are 4 new ath3k device ids=20
 * Fixed stack memory usage in ath3k.
 * Fixed the init process of BlueFRITZ! devices, they were failing to init
   due to an unsupported command we sent.=20
 * Fixed wrong use of PTR_ERR in btusb code that was preventing intel devic=
es
   to work properly.
 * Fixed race condition between hci_register_dev() and hci_dev_open() that
   could cause a NULL pointer dereference.
 * Fixed race condition that could call hci_req_cmd_complete() and make some
   devices to fail as showed in the log added to the commit message.

Please pull or let me know of any issues. Thanks.

	Gustavo

--
The following changes since commit 075163bbb0f51174359947e1bce84f5edb23f21e:

  ath9k_htc: Handle IDLE state transition properly (2013-06-24 13:52:52 -04=
00)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth master

for you to fetch changes up to 53e21fbc288218a423959f878c86471a0e323a9a:

  Bluetooth: Fix calling request callback more than once (2013-07-29 12:28:=
04 +0100)

----------------------------------------------------------------
AceLan Kao (2):
      Bluetooth: Add support for Atheros [0cf3:3121]
      Bluetooth: Add support for Atheros [0cf3:e003]

Adam Lee (1):
      Bluetooth: fix wrong use of PTR_ERR() in btusb

Gustavo Padovan (1):
      Bluetooth: Fix race between hci_register_dev() and hci_dev_open()

Jaganath Kanakkassery (1):
      Bluetooth: Fix invalid length check in l2cap_information_rsp()

Johan Hedberg (2):
      Bluetooth: Fix HCI init for BlueFRITZ! devices
      Bluetooth: Fix calling request callback more than once

Stanislaw Gruszka (1):
      Bluetooth: ath3k: don't use stack memory for DMA

Sujith Manoharan (1):
      Bluetooth: ath3k: Add support for ID 0x13d3/0x3402

Thomas Loo (1):
      Bluetooth: ath3k: Add support for Fujitsu Lifebook UH5x2 [04c5:1330]

 drivers/bluetooth/ath3k.c  | 46 +++++++++++++++++++++++++++++++++++++-----=
----
 drivers/bluetooth/btusb.c  | 18 +++++++++++-------
 net/bluetooth/hci_core.c   | 26 +++++++++++++++++---------
 net/bluetooth/l2cap_core.c |  2 +-
 4 files changed, 66 insertions(+), 26 deletions(-)

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJR97PYAAoJEPs3PUX4s20ocDYP/jkiaZtLDJNxdG6WmcFaciBv
hgjbraGZ1cW0jXJmOfbpjK0P+YcHcrx2j+RlDNj55rs+JY+GKeAuQUzXuR0vy7cB
uxAWWaqNbUziLYG+QUD6gq0GnM6AkgGz5I62gVly3UZ0i+qr5Bo8ayEY1ZBSTqws
jrTNE5FKUQtGjinxxxQalnpjbcnUyw0mfQ6xmbF+yYqRiJZUTUNVuKeDwu6e3xIQ
ummvCcKyoucey9D0s2U8SvpmvXWrXo3cAEe9rXolYcfzKHjYPAihISdTovI7qL3q
XRKfL7FSJTHzl4NudLS/d8klueItSjtFzVmRpdKihH2spSA+RNSMZr4IQHGJoJgw
A4XdTRrM3CORAzF/hkjAe9TxkB8gsnVHjFazER/TUGYBsTuzfXEmQFtepqE/cRjH
imzLiStzSgaIEJQgpUEchDy+RxPoDcOox/q0PUWeHhnjVShUcjTnuvxKtdcNbgFl
G/qSxjUfsCIu/5+uw0PFu7mEt+CKnNesP21Y2vETujXz1p2murpm1rHqlS0gLrtE
QlemfdKL735aWolFXkCNZ4YxjnNwm7zju7rh52xd+6h0wxQiqUb6CdNf7O87jtc7
s+50+t7PAtiEWX+TtxJr80pQmCKndOh5e1lr1ZOa8rQvhOt6RRBzkyzuj11gf9mP
aTUzvpALst82EWooWUd1
=qQs1
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
