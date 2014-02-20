Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbaBTUZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 15:25:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbaBTUY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 15:24:56 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: benjamin.tissoires@gmail.com, jkosina@suse.cz, dh.herrmann@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] HID: low level transport cleanup, series 3
Date: Thu, 20 Feb 2014 15:24:47 -0500
Message-Id: <1392927890-2389-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

this is a new round in the low level HID transport cleanup.
These are the formely 7/14 an 12/14 only.
I add in between a patch which makes .raw_request mandatory, to cleanup
the old 12/14 (so 3/3 here).

There is only two patches 2 merge after these 3... We are approaching the end!

Cheers,
Benjamin

Benjamin Tissoires (3):
  HID: input: hid-input remove hid_output_raw_report call
  HID: make .raw_request mandatory
  HID: hidraw: replace hid_output_raw_report() calls by appropriates
    ones

 Documentation/hid/hid-transport.txt |  3 ++-
 drivers/hid/hid-core.c              | 11 ++++++++---
 drivers/hid/hid-input.c             | 10 ++++++----
 drivers/hid/hidraw.c                | 19 ++++++++++++++-----
 include/linux/hid.h                 |  5 +----
 5 files changed, 31 insertions(+), 17 deletions(-)

-- 
1.8.5.3

