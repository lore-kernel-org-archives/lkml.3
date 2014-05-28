Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089AbaE1GSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 02:18:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:20591 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbaE1GSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 02:18:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,926,1392192000"; 
   d="scan'208";a="538750600"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [RFC PATCH 0/7] perf, x86: large PEBS interrupt threshold
Date: Wed, 28 May 2014 14:18:03 +0800
Message-Id: <1401257890-30535-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements large PEBS interrupt threshold. For some
limited cases, it can significantly reduce the sample overhead. Please
read patch 6's commit message for more information.

Regards
Yan, Zheng
