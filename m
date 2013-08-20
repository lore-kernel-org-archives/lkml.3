Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab3HTAfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 20:35:09 -0400
Received: from smtp1.Stanford.EDU ([171.67.219.81]:35548 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751243Ab3HTAfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 20:35:07 -0400
Message-ID: <5212B9A8.9050900@ccrma.stanford.edu>
Date: Mon, 19 Aug 2013 17:34:48 -0700
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kent Overstreet <kmo@daterainc.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.10.6-rt3
References: <20130812163413.GI23040@linutronix.de> <520D212F.7030400@localhost> <20130815152210.5ed93696@gandalf.local.home> <520DCE5F.1040402@linutronix.de> <521254A0.6050603@localhost> <20130819202903.692097ea@gandalf.local.home>
In-Reply-To: <20130819202903.692097ea@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2013 05:29 PM, Steven Rostedt wrote:
> On Mon, 19 Aug 2013 10:23:44 -0700
> Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:
>
>
>>> The problem is that bcache is using new semaphore functions which it
>>> just introduced which rt does not know about. The comment above their
>>> definition says that it is wrong to use them and completion is the
>>> right way to do it.
>>> So my question is, why don't we use completion but this nasty hack?
>
> I think I'm going to send them an email about that.
>
>>
>> In the meanwhile, any hope of a patch to be able to compile and test
>> with my current configuration?
>
> Can you boot without enabling CONFIG_BCACHE?

I'm pretty sure I'll be able to do that. No real need in my personal 
case AFAICT.

I'll try that next - it is just that I try very hard to keep the 
configuration of my rt kernels as close as possible to the defaults that 
Fedora uses (they get distributed as part of Planet CCRMA and there is 
no telling what usage cases they will hit - it would be confusing to 
have something that works on Fedora kernels and does not on equivalent 
RT patched kernels).

Thanks for the heads up!,
-- Fernando
