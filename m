Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab3ARRPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 12:15:50 -0500
Received: from service87.mimecast.com ([91.220.42.44]:48689 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab3ARRPt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 12:15:49 -0500
Date: Fri, 18 Jan 2013 17:15:46 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL] clockevents: decouple broadcast mechanism from
 drivers
Message-ID: <20130118171545.GB15707@e106331-lin.cambridge.arm.com>
References: <20130117172910.GA10070@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
In-Reply-To: <20130117172910.GA10070@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 18 Jan 2013 17:15:46.0684 (UTC) FILETIME=[74812BC0:01CDF59F]
X-MC-Unique: 113011817154704301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

As has been pointed out elsewhere, in my haste to fix this up I made a
typo in the first patch, preventing it from building.

Apologies for the confusion. I've created a new branch with a corrected
and tested version. Please see the pull request below.

Thanks,
Mark.

The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:

  Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)

are available in the git repository at:

  git://linux-arm.org/linux-mr.git for-tglx/timer-broadcast-v2

for you to fetch changes up to 041d14f475c4436d9fb9a7c94842154c42fd1b65:

  clockevents: Add generic timer broadcast function (2013-01-18 17:07:36 +0000)

----------------------------------------------------------------
Mark Rutland (2):
      clockevents: Add generic timer broadcast receiver
      clockevents: Add generic timer broadcast function

 include/linux/clockchips.h   |  9 +++++++++
 kernel/time/Kconfig          |  4 ++++
 kernel/time/tick-broadcast.c | 28 ++++++++++++++++++++++++++++
 3 files changed, 41 insertions(+)



