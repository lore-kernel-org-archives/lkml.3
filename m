Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab3DZTIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 15:08:42 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:39136 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616Ab3DZTIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 15:08:41 -0400
Message-ID: <517AD0AE.1030404@gmail.com>
Date: Fri, 26 Apr 2013 15:08:30 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Olivier Langlois <olivier@trillion01.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, schwidefsky@de.ibm.com,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] process cputimer is moving faster than its corresponding
 clock
References: <1365184746.874.103.camel@Wailaba2>  <1365593710.30071.52.camel@laptop> <1365608911.707.65.camel@Wailaba2>  <1365763837.17140.52.camel@laptop> <1365782115.17140.68.camel@laptop>  <CAFTL4hwQ4FZs0VCNXP37f=+DBW7Q2EQc6PW_EtYiVnZCPWN4OQ@mail.gmail.com>  <CAHGf_=pWPT4XdrJ8ZveL4zJKm1SE0whpL_fMHd5_TokuNQxSJQ@mail.gmail.com>  <CAHGf_=psD4V-U4FFwAWr4k3ZP6p=GVkNY_0S-Cg06m-=89MM7Q@mail.gmail.com>  <1366951210.7911.28.camel@Wailaba2> <1366957639.7911.42.camel@Wailaba2>
In-Reply-To: <1366957639.7911.42.camel@Wailaba2>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I need to add that I can only confirm that to be true with
> sum_exec_runtime.
> 
> To affirm it to be true for stime and utime would require more
> investigation. I didn't look them at all. I was only concerned with
> sum_exec_runtime.
> 
> I will prepare a v2 of the patch accounting all the feedbacks that I
> received from KOSAKI Motohiro, Frederic Weisbecker and Peter Zijlstra
> and send it back here for further discussion.
> 
> Thank you very much all!

Do you mean your utime test case still failure? If you share your test-case, 
I'm going to look at your issue too.


