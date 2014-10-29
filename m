Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417AbaJ2Kat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:30:49 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:56963 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbaJ2Kas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:30:48 -0400
Date: Wed, 29 Oct 2014 16:00:41 +0530
From: Heena Sirwani <heenasirwani@gmail.com>
To: opw-kernel@googlegroups.com
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, tglx@linutronix.de,
        arnd@arndb.de
Subject: [PATCH v8 0/2] Added ktime_get_seconds() and ktime_get_real_seconds()
Message-ID: <cover.1414578445.git.heenasirwani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset adds two functions as follows:
	-ktime_get_seconds() to return tv_sec portion of
	ktime_get_ts64().
	-ktime_get_real_seconds() to return tv_sec portion of
	ktime_get_real_ts64().

Changes in v8:
	-changed type of ktime_sec to unsigned long
	- Added a patch with ktime_get_real_seconds().

Heena Sirwani (2):
  timekeeping: Added a function to return tv_sec portion of
    ktime_get_ts64()
  timekeeping: Added a function to return tv_sec portion of
    ktime_get_real_ts64()

 include/linux/timekeeper_internal.h |  2 ++
 include/linux/timekeeping.h         |  2 ++
 kernel/time/timekeeping.c           | 41 ++++++++++++++++++++++++++++++++++---
 3 files changed, 42 insertions(+), 3 deletions(-)

-- 
1.9.1

