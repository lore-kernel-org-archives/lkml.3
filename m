Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633Ab3J2Rcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 13:32:36 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:57476 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258Ab3J2Rcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 13:32:35 -0400
Message-ID: <526FF131.3070105@linaro.org>
Date: Tue, 29 Oct 2013 10:32:33 -0700
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@kernel.org>
Subject: [Question] : tie a task to a cluster when it shares memory resources
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

I am not expert on the NUMA area and the scheduler but I was wondering 
the following:

On numa a process can define a memory policy to optimize access because 
remote memory access is suboptimal.

On a multicluster (aka multipackage), eg. Bi-Xeon 4 cores, the scheduler 
load balancing can spawn/balance a task to the second cluster even if 
the task is resulting from a fork or a pthread_create. If I am correct 
that could impact the performances due to L2 cache misses, no ?

Won't it be more efficient to tie a task to a cluster when it shares 
memory resources with another task on the same cluster ? and when the 
task does 'exec', this constraint is removed.

Thanks
-- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

