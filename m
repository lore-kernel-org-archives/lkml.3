Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbaHNBTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 21:19:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:65466 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbaHNBR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 21:17:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,859,1400050800"; 
   d="scan'208";a="558285886"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com
Subject: Updated Broadwell perf patchkit
Date: Wed, 13 Aug 2014 18:17:44 -0700
Message-Id: <1407979069-7121-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addressed the earlier review feedback. Also changed Haswell to use
the Broadwell cache event list, which is far more correct for it
than Sandy Bridge's.

-Andi

