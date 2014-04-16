Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbaDPL1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 07:27:39 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:40188 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755559AbaDPL1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 07:27:38 -0400
X-IronPort-AV: E=Sophos;i="4.97,871,1389715200"; 
   d="scan'208";a="29340833"
Message-ID: <534E5B3A.4010109@cn.fujitsu.com>
Date: Wed, 16 Apr 2014 19:28:10 +0900
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <rostedt@goodmis.org>, <fweisbec@gmail.com>, <mingo@redhat.com>,
        <acme@ghostprotocols.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8] perf sched: Add trace event for sched wait.
References: <cover.1397562542.git.yangds.fnst@cn.fujitsu.com> <20140415135447.GW11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140415135447.GW11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 10:54 PM, Peter Zijlstra wrote:
> On Tue, Apr 15, 2014 at 09:32:49PM +0900, Dongsheng Yang wrote:
>> But about 3, we have no trace event for it.
> We do, sched_switch() includes the previous task state. Also there's
> tons more than a waitqueue you can get stuck in.
Okey, prev_state is designed to trace No. 3 situation, but it seems
not working well now from my test result. I will look into it and dig
the reason out. Thanx for your help.
> .
>

