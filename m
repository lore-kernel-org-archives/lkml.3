Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab3FGXW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:22:26 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:42626 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150Ab3FGXWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:22:24 -0400
Date: Fri, 7 Jun 2013 16:22:19 -0700
From: Tejun Heo <tj@kernel.org>
To: "weiqi@kylinos.com.cn" <weiqi@kylinos.com.cn>
Cc: torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: race condition in schedule_on_each_cpu()
Message-ID: <20130607232219.GK14781@mtj.dyndns.org>
References: <tencent_0777D84B54B4163A3B85255A@qq.com>
 <20130606212303.GH5045@htj.dyndns.org>
 <51B138AA.4070707@kylinos.com.cn>
 <51B14472.60904@kylinos.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B14472.60904@kylinos.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 10:24:50AM +0800, weiqi@kylinos.com.cn wrote:
> >Before the commit you originally quoted, the calling thread could be
> preempted and migrated to another CPU before get_online_cpus() thus
> ending up executing the function twice on the new cpu but skipping the
> old one.
> 
> does this situation will happen in "Full preemption" config, on 3.0.30-rt50?

Sure, if the fix hasn't been backported.

Thanks.

-- 
tejun
