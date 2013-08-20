Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab3HTIIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 04:08:39 -0400
Received: from us02smtp1.synopsys.com ([198.182.60.75]:41626 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab3HTIIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 04:08:37 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <stable@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <noamc@ezchip.com>,
        <Anton.Kolesov@synopsys.com>, <linux-kernel@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 0/2] ARC fixes for 3.9/3.10 stable backport
Date: Tue, 20 Aug 2013 13:38:09 +0530
Message-ID: <1376986091-30241-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <20130820062901.GA3758@kroah.com>
References: <20130820062901.GA3758@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.26]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please apply the following 2 patches to 3.9/3.10 series.
They have been extracted out of mainline patches which can't be individually
backported due to other dependencies (please see respective changelogs for
references).

Thx,
-Vineet

Vineet Gupta (2):
  ARC: gdbserver breakage in Big-Endian configuration #1
  ARC: gdbserver breakage in Big-Endian configuration #2

 arch/arc/include/asm/ptrace.h  | 2 ++
 arch/arc/include/asm/syscall.h | 5 ++---
 arch/arc/kernel/entry.S        | 4 ++--
 3 files changed, 6 insertions(+), 5 deletions(-)

-- 
1.8.1.2

