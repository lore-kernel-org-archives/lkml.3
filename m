Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab3EELWQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 07:22:16 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:47937 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab3EELWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 07:22:15 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 0/4] rtc: rtc-hid-sensor-time: some changes
Date: Sun,  5 May 2013 13:21:23 +0200
Message-Id: <1367752887-2927-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <51765FB9.2050009@ahsoftware.de>
References: <51765FB9.2050009@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes to the first series:

- Patch 1 and 2 are unchanged,
- Patch 3 uses getnstimeofday() instead of do_gettimeofday() which spares
  a variable and it should include all changes requested through the
  review by Andrew Morton. I left in the "hacky" part but included a more
  verbose comment in the source why the "hacky" looking part is there,
- Patch 4 is new and adds support for milliseconds (currently only used
  if the system time will be set by the driver).

Regards,

Alexander Holler

