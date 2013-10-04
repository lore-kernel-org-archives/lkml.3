Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3JDVjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 17:39:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:30818 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898Ab3JDVjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 17:39:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1035,1371106800"; 
   d="scan'208";a="414189160"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Allow disabling perf on x86
Date: Fri,  4 Oct 2013 14:39:42 -0700
Message-Id: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchkit allows to disable perf events on x86. Requires
various changes to avoid dependencies.

-Andi

