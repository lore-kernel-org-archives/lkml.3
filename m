Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbbAWNAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 08:00:45 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:59291 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158AbbAWNAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 08:00:40 -0500
Message-Id: <20150123125159.696530128@infradead.org>
User-Agent: quilt/0.61-1
Date: Fri, 23 Jan 2015 13:51:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, linux-kernel@vger.kernel.org
Cc: vincent.weaver@maine.edu, eranian@gmail.com, jolsa@redhat.com,
        mark.rutland@arm.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, peterz@infradead.org
Subject: [RFC][PATCH 0/3] perf fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are a few perf patches that (hopefully) fix a number of reported
(and at least one unreported afaik) issues as triggered by Vince's
fuzzer.

After a few days of staring at that event->ctx mess and writing
increasingly horrible patches, I came up with the approach from patch 3.
It still isn't pretty or straight forward though; please give it careful
consideration.

Jiri reported some success on an slightly older stack.

