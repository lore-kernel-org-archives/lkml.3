Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab3LEM1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 07:27:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755717Ab3LEM1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 07:27:52 -0500
Message-ID: <52A07126.70508@redhat.com>
Date: Thu, 05 Dec 2013 07:27:18 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] sched/numa: drop idx field of task_numa_env struct
References: <1386241817-5051-1-git-send-email-liwanp@linux.vnet.ibm.com> <1386241817-5051-2-git-send-email-liwanp@linux.vnet.ibm.com>
In-Reply-To: <1386241817-5051-2-git-send-email-liwanp@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2013 06:10 AM, Wanpeng Li wrote:
> Drop unused idx field of task_numa_env struct.
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
