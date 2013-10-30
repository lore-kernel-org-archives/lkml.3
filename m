Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab3J3Tiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 15:38:50 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:36482 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab3J3Tis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 15:38:48 -0400
Date: Wed, 30 Oct 2013 17:38:42 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2013-10-30
Message-ID: <20131030193842.GA2271@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

A last fix to the 3.12. I ended forgetting to send it before, I hope we can
still make the way to 3.12. It is a revert and it fixes an issue with bluetooth
suspend/hibernate that had many bug reports. Please pull or let me know of any
problems. Thanks!

	Gustavo
--
The following changes since commit c7515d2365a6b8a018950198ebe1f5be793cd4bb:

  brcmsmac: call bcma_core_pci_power_save() from non-atomic context (2013-09-26 14:02:34 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth master

for you to fetch changes up to b1a8014471b01dd862de9f91bbbff1296afac42d:

  Bluetooth: revert: "Bluetooth: Add missing reset_resume dev_pm_ops" (2013-10-02 16:01:49 -0300)

----------------------------------------------------------------
Hans de Goede (1):
      Bluetooth: revert: "Bluetooth: Add missing reset_resume dev_pm_ops"

 drivers/bluetooth/btusb.c | 1 -
 1 file changed, 1 deletion(-)

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJScWBCAAoJEPs3PUX4s20oDBsQAIjdUJQumpltijAtqnZuISmC
UTg27CgfrnTZQnNnJN/tMrdfRqZqPg9UqlBDl1z0Icm/HDQOvzRWfntq0WUPa52L
Q0Nu53oXYIO0gn3CjomzOFAXk52ptiBkqCDI+GmXG+LBQ0XwbxwDk6BPISGC30xO
d0NFiZ75dR2IbxfghBbnXLM72MeXBpI4SmQvVjN1C59NXuZH55FyjHXDTb0DkPx2
EtYfWMV0B9PyL7Btg5A7d/0NJUffBFpj8lr3NhHm7+Cxtl9a6Rnqdbl3Sjw+YYI7
im/FWjajybbG2xAuJtiWcLwMW/4VkO9rHM2w9803UT33G3Wx1OxRSueWCGRyyFQt
xEx5IqJ2LSayHTHoyLIeA2dw9ZQmk+7rU/KsvkwNmWiq6LTPJJcSrkvyk0BxEUvU
p6Q4yhKjc4Wd8ecjNtE+w4nAXcLybfT2iBvRq19cxz5Nu9BHQT165VLwvGkQqVCm
4IDCHJy0YlnIMSQJRPdSFupXMIukR3qB7NCnts8KiEPxop6wjR5wpcN7U+tVjkbZ
uBv6mrWr4pMgJrhqWKyzYKrdnJ/+8qEO28Pv3GgG6XCtG36KNeQxGwwXr/CC6Lkh
oY6mKNdj6okpWPnbT7r2RCaT7LgF9ZU1qFM9iWEeGSxQzWCP7ZhqRHGYc6tRnyzb
XcZcIilxg88g3aW/kpKl
=rOI1
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
