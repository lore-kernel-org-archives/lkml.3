Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934466AbaE2F1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:27:41 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:44770 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933103AbaE2F1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 01:27:38 -0400
Message-ID: <5386C543.6070104@linaro.org>
Date: Thu, 29 May 2014 14:27:31 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>
CC: "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "tim.bird@sonymobile.com" <tim.bird@sonymobile.com>,
        "gkulkarni@caviumnetworks.com" <gkulkarni@caviumnetworks.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [for-next][PATCH] ftrace: Make CALLER_ADDRx macros more generic
References: <1394705630-12384-1-git-send-email-takahiro.akashi@linaro.org> <1394862353-28963-7-git-send-email-takahiro.akashi@linaro.org> <20140416135217.GF1001@arm.com> <535E3040.7090402@linaro.org> <20140527091019.54a8d2d6@gandalf.local.home> <20140527184940.GA26035@arm.com>
In-Reply-To: <20140527184940.GA26035@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will

On 05/28/2014 03:49 AM, Will Deacon wrote:
> On Tue, May 27, 2014 at 02:10:19PM +0100, Steven Rostedt wrote:
>> Will,
>>
>> I made a separate branch called ftrace/arm64 as shown below. You can
>> pull that branch to base the rest of Akashi-san's patches on top of it.
>> The branch is based on top of v3.15-rc5.
>
> Thanks Steve, I'll pull that in.
>
> Akashi: please can you re-send your series, based on the branch below and
> including the acks/reviewed-by tags you got for v6 of the patches?

Sorry again to have missed your e-mail :-)
I'm sure that you can successfully apply all my patch series, without any
modification, from:
     v6 arm64: prerequisites for audit and ftrace
     v8 arm64: Add ftrace support
except for the patch, "[v8 1/8] ftrace: make CALLER_ADDRx macros more generic,"
which was replaced by a new version and already appears in Steven's repo.

Thank you,
-Takahiro AKASHI

> Cheers,
>
> Will
>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
>> ftrace/arm64
>>
>> Head SHA1: eed542d6962ba33a689b4007a389f466e407bd74
