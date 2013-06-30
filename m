Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab3F3Tcs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 15:32:48 -0400
Received: from smtprelay-h31.telenor.se ([213.150.131.4]:51186 "EHLO
	smtprelay-h31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab3F3Tco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 15:32:44 -0400
X-Greylist: delayed 1673 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Jun 2013 15:32:44 EDT
X-SENDER-IP: [85.230.171.181]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsitALeA0FFV5qu1PGdsb2JhbABagwgBAYMYI4UAsFSGewQBfRcDAQEBATg1gwAjGIECChoBiCW6dxaOK4Edg24DnXiOKDo
X-IronPort-AV: E=Sophos;i="4.87,969,1363129200"; 
   d="scan'208";a="356403425"
From: rydberg@euromail.se
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 0/2] Support for 2013 Macbook Air
Date: Sun, 30 Jun 2013 21:04:44 +0200
Message-Id: <1372619086-3532-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry, Jiri,

Please find enclosed two patches yielding support for the
MacbookAir6,2. As usual, there is one HID and one Input patch. Given
the closeness to the merge window, I suppose we could backport this to
3.10, unless Linus decides to wait another week. Backports should be
fine back to v3.7, inclusive. Dmitry, would you care to take the
patches, if Jiri is ok with that?

Thanks,
Henrik

Henrik Rydberg (2):
  HID: apple: Add support for the 2013 Macbook Air
  Input: bcm5974 - Add support for the 2013 MacBook Air

 drivers/hid/hid-apple.c       |  6 ++++++
 drivers/hid/hid-core.c        |  6 ++++++
 drivers/hid/hid-ids.h         |  3 +++
 drivers/input/mouse/bcm5974.c | 36 ++++++++++++++++++++++++++++++++++--
 4 files changed, 49 insertions(+), 2 deletions(-)

-- 
1.8.3.1

