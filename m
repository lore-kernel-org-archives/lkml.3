Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbaG1STI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 14:19:08 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:58086 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaG1STE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 14:19:04 -0400
Date: Mon, 28 Jul 2014 14:19:00 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Subject: Re: [PATCH UPDATED] kthread_work: add cancel_kthread_work[_sync]()
Message-ID: <20140728181900.GD7462@htj.dyndns.org>
References: <1406347444-4045-3-git-send-email-laijs@cn.fujitsu.com>
 <20140728181818.GC7462@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140728181818.GC7462@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 02:18:18PM -0400, Tejun Heo wrote:
> Hello,
> 
> Updated description and dropped DEFINE_KTHREAD_WORK_ONSTACK().
> Applied to wq/for-3.17.

Oops this should have been the reply to another patch.  Sorry.

-- 
tejun
