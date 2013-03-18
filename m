Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab3CRSQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 14:16:11 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:42675 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab3CRSQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 14:16:09 -0400
Date: Mon, 18 Mar 2013 15:16:01 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2013-03-18
Message-ID: <20130318181601.GB3072@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

I put together 3 fixes intended for 3.9, there are support for two new devices
and a NULL dereference fix in the SCO code.

Please pull or let me know of any problem. Thanks!

        Gustavo

---
The following changes since commit 94a32d10f47b637ae24b78b1ddc7ef0e8396fda4:

  Bluetooth: Device 0cf3:3008 should map AR 3012 (2013-03-11 18:04:54 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth master

for you to fetch changes up to ebaf5795ef57a70a042ea259448a465024e2821d:

  Bluetooth: Add support for Dell[QCA 0cf3:817a] (2013-03-18 14:14:37 -0300)

----------------------------------------------------------------
Ming Lei (2):
      Bluetooth: Add support for Dell[QCA 0cf3:0036]
      Bluetooth: Add support for Dell[QCA 0cf3:817a]

Vinicius Costa Gomes (1):
      Bluetooth: Fix not closing SCO sockets in the BT_CONNECT2 state

 drivers/bluetooth/ath3k.c | 4 ++++
 drivers/bluetooth/btusb.c | 2 ++
 net/bluetooth/sco.c       | 1 +
 3 files changed, 7 insertions(+)

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRR1nhAAoJEPs3PUX4s20oX2gQAJUTAT8Cb6PD4ZuIRNK5fBP1
uy9idu1SPWkHcFfX27ODLANceYmdvuCpwX4ieceQNg5alnaWuOmxPnCrnpPBsQqD
L5nkFa1f7vkYZYKS8VRhBXTByKfV+vl5gnKcMzNCQ9Ffka+BdSCOP1QOPIQTKsT4
dAXRweLSo7ZzQj3m/JspvjfFbdUumA9o7DWuEAKk6P06dqcfz22bZwkLipRJbWvx
mpbvb07/XRv6+EWh7ULWB33H91E4Hge9lpfqerWonlWBJpLM7OeAd8BARPkCIW8C
5mrgh997z5+eGl/qPmJ8NFnqwZ5GSZkUswUFibqQKrLUTzJ5lsRzwTQawsqIe/gy
LNdYB8KTyn1qYpvv+dMeCCb1j2kJBhAkXfIv2xcfc0GJhWQsYqy245KK2YuBd9vv
oBfIkCf6Plndq8UP3ggovRP4w8wvuDowRinp+cKoFlhjbkgC/AXklzLBjMMtuSRy
hrVZdOvx8KzgrniOTDZNb5rE4S4rfE2wsOA7uiqbF7euRqDXz/F9Sv75L2UwpLHR
ygyyN4yYn607yHW7BmqgV3hxG+zG0iJ4s0nntP1snGh3c8EiA202kvybfe4hRS41
1KZMNpDXWUaSnBIXRxkLP2KLy2Vqj8+Jv/X51KQGJND933maEzHUDZbvVNKEG63b
JunQybt12ZesJQYGZHbL
=dvVz
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
