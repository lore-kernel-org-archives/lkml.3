Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936546Ab3DIBHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 21:07:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:16059 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S936057Ab3DIBHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 21:07:09 -0400
X-IronPort-AV: E=Sophos;i="4.87,435,1363104000"; 
   d="scan'208";a="7017572"
Message-ID: <51636A64.5050002@cn.fujitsu.com>
Date: Tue, 09 Apr 2013 09:09:56 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 2/3] kernel/SRCU: provide a static initializer
References: <1363702606-31586-1-git-send-email-bigeasy@linutronix.de> <1363702606-31586-2-git-send-email-bigeasy@linutronix.de> <515E7B79.2020707@cn.fujitsu.com> <516295E7.70200@linutronix.de>
In-Reply-To: <516295E7.70200@linutronix.de>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/09 09:05:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/09 09:05:59,
	Serialize complete at 2013/04/09 09:05:59
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 06:03 PM, Sebastian Andrzej Siewior wrote:
> On 04/05/2013 09:21 AM, Lai Jiangshan wrote:
>> Hi, Sebastian
> 
> Hi Lai,
> 
>> I don't want to expose __SRCU_STRUCT_INIT(),
>> due to it has strong coupling with the percpu array.
>>
>> I hope other structure which uses SRCU should use init_srcu_struct().
> 
> I need a static initialization for this kind. Patch #3 shows one
> example I have another one pending for crypto.

If the percpu array can be defined in __SRCU_STRUCT_INIT(),
I'm happy to expose it. but it is not currently.

Why crypto can't use boot time initialization?

> Do you have any idea how I could get it done without this? Do you want
> to move/merge header files?

if crypto has to use static initialization, I will find out some way
or use your patch.

Thanks,
Lai

> 
>>
>> Thanks,
>> Lai
> 
> Sebastian
> 

