Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab3DLS61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 14:58:27 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52409 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab3DLS60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 14:58:26 -0400
Date: Fri, 12 Apr 2013 14:58:23 -0400 (EDT)
Message-Id: <20130412.145823.1608861418189836214.davem@davemloft.net>
To: tglx@linutronix.de
Cc: sam@ravnborg.org, srivatsa.bhat@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        rusty@rustcorp.com.au, paulmck@linux.vnet.ibm.com, mingo@elte.hu,
        peterz@infradead.org, magnus.damm@gmail.com
Subject: Re: [PATCH v2] sparc: Use generic idle loop
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.02.1304122055210.21884@ionos>
References: <20130408.152449.169732563685022388.davem@davemloft.net>
	<20130411193850.GA2330@merkur.ravnborg.org>
	<alpine.LFD.2.02.1304122055210.21884@ionos>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 12 Apr 2013 11:58:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 12 Apr 2013 20:56:10 +0200 (CEST)

> On Thu, 11 Apr 2013, Sam Ravnborg wrote:
> 
>> Add generic cpu_idle support
>> 
>> sparc32:
>> - replace call to cpu_idle() with cpu_startup_entry()
>> - add arch_cpu_idle()
>> 
>> sparc64:
>> - smp_callin() now include cpu_startup_entry() call so we can
>>   skip calling cpu_idle from assembler
>> - add arch_cpu_idle() and arch_cpu_idle_dead()
> 
> Nice !
> 
> If Dave acks it, I'll pick it up 

Acked-by: David S. Miller <davem@davemloft.net>
