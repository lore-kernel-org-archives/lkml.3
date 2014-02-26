Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaBZQDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:03:35 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:42335 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbaBZQDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:03:34 -0500
MIME-Version: 1.0
In-Reply-To: <CABPqkBSECV6iG4T60-OTZsV2CrCtV=awUSt7SGLTdkX9i8T90g@mail.gmail.com>
References: <1392703661-15104-1-git-send-email-zheng.z.yan@intel.com>
 <530D53EF.9090706@amacapital.net> <CABPqkBSECV6iG4T60-OTZsV2CrCtV=awUSt7SGLTdkX9i8T90g@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 26 Feb 2014 09:03:13 -0700
Message-ID: <CALCETrWXDYsxXBWPqNS8cK69756DNj5sUyk-Fho2r_5_wh-=mg@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] perf, x86: Haswell LBR call stack support
To: Stephane Eranian <eranian@google.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 12:04 AM, Stephane Eranian <eranian@google.com> wrote:
> On Wed, Feb 26, 2014 at 3:39 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On 02/17/2014 10:07 PM, Yan, Zheng wrote:
>>>
>>> This patch series adds LBR call stack support. User can enabled/disable
>>> this through an sysfs attribute file in the CPU PMU directory:
>>>  echo 1 > /sys/bus/event_source/devices/cpu/lbr_callstack
>>
>> This seems like an unpleasant way to control this.  It would be handy to
>> be able to control this as an option to perf record.
>>
> That would mean you'd be root for perf.
> Or are you suggesting a perf event option? But then, you'd expose arch-specific
> feature at the API level.
>

I'm suggesting a perf event option, just like the way that PEBS works.

--Andy
