Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab3GOS1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:27:23 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29635 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab3GOS1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:27:22 -0400
Message-ID: <51E43EE2.6020602@oracle.com>
Date: Mon, 15 Jul 2013 14:26:42 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: dipankar@in.ibm.com, LKML <linux-kernel@vger.kernel.org>,
        peterz@infradead.org
Subject: Re: rcu: qs related lockup on boot
References: <51E06841.50701@oracle.com> <20130712211524.GH16780@linux.vnet.ibm.com>
In-Reply-To: <20130712211524.GH16780@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 05:15 PM, Paul E. McKenney wrote:
> Might be we figured out a new way to deadlock RCU and the scheduler,
> but just in case you rediscovered an old way, could you please try this
> patch from Peter Zijlstra?
>
> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg464708.html
>
> If that doesn't help and you don't have lockdep enabled, could you
> please enable it?

I've been unable to reproduce it again with or without the patch.

I'll update when it shows up again.


Thanks,
Sasha
