Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab3JRBL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 21:11:59 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:58597 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab3JRBL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 21:11:57 -0400
Message-ID: <52608AB1.1010307@huawei.com>
Date: Fri, 18 Oct 2013 09:11:13 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jiri Kosina <trivial@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/3] Fix some trivial typos in comments
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct some spelling typo in comments

Xie XiuQi (3):
  irq: fix some trivial typos in comments
  mm: fix some trivial typos in comments
  timekeeping: Fix some trivial typos in comments.

 kernel/irq/chip.c         |    2 +-
 kernel/irq/manage.c       |    2 +-
 kernel/time/timekeeping.c |    3 ++-
 mm/slub.c                 |    2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

-- 
1.7.7


