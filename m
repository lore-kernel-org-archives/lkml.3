Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbaCEVTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:19:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757208AbaCEVTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:19:06 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        David Barksdale <dbarksdale@uplogix.com>, Antonio Ospite <ao2@ao2.it>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] HID: ll transport cleanup: final round
Date: Wed,  5 Mar 2014 16:18:50 -0500
Message-Id: <1394054334-20438-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alright, this is the re-spin of the last round of transport cleanup.

Some minor but important modifications are here, but nothing very enthousiastic.

Thanks for the reviews and the tests so far.

Cheers,
Benjamin

Benjamin Tissoires (4):
  HID: cp2112: remove various hid_out_raw_report calls
  HID: cp2112: remove the last hid_output_raw_report() call
  HID: sony: do not rely on hid_output_raw_report
  HID: remove hid_output_raw_report transport implementations

 drivers/hid/hid-cp2112.c      | 19 +++++++++-----
 drivers/hid/hid-sony.c        | 60 ++++++++++---------------------------------
 drivers/hid/hidraw.c          |  3 ++-
 drivers/hid/i2c-hid/i2c-hid.c | 14 ----------
 drivers/hid/uhid.c            |  1 -
 drivers/hid/usbhid/hid-core.c | 19 +++++---------
 include/linux/hid.h           | 21 ++-------------
 net/bluetooth/hidp/core.c     | 14 ----------
 8 files changed, 36 insertions(+), 115 deletions(-)

-- 
1.8.5.3
