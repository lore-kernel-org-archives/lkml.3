Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab3DSSJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 14:09:06 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:58406 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab3DSSJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 14:09:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAHGf_=pWPT4XdrJ8ZveL4zJKm1SE0whpL_fMHd5_TokuNQxSJQ@mail.gmail.com>
References: <1365184746.874.103.camel@Wailaba2> <1365593710.30071.52.camel@laptop>
 <1365608911.707.65.camel@Wailaba2> <1365763837.17140.52.camel@laptop>
 <1365782115.17140.68.camel@laptop> <CAFTL4hwQ4FZs0VCNXP37f=+DBW7Q2EQc6PW_EtYiVnZCPWN4OQ@mail.gmail.com>
 <CAHGf_=pWPT4XdrJ8ZveL4zJKm1SE0whpL_fMHd5_TokuNQxSJQ@mail.gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Fri, 19 Apr 2013 11:08:43 -0700
Message-ID: <CAHGf_=psD4V-U4FFwAWr4k3ZP6p=GVkNY_0S-Cg06m-=89MM7Q@mail.gmail.com>
Subject: Re: [PATCH] process cputimer is moving faster than its corresponding clock
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Olivier Langlois <olivier@trillion01.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        schwidefsky@de.ibm.com, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 10:38 AM, KOSAKI Motohiro
<kosaki.motohiro@gmail.com> wrote:
>> I feel we are hitting the same issue than this patch:
>> https://lkml.org/lkml/2013/4/5/116
>>
>> I'm adding Kosaki in Cc, who proposed roughly the same fix.
>
> Thanks to CCing. I'm now sitting LSF and I can't read whole tons emails.
> However the fix is definitely same and I definitely agree this approach.
>
> thank you.

And if I understand correctly, update_gt_cputime() is no longer
necessary after this patch because time never makes backward.

What do you think?
