Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001AbaFZLJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 07:09:38 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:55851 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679AbaFZLJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 07:09:37 -0400
Date: Thu, 26 Jun 2014 16:39:27 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, tkhai@yandex.ru,
        Mike Galbraith <umgwanakikbuti@gmail.com>, khorenko@parallels.com,
        Ben Segall <bsegall@google.com>, Paul Turner <pjt@google.com>
Subject: Re: [PATCH v3 2/3] sched/rt: __disable_runtime: Enqueue just
 unthrottled rt_rq back on the stack
Message-ID: <20140626110927.GC20048@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20140625081502.2861.12526.stgit@tkhai>
 <1403684388.3462.43.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1403684388.3462.43.camel@tkhai>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062611-9574-0000-0000-00000E89ACDD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kirill Tkhai <ktkhai@parallels.com> [2014-06-25 12:19:48]:

> 
> Make rt_rq available for pick_next_task(). Otherwise, their tasks
> stay prisoned long time till dead cpu becomes alive again.
> 
> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
> CC: Konstantin Khorenko <khorenko@parallels.com>
> CC: Ben Segall <bsegall@google.com>
> CC: Paul Turner <pjt@google.com>
> CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> CC: Mike Galbraith <umgwanakikbuti@gmail.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Ingo Molnar <mingo@kernel.org>
> ---

Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

-- 
Thanks and Regards
Srikar Dronamraju

