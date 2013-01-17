Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab3AQR30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 12:29:26 -0500
Received: from service87.mimecast.com ([91.220.42.44]:52093 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab3AQR3Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 12:29:24 -0500
Date: Thu, 17 Jan 2013 17:29:17 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [GIT PULL] clockevents: decouple broadcast mechanism from drivers
Message-ID: <20130117172910.GA10070@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Thread-Topic: [GIT PULL] clockevents: decouple broadcast mechanism from
 drivers
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 17 Jan 2013 17:29:21.0045 (UTC) FILETIME=[2F7D0C50:01CDF4D8]
X-MC-Unique: 113011717292207901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

These are the generic timer patches I posted a few days ago [1], with
the fixes you requested previously.

Please could you pull these into your tree, and create a public branch
for me to base my other patches on?

Thanks,
Mark.

[1] https://lkml.org/lkml/2013/1/14/276

The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:

  Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)

are available in the git repository at:

  git://linux-arm.org/linux-mr.git for-tglx/timer-broadcast

for you to fetch changes up to a9a71292273e2a9ca694ca37aad4b61a3a1fcdee:

  clockevents: Add generic timer broadcast function (2013-01-14 16:55:01 +0000)

----------------------------------------------------------------
Mark Rutland (2):
      clockevents: Add generic timer broadcast receiver
      clockevents: Add generic timer broadcast function

 include/linux/clockchips.h   |  9 +++++++++
 kernel/time/Kconfig          |  4 ++++
 kernel/time/tick-broadcast.c | 28 ++++++++++++++++++++++++++++
 3 files changed, 41 insertions(+)

