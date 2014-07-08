Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbaGHIv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:51:27 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:11895 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753493AbaGHIus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:50:48 -0400
X-IronPort-AV: E=Sophos;i="5.00,855,1396972800"; 
   d="scan'208";a="32986412"
Message-ID: <53BBB11F.5000508@cn.fujitsu.com>
Date: Tue, 8 Jul 2014 16:51:43 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Josh Triplett <josh@joshtriplett.org>, <linux-kernel@vger.kernel.org>,
        <mingo@kernel.org>, <dipankar@in.ibm.com>, <akpm@linux-foundation.org>,
        <mathieu.desnoyers@efficios.com>, <niv@us.ibm.com>,
        <tglx@linutronix.de>, <peterz@infradead.org>, <rostedt@goodmis.org>,
        <dhowells@redhat.com>, <edumazet@google.com>, <dvhart@linux.intel.com>,
        <fweisbec@gmail.com>, <oleg@redhat.com>, <sbw@mit.edu>
Subject: Re: [PATCH tip/core/rcu 0/4] Documentation changes for 3.17
References: <20140707222345.GA6320@linux.vnet.ibm.com> <20140708001435.GC19213@jtriplet-mobl1>
In-Reply-To: <20140708001435.GC19213@jtriplet-mobl1>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2014 08:14 AM, Josh Triplett wrote:
> On Mon, Jul 07, 2014 at 03:23:45PM -0700, Paul E. McKenney wrote:
>> Hello!
>>
>> This series provides a few documentation updates:
>>
>> 1.	Clarify that if there is nothing awakened, then there is no
>> 	memory barrier.
>>
>> 2.	Fix broken RTFP URL, courtesy of Pranith Kumar.
>>
>> 3.	Add acquire/release barrier to memory-barrier pairing rules.
>>
>> 4.	Add pointer to percpu-ref in rcuref.txt documentation.
> 
> For all four:
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> .
> 

For patch 1 ("documentation: Clarify wake-up/memory-barrier relationship")
and patch 4 ("documentation: Add pointer to percpu-ref for RCU and refcount")

Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
