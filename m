Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbaDRTwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 15:52:12 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:51531 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbaDRTwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 15:52:06 -0400
Date: Fri, 18 Apr 2014 15:52:03 -0400
From: Tejun Heo <tj@kernel.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] workqueue: jumps to use_dfl_pwq if the target cpumask
 is equal wq's
Message-ID: <20140418195203.GH23576@htj.dyndns.org>
References: <20140418000814.GA7622@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140418000814.GA7622@devel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 09:08:14AM +0900, Daeseok Youn wrote:
> wq_update_unbound_numa(), when it's decided that the newly updated
> cpumask equals the default, looks at whether the current pwq is
> already the default one and skips setting pwq to the default one.
> This extra step is unnecessary and we can always jump to use_dfl_pwq
> instead. Simplify the code by removing the conditional.
> This doesn't make any functional difference.
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>

Applied to wq/for-3.16 w/ minor update to the patch title.

Thanks.

-- 
tejun
