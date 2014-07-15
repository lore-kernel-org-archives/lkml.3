Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030238AbaGOXtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:49:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45209 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933678AbaGOXNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:13:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 41/66] intel_pstate: Update documentation of {max,min}_perf_pct sysfs files
Date: Tue, 15 Jul 2014 16:17:35 -0700
Message-Id: <20140715231703.910310655@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231702.156040999@linuxfoundation.org>
References: <20140715231702.156040999@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

commit 41629a8233470325bfbb60377f555f9e8acc879f upstream.

Update documentation to make the interpretation of the values clearer

Link: https://bugzilla.kernel.org/show_bug.cgi?id=64251
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/cpu-freq/intel-pstate.txt |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/Documentation/cpu-freq/intel-pstate.txt
+++ b/Documentation/cpu-freq/intel-pstate.txt
@@ -15,10 +15,13 @@ New sysfs files for controlling P state
 /sys/devices/system/cpu/intel_pstate/
 
       max_perf_pct: limits the maximum P state that will be requested by
-      the driver stated as a percentage of the available performance.
+      the driver stated as a percentage of the available performance. The
+      available (P states) performance may be reduced by the no_turbo
+      setting described below.
 
       min_perf_pct: limits the minimum P state that will be  requested by
-      the driver stated as a percentage of the available performance.
+      the driver stated as a percentage of the max (non-turbo)
+      performance level.
 
       no_turbo: limits the driver to selecting P states below the turbo
       frequency range.


