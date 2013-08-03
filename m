Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab3HCAlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 20:41:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:21360 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948Ab3HCAlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 20:41:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,805,1367996400"; 
   d="scan'208";a="380463164"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: eranian@google.com, jolsa@redhat.com, linux-kernel@vger.kernel.org
Subject: Misc perf stat improvements
Date: Fri,  2 Aug 2013 17:41:08 -0700
Message-Id: <1375490473-1503-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a couple of perf stat improvements/cleanups:

- output more information (ratios) in CSV mode
- add --initial-delay to skip startup phase of program
- handle pipes better in interval mode
- some cleanup

