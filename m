Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaCaR1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 13:27:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041AbaCaR1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 13:27:14 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Reyad Attiyat <reyad.attiyat@gmail.com>, Derya <derya.kiran@yahoo.de>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Microsoft Surface Type/Touch Cover 2 fixes
Date: Mon, 31 Mar 2014 13:27:08 -0400
Message-Id: <1396286830-2795-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

well, this is a series which should fix the current state of the
Surface 2 touch cover.
The first one has been reported by Derya and the second one fixes the
problem for this device and the future ones.

I added the CC: stable tags, but if you prefer not having them, feel
free to do so.

One last thing: the patches are on top of v3.14, because your for-next
branch does not contain the reverted commit for now. It will hopefully
be ok once you rebased your tree before sending it to Linus.
Patch 2/2 should apply on any kernel >3.12, so your for-next branch
should be fine with this one.

Cheers,
Benjamin


Benjamin Tissoires (2):
  Revert "HID: microsoft: Add ID's for Surface Type/Touch Cover 2"
  HID: core: do not scan constant input report

 drivers/hid/hid-core.c      | 5 +++--
 drivers/hid/hid-ids.h       | 2 --
 drivers/hid/hid-microsoft.c | 4 ----
 3 files changed, 3 insertions(+), 8 deletions(-)

-- 
1.9.0

