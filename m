Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab3GXRif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:38:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab3GXRib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:38:31 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] HID special drivers converted to devres API
Date: Wed, 24 Jul 2013 19:38:03 +0200
Message-Id: <1374687485-31440-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

this is the v2 of this series.

Cheers,
Benjamin

changes since v1:
- make the exit code of probe() in hid-a4tech.c returning 0
- fix a typo in the commit message of 2/2

Benjamin Tissoires (2):
  HID: trivial devm conversion for special hid drivers
  HID: multitouch: devm conversion

 drivers/hid/hid-a4tech.c     | 21 +++----------
 drivers/hid/hid-apple.c      | 16 ++--------
 drivers/hid/hid-magicmouse.c | 17 ++---------
 drivers/hid/hid-multitouch.c | 71 ++++++++++++++------------------------------
 drivers/hid/hid-sony.c       |  9 ++----
 drivers/hid/hid-zydacron.c   | 19 ++----------
 6 files changed, 39 insertions(+), 114 deletions(-)

-- 
1.8.3.1

