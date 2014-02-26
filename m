Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751177AbaBZHEE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 02:04:04 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:49961 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaBZHEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 02:04:02 -0500
MIME-Version: 1.0
In-Reply-To: <530D53EF.9090706@amacapital.net>
References: <1392703661-15104-1-git-send-email-zheng.z.yan@intel.com>
	<530D53EF.9090706@amacapital.net>
Date: Wed, 26 Feb 2014 08:04:00 +0100
Message-ID: <CABPqkBSECV6iG4T60-OTZsV2CrCtV=awUSt7SGLTdkX9i8T90g@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] perf, x86: Haswell LBR call stack support
From: Stephane Eranian <eranian@google.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 3:39 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On 02/17/2014 10:07 PM, Yan, Zheng wrote:
>>
>> This patch series adds LBR call stack support. User can enabled/disable
>> this through an sysfs attribute file in the CPU PMU directory:
>>  echo 1 > /sys/bus/event_source/devices/cpu/lbr_callstack
>
> This seems like an unpleasant way to control this.  It would be handy to
> be able to control this as an option to perf record.
>
That would mean you'd be root for perf.
Or are you suggesting a perf event option? But then, you'd expose arch-specific
feature at the API level.

> --Andy
