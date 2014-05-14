Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbaENPsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 11:48:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:32865 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaENPsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 11:48:16 -0400
Message-ID: <53739030.3040308@infradead.org>
Date: Wed, 14 May 2014 08:48:00 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, Uma Sharma <uma.sharma523@gmail.com>
Subject: Re: [PATCH tip/core/rcu 1/1] rcu: Variable name changed in tree_plugin.h
 and used in tree.c
References: <1400027459-29427-1-git-send-email-paulmck@linux.vnet.ibm.com> <20140514154150.GA1873@thin>
In-Reply-To: <20140514154150.GA1873@thin>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 08:41 AM, Josh Triplett wrote:
> On Tue, May 13, 2014 at 05:30:59PM -0700, Paul E. McKenney wrote:
>> From: Uma Sharma <uma.sharma523@gmail.com>
>>
>> The variable and struct both having the name "rcu_state" confuses
>> sparse in some situations, so this commit changes the variable to
>> "rcu_state_p" in order to avoid this confusion.  This also makes
>> things easier for human readers.
> 
> Human readers aside, how does Sparse get confused?  Let's fix that.

ack that.  Has it been reported on linux-sparse mailing list?

> Personally, I don't think the _p makes things particularly easier for
> human readers, but it doesn't make things *harder* for anyone other than
> those used to reading the existing code, so, *shrug*.


-- 
~Randy
