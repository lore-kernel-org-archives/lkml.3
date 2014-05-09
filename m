Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220AbaEIRIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 13:08:47 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:61138 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553AbaEIRIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 13:08:45 -0400
Message-ID: <536D0B9B.8070906@mvista.com>
Date: Fri, 09 May 2014 12:08:43 -0500
From: Corey Minyard <cminyard@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, minyard@acm.org
CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: Simplify ring buffer resizing, make work with
 RT
References: <1399579402-27034-1-git-send-email-minyard@acm.org> <20140509131244.GF29014@linutronix.de>
In-Reply-To: <20140509131244.GF29014@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 08:12 AM, Sebastian Andrzej Siewior wrote:
> * minyard@acm.org | 2014-05-08 15:03:22 [-0500]:
>
>> This isn't well tested, but fixes an obvious PREEMPT_RT problem and seems
>> like a good simplification.  You can see the PREEMPT_RT bug if you enable
>> ftrace and all the self tests; it will fail running selftests when it tries
>> to resize the buffers.
> I posted http://marc.info/?l=linux-rt-users&m=139962823022896&w=2 before
> I noticed this one. You seem not to touch the second hunk.
>
> Sebastian
That's a good solution, too.  I didn't notice the second hunk in my testing.

Thanks,

-corey
