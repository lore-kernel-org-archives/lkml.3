Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbaIVFtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 01:49:09 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:53167 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaIVFtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 01:49:07 -0400
Date: Mon, 22 Sep 2014 08:48:56 +0300
From: Johan Hedberg <johan.hedberg@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2014-09-22
Message-ID: <20140922054856.GA15688@t440s.P-661HNU-F1>
Mail-Followup-To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

Here are some more patches for 3.18. They include various fixes to the
btusb HCI driver, a fix for LE SMP, as well as adding Jukka to the
MAINTAINERS file for generic 6LoWPAN (as requested by Alexander Aring).

I've held on to this pull request a bit since we were waiting for a SCO
related fix to get sorted out first. However, since the merge window is
getting closer I decided not to wait for it. If we do get the fix sorted
out there'll probably be a second small pull request later this week.

Let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit 9a783a139c32a905825ee0aa9597f485ea461f76:

  Bluetooth: Fix re-setting RPA as expired when deferring update (2014-09-12 18:34:25 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to 5eb596f55cacc2389554a8d7572d90d5e9d4269d:

  Bluetooth: Fix setting correct security level when initiating SMP (2014-09-18 17:39:37 +0200)

----------------------------------------------------------------
Johan Hedberg (2):
      Bluetooth: btusb: Use GFP_KERNEL in btusb_send_frame()
      Bluetooth: Fix setting correct security level when initiating SMP

Jukka Rissanen (1):
      MAINTAINERS: add maintainer for generic 6LoWPAN

Marcel Holtmann (7):
      Bluetooth: btusb: Separate TX URB allocation and submission
      Bluetooth: Add BUILD_BUG_ON check for SKB control buffer size
      Bluetooth: Provide HCI command opcode information to driver
      Bluetooth: btusb: Fix old coding style issues
      Bluetooth: btusb: Split fragement receiption into separate functions
      Bluetooth: btusb: Implement driver internal packet reassembly
      Bluetooth: Remove exported hci_recv_fragment function

 MAINTAINERS                       |   1 +
 drivers/bluetooth/btusb.c         | 511 +++++++++++++++++++++++++---------
 include/net/bluetooth/bluetooth.h |   1 +
 include/net/bluetooth/hci_core.h  |   1 -
 net/bluetooth/af_bluetooth.c      |   3 +
 net/bluetooth/hci_core.c          |  21 +-
 net/bluetooth/smp.c               |   5 +-
 7 files changed, 385 insertions(+), 158 deletions(-)


--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUH7hIAAoJECQj9vv5qNQSA0AP/0XdUG9WvH2n9arYXopMOIY3
3xD0xwP7EpH6j2f9QigDZvTBrxlE1wehKn8lhKYWbRosQFNodQK8N0LX3vcYR8mb
TTM4vb8pAYvkOv6oyvJNCsi9gpaZMz9M1OfGIinH4yy2iSoEQi3G4mzvqtnWPtbA
dB2rirb3XcZkgkQxiCfDQz/mjdyig1U6npaVwcKbZIdRTPuRVbJzcK4ghjztHgWg
j2FHvMZCdyrTzqMn9NwAOb4r/E9qABuu3CbiUZTv6Gxv8SrHFh/6EUVP2RcG14rq
Yqlr8EtqI1PNL4JpNq8IgVNLGQWm3cUilZnkoZOnfp0t/W16NMCZiXZN1UWbw6gR
5nImAxu57wYLXwxrjA5y3W2of5l5XsI2TaZkeCbzMncA5bKcTW1lFQlfXpu15H8R
yKmn9FU8kHMqlD1B5H7Sn+BiqmxJwh0HuSyftMVl8AHsDnMwSYVN1UX4y/cJ2XL2
2haqBoTWFArT2D5ussl3n+UQmJOB1Vw71E97tEYbuBNEWnHANuhQRuGrxg3Q8a1i
3ki1WHvWtFwucHDJwC8JSfPNtvgmvQos6AdNarEP7Gkt2vkV3N0XaFsWC50MQXF0
+l9aB30mORONtZeN681RsyCCnueNOWDqdki2g7YFoyxNMunVkWtCAAJJ4cdF9Fnl
hK9KwaUsc5rjVBOK4fjS
=L3A7
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
