Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbaGQEXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 00:23:33 -0400
Received: from wolff.to ([98.103.208.27]:43078 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750832AbaGQEXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 00:23:31 -0400
Date: Wed, 16 Jul 2014 23:21:59 -0500
From: Bruno Wolff III <bruno@wolff.to>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Josh Boyer <jwboyer@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Scheduler regression from
 caffcdd8d27ba78730d5540396ce72ad022aff2c
Message-ID: <20140717042159.GA26711@wolff.to>
References: <20140716145546.GA6922@wolff.to>
 <20140716151748.GC2460@hansolo.jdub.homelinux.org>
 <53C6CFCC.2050300@arm.com>
 <20140716195414.GA16401@wolff.to>
 <53C7084C.7090104@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <53C7084C.7090104@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>Could you also put the two BUG_ON lines into build_sched_groups()
>>>[kernel/sched/core.c] wo/ the cpumask_clear() and setting
>>>sg->sgc->capacity to 0 and share the possible crash output as well?
>>
>>I can try a new build with this. I can probably get results back tomorrow
>>before I leave for work. The crashes happen too early in the boot process
>>for me to easily capture output as text. I can slow things down to take
>>pictures though.
>>
>
>That would be helpful. Thanks. I saw that you have CONFIG_SCHED_DEBUG 
>enabled.

Well that didn't help much. It still crashed. Taking pictures didn't 
get a good capture. I wasn't able to use boot_delay to slow things down, 
as even a small value resulted in me only seeing one line of output 
before giving up after a minute or two. I used a serial console to 
slow things down, but it isn't enough to make it easy to take pictures 
with the camera I had. The crash was someplace inside the scheduler, but 
I don't know if there were messages from the BUG_ON lines.
