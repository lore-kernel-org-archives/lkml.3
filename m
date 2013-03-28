Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab3C1IS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 04:18:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58209 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755800Ab3C1ISY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 04:18:24 -0400
X-IronPort-AV: E=Sophos;i="4.87,364,1363104000"; 
   d="scan'208";a="6961937"
Message-ID: <5153FC6D.5020801@cn.fujitsu.com>
Date: Thu, 28 Mar 2013 16:16:45 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, vgoyal@redhat.com
CC: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] Documentation: Add ABI entry for crash_notes and crash_notes_size
References: <5153FC27.70001@cn.fujitsu.com>
In-Reply-To: <5153FC27.70001@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/28 16:17:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/28 16:17:33,
	Serialize complete at 2013/03/28 16:17:33
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an Documentation/ABI entry for /sys/devices/system/cpu/cpu0/crash_notes
and /sys/devices/system/cpu/cpu0/crash_notes_size.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 9c978dc..2447698 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -173,3 +173,15 @@ Description:	Processor frequency boosting control
 		Boosting allows the CPU and the firmware to run at a frequency
 		beyound it's nominal limit.
 		More details can be found in Documentation/cpu-freq/boost.txt
+
+
+What:		/sys/devices/system/cpu/cpu#/crash_notes
+		/sys/devices/system/cpu/cpu#/crash_notes_size
+Date:		April 2013
+Contact:	kexec@lists.infradead.org
+Description:	address and size of the percpu note.
+
+		crash_notes: the physical address of the memory that holds the
+		note of cpu#.
+
+		crash_notes_size: size of the note of cpu#.
-- 
1.7.1

