Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab3HMBWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 21:22:19 -0400
Received: from toro.web-alm.net ([62.245.132.31]:42527 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756485Ab3HMBWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 21:22:17 -0400
Message-ID: <5209880E.6080902@osadl.org>
Date: Tue, 13 Aug 2013 03:12:46 +0200
From: Carsten Emde <C.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL)
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.10.6-rt3
References: <20130812163413.GI23040@linutronix.de> <20130812154810.433858a5@gandalf.local.home> <CAP=VYLrd_ZU94Nf0X+FtT3M2Xx85t9FF13o-hV+_xHi7EjTf=w@mail.gmail.com>
In-Reply-To: <CAP=VYLrd_ZU94Nf0X+FtT3M2Xx85t9FF13o-hV+_xHi7EjTf=w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 02:47 AM, Paul Gortmaker wrote:
> On Mon, Aug 12, 2013 at 3:48 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> On Mon, 12 Aug 2013 18:34:13 +0200
>> Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
>>
>>> Dear RT folks!
>>>
>>> I'm pleased to announce the v3.10.6-rt3 patch set.
>>
>> Does this mean that I can drop 3.6-rt in favor of 3.8-rt?
>
> I'd guess that the trade-off would be 3.0-rt against 3.8-rt.
> The above comment assumes 3.0 is aged out vs. 3.6 kernel.
>
>> I'm just about finished with a 3.6 stable, which I'll finish, add -rt
>> to it, and then call it "unsupported" after that. Well, I may take bug
>> fixes if people find any in the near future.
>>
>> I'm behind on 3.4-rt, 3.2-rt and of course 3.0-rt. Hopefully, I'll get
>> them all out this week.
>
> I expect that the 3.10-rt kernel will replace the older RT kernels.
We should not forget 3.2 that will be maintained until March 2016. Thus, 
let's focus on 3.2 and 3.10 (maintained until August 2015) and abandon 
all other 3.x RT versions.

	-Carsten.
