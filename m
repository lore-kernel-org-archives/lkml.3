Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966435AbaFTSbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 14:31:37 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:42115 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966118AbaFTSbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:31:36 -0400
X-IronPort-AV: E=Sophos;i="5.01,515,1400050800"; 
   d="scan'208";a="35742251"
From: Markus Mayer <markus.mayer@linaro.org>
To: Michal Marek <mmarek@suse.cz>
CC: Linux Build List <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 0/2] Make host compiler and linker flags modifyable
Date: Fri, 20 Jun 2014 11:31:27 -0700
Message-ID: <1403289089-11299-1-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Being able to pass in extra compiler or linker flags for the host
compiler can be quite helpful. This proposed series would allow a user
to do just that.

Please let me know if you would consider this kind of change for
inclusion or if there is an alternate approach to achieve the same
goal.

Markus Mayer (2):
  Makefile: Make HOSTCFLAGS and HOSTCXXFLAGS user modifyable
  Makefile: Introduce HOSTLDFLAGS environment variable

 Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
1.9.1

