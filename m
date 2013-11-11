Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab3KKS15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 13:27:57 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:64725 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab3KKS1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 13:27:46 -0500
Date: Mon, 11 Nov 2013 16:27:38 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2013-11-11
Message-ID: <20131111182738.GB5648@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

A few fixes for 3.13. There is 3 fixes to the RFCOMM protocol. One crash fix to
L2CAP. A simple fix to a bad behaviour in the SMP protocol, and last, an
revert, that I sent in the last pull request but doesn't seem to be in your
tree.

Please pull or let me know of any issues. Thanks!


	Gustavo

---
The following changes since commit 8ce9beac4661f576ea0d518b9f086bb52a171a37:

  drivers: net: wireless: b43: Fix possible NULL ptr dereference (2013-10-18 13:41:11 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth master

for you to fetch changes up to 3244d4a55c95708b0fa6fd820a9009534ed08a5f:

  Bluetooth: Fix rejecting SMP security request in slave role (2013-11-11 15:48:36 -0200)

----------------------------------------------------------------
Hans de Goede (1):
      Bluetooth: revert: "Bluetooth: Add missing reset_resume dev_pm_ops"

Johan Hedberg (1):
      Bluetooth: Fix rejecting SMP security request in slave role

Marcel Holtmann (1):
      Bluetooth: Fix issue with RFCOMM getsockopt operation

Seung-Woo Kim (3):
      Bluetooth: Fix RFCOMM bind fail for L2CAP sock
      Bluetooth: Fix to set proper bdaddr_type for RFCOMM connect
      Bluetooth: Fix crash in l2cap_chan_send after l2cap_chan_del

 drivers/bluetooth/btusb.c   | 1 -
 net/bluetooth/l2cap_core.c  | 3 +++
 net/bluetooth/rfcomm/core.c | 3 +++
 net/bluetooth/rfcomm/sock.c | 6 +++++-
 net/bluetooth/smp.c         | 3 +++
 5 files changed, 14 insertions(+), 2 deletions(-)


--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSgSGZAAoJEPs3PUX4s20os2gQAJWNRGwTWJazWNT2NMOLNgCZ
T1y4QNNXICcRSUb2lTvuoJqR2REFn6bbOGcRGr/25Z1potrA6Y2aCdy/Vj+zhoRc
OiOr1DvdwxZaj0V7YWk5975c9O7gMLoQSrTQ4fYpRw3ZcoQR5T8V/SEgsjE5XVrB
GWdMfrYBhiz1rE/QXiLAChJ+5RMWE3kcg55AJFsKLe7N7PfHcBkwk5you5yXBjYa
00fGikyCf/kmMgQ4ygiWNkxTtEt9Y4ZCxXGLMYu8/T9XZkACELbVjBNYH4x6t/kU
+ARinPVHwFrOWJP+BQWo8aiGR1bid/mh8UtdbFs7agQoOej+1fxO7BcANrmw1KIO
aFKdewJm8yryW5Dwq2sE8sVRaQyIXgffUVVamFhnFdVfRxjh47gdQ45sLQ79FQNE
eHfRJATNZlW1u6h/Z0PIqFRRro7c5U1+kHUSEhxO5OeodxNbrwBND2JVUhDvmzpT
ZnK3K9xXgqH8XigFRjx2XsICZFpSpl9+IQx2D8f3QnwqqBm+lOrWBXhEBDS1SorY
qqDWeYAc5hydha+uueG/HI+JTR4RSeFXPshXanFfmXuBXGgxYlHfuL2IazdY9Sdw
eXcjugDZfrrLp/dSGUHW/KlD6OvcDxjji4hCVDHqj8gOd3bUCzWJ2+CrUqi2ev0A
xYwlGBe3I4sLu9hdPeTX
=v+GP
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
