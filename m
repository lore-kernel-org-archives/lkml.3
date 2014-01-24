Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbaAXK76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 05:59:58 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:54190 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaAXK74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 05:59:56 -0500
Date: Fri, 24 Jan 2014 05:59:52 -0500
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Li Zefan <lizefan@huawei.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        mingo@kernel.org, peterz@infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cpusets: Allocate heap only when required
Message-ID: <20140124105952.GD4101@htj.dyndns.org>
References: <8622e93b9c49c66ffdc9ef0aa8371c322718edd5.1390475530.git.viresh.kumar@linaro.org>
 <alpine.DEB.2.02.1401231330530.7313@chino.kir.corp.google.com>
 <52E1C8BD.2010500@huawei.com>
 <alpine.DEB.2.02.1401240230190.9846@chino.kir.corp.google.com>
 <20140124103631.GB4101@htj.dyndns.org>
 <alpine.DEB.2.02.1401240243260.24372@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401240243260.24372@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Fri, Jan 24, 2014 at 02:51:12AM -0800, David Rientjes wrote:
> Nobody is depending on shit, the patch is removing a completely pointless 
> memory allocation in braindead cpuset code.  What you think is "harmful" 
> or "more harmful" is irrelevant, but nobody said anything about depending 
> on that behavior to do anything.

Weren't you talking something of that effect in memcg?  Or was it
Michal?  At any rate, I think you're missing the point why Li replied
that it's harmless.  He, I think, meant that it doesn't make any
semantical difference to userland, so your reply saying that it's not
harmless listing the failure mode under memory pressure seemed
misleading, so I thought clarification was necessary.  Probably my
(false?) memory of you talking about that contributed.  Anyways, we
agree.  Don't depend on it.

Thanks.

-- 
tejun
