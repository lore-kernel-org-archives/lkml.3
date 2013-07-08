Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab3GHJNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 05:13:14 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:41698 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab3GHJNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 05:13:12 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 0/2] rtc: rtc-hid-sensor-time: enable HID input processing early
Date: Mon,  8 Jul 2013 11:12:45 +0200
Message-Id: <1373274767-24724-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <51D91A5D.3050908@ahsoftware.de>
References: <51D91A5D.3050908@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following 2 patches together replace the previous send patch
"rtc: rtc-hid-sensor-time: delay registering as rtc into a work".

They are based on the current master, so they might become included in 3.11.

I've splitted the changes into two patches because the patch changed such, that
combining them into just one patch doesn't make sense anymore.

Regards,

Alexander Holler

