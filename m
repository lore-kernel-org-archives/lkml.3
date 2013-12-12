Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab3LLAQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 19:16:48 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:36553 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab3LLAQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 19:16:47 -0500
Message-ID: <52A90069.4060401@linaro.org>
Date: Thu, 12 Dec 2013 08:16:41 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linaro Kernel <linaro-kernel@lists.linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>
Subject: Re: nohz_full left a periodic tick cpu issue
References: <52A845BD.5020801@linaro.org> <20131211152538.GR4208@linux.vnet.ibm.com> <20131211153114.GB7862@localhost.localdomain>
In-Reply-To: <20131211153114.GB7862@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2013 11:31 PM, Frederic Weisbecker wrote:
>> > OK, I'll bite...  Why not just use CONFIG_NO_HZ_FULL_SYSIDLE=y with
>> > CONFIG_NO_HZ_FULL_SYSIDLE_SMALL set to at least the number of CPUs on
>> > your system?  The default for CONFIG_NO_HZ_FULL_SYSIDLE_SMALL is eight.
>> > This stuff is in mainline, though Frederic's exploitation of it is
>> > still in the works.
>> > 
>> > On smaller systems, with Frederic's latest work, this should allow CPU 0
>> > to go idle quickly.
>> > 
>> > What are you needing that this would not provide?
> Yeah I think that's what he needs, but we haven't much advertized that feature
> yet. I mean there are good reasons, it's not yet working :o)

Many thanks for Paul and Frederic's comments!

yes, I enabled FULL_SYSIDLE with FULL_SYSIDLE_SMALL=2, but as Frederic
said they are not yet working.

> 
> But yeah Alex, I'm working on plugging the full system idle detection (CONFIG_NO_HZ_FULL_SYSIDLE=y)
> to shutdown the timekeeping CPUs adaptively.
> 
> I have the patches ready, I'm just polishing a few things, writing changelogs, then I'll send
> to LKML with you Cc'ed :)

I am very glad to hear this. looking forward to seeing your patch soon. :)

-- 
Thanks
    Alex
