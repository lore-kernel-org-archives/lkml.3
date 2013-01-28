Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab3A1Xqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 18:46:37 -0500
Received: from mga01.intel.com ([192.55.52.88]:31972 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927Ab3A1Xqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 18:46:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,555,1355126400"; 
   d="scan'208";a="279482581"
Date: Tue, 29 Jan 2013 07:46:20 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH tip] perf/x86: nhm_events_attrs and snb_events_attrs can be
 static
Message-ID: <20130128234620.GA8524@localhost>
References: <510441ca.jKKGS3DOYyOC3gnk%fengguang.wu@intel.com>
 <20130127010632.GF12329@localhost>
 <CABPqkBR4VCOpBH25yQOnhkOs6c52xEnNe=P4qifDXzr7WBERxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBR4VCOpBH25yQOnhkOs6c52xEnNe=P4qifDXzr7WBERxw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next.orig/arch/x86/kernel/cpu/perf_event_intel.c	2013-01-29 07:42:16.238595053 +0800
+++ linux-next/arch/x86/kernel/cpu/perf_event_intel.c	2013-01-29 07:43:47.678597226 +0800
@@ -139,12 +139,12 @@ static struct extra_reg intel_snb_extra_
 EVENT_ATTR_STR(mem-loads, mem_ld_nhm, "event=0x0b,umask=0x10,ldlat=3");
 EVENT_ATTR_STR(mem-loads, mem_ld_snb, "event=0xcd,umask=0x1,ldlat=3");
 
-struct attribute *nhm_events_attrs[] = {
+static struct attribute *nhm_events_attrs[] = {
 	EVENT_PTR(mem_ld_nhm),
 	NULL,
 };
 
-struct attribute *snb_events_attrs[] = {
+static struct attribute *snb_events_attrs[] = {
 	EVENT_PTR(mem_ld_snb),
 	NULL,
 };
