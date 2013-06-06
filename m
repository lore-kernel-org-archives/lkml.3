Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763Ab3FFKwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:52:39 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:60060 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390Ab3FFKwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:52:37 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Subject: [PATCH 0/3 v2] RFC: timekeeping: rtc: change hctosys mechanism
Date: Thu,  6 Jun 2013 12:51:47 +0200
Message-Id: <1370515910-2883-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1370452540-3319-1-git-send-email-holler@ahsoftware.de>
References: <1370452540-3319-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As already assumed, there are was at least one silly failure I made,
a wrong warning if the persistent was disabled by purpose which I seem
to have missed while looking at the output during my tests:

WARNING: Persistent clock returned invalid value!

I've fixed that in patch 2/3 and also have added some error messages
to indicate why reading the time from a misfunctional RTC fails to the
same patch. Because patch 3/3 didn't apply afterwards, I've solved the
conflict and resend it too. And to keep the small series together, I
resend patch 1/3 too.

So no changes in functionality, just some "cosmetic" changes in patch 2/3.

Regards,

Alexander Holler

