Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbaDYJKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:10:37 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:52648 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbaDYJKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:10:33 -0400
MIME-Version: 1.0
In-Reply-To: <535716A5.6050108@kernel.dk>
References: <cover.1395840483.git.agordeev@redhat.com>
	<20140422071057.GA13195@dhcp-26-169.brq.redhat.com>
	<535676A1.3070706@kernel.dk>
	<5356916F.4000205@kernel.dk>
	<CACVXFVMXh5ZP+ZsO2fV2mdKJrJF9AHg58v5KWmt_ZbEWvszsLw@mail.gmail.com>
	<535716A5.6050108@kernel.dk>
Date: Fri, 25 Apr 2014 17:10:32 +0800
Message-ID: <CACVXFVN-roORYH8b-qZ10e2_wrL1W5-xO2P=A_ARPFL2GqDn2Q@mail.gmail.com>
Subject: Re: [PATCH RFC 0/2] percpu_ida: Take into account CPU topology when
 stealing tags
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kent Overstreet <kmo@daterainc.com>, Shaohua Li <shli@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

On Wed, Apr 23, 2014 at 9:25 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2014-04-22 18:53, Ming Lei wrote:
>
>
>> In my null_blk test on a quad core SMP VM:
>>
>>       - 4 hw queue
>>       - timer mode
>>
>> With the above approach, tag allocation from local CPU can be
>> improved from:
>>
>>          5%   -> 50% for boot CPU
>>          30% -> 90% for non-boot CPU.
>>
>> If no one objects the idea, I'd like to post a patch for review.
>
>
> Sent it out, that can't hurt. I'll take a look at it, and give it a test
> spin as well.

I have sent out the patch in below link, and appreciate much
you will take a look at it.

      marc.info/?l=linux-kernel&m=139826944613225&w=2

Thanks,
-- 
Ming Lei
