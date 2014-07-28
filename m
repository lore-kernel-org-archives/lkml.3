Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbaG1SLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 14:11:32 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:43332 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaG1SLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 14:11:31 -0400
Date: Mon, 28 Jul 2014 14:11:27 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Subject: Re: [PATCH] kthread_work: wake up worker only when the worker is idle
Message-ID: <20140728181127.GB7462@htj.dyndns.org>
References: <1406347444-4045-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406347444-4045-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2014 at 12:03:59PM +0800, Lai Jiangshan wrote:
> If the worker task is not idle, it may sleep on some conditions by the request
> of the work.  Our unfriendly wakeup in the insert_kthread_work() may confuse
> the worker.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Applied to wq/for-3.17.

Thanks.

-- 
tejun
