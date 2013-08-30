Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab3H3ReV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 13:34:21 -0400
Received: from david.siemens.de ([192.35.17.14]:27527 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756532Ab3H3ReU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 13:34:20 -0400
Message-ID: <5220D787.1060304@siemens.com>
Date: Fri, 30 Aug 2013 19:33:59 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86-32: Early microcode loading stumbles over disabled DYNAMIC_FTRACE
References: <5217908E.2040702@siemens.com> <5220BC1A.3030108@zytor.com> <20130830115142.1ee4c825@gandalf.local.home> <5220C9C6.5020808@zytor.com> <20130830130331.1e260e85@gandalf.local.home> <5220D350.7030008@zytor.com> <20130830132525.06a944e8@gandalf.local.home>
In-Reply-To: <20130830132525.06a944e8@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-08-30 19:25, Steven Rostedt wrote:
> On Fri, 30 Aug 2013 10:16:00 -0700
> "H. Peter Anvin" <hpa@zytor.com> wrote:
>  
>>> Who uses static tracing? I only use it to test that it still works ;-)
>>
>> Can we get rid of it?
>>
> 
> I've though about it. But as some archs only have static tracing
> available (I need to revisit to make sure that's still the case), I
> kept it because I only test static tracing on x86.
> 
> I'm not sure if people still use it for x86 or not.
> 
> Jan, you use static tracing on x86?

Yes, due to out-of-tree code that is not compatible with dynamic
tracing. It might be feasible to change this, I didn't try again
recently. If static tracing goes away upstream, I'll have to sooner or
later.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
