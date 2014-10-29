Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784AbaJ2Rir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:38:47 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44725 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934312AbaJ2Rip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:38:45 -0400
Date: Wed, 29 Oct 2014 13:38:43 -0400 (EDT)
Message-Id: <20141029.133843.1944866828262153726.davem@davemloft.net>
To: peterz@infradead.org
Cc: xiyou.wangcong@gmail.com, fengguang.wu@intel.com, lkp@01.org,
        linux-kernel@vger.kernel.org, oleg@redhat.com, ebiederm@xmission.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] netdev: Fix sleeping inside wait event
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141029173110.GE15602@worktop.programming.kicks-ass.net>
References: <CAM_iQpXTyBT_4TrnYAoAuAE_jMto=2B=cutFggpHRMhvSrG7qg@mail.gmail.com>
	<20141029171345.GO12706@worktop.programming.kicks-ass.net>
	<20141029173110.GE15602@worktop.programming.kicks-ass.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Oct 2014 10:38:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Wed, 29 Oct 2014 18:31:10 +0100

> On Wed, Oct 29, 2014 at 06:13:45PM +0100, Peter Zijlstra wrote:
>> On Wed, Oct 29, 2014 at 09:29:55AM -0700, Cong Wang wrote:
>> > While you are on it, please fix rtnl_lock_unregistering_all() too?
>> 
>> Ah, that's hidden someplace else, sure I can do that. Thanks for
>> pointing it out.
> 
> Here goes..

For this as well:

Acked-by: David S. Miller <davem@davemloft.net>
