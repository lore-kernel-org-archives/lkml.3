Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab3DSRit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 13:38:49 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:32996 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab3DSRis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 13:38:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAFTL4hwQ4FZs0VCNXP37f=+DBW7Q2EQc6PW_EtYiVnZCPWN4OQ@mail.gmail.com>
References: <1365184746.874.103.camel@Wailaba2> <1365593710.30071.52.camel@laptop>
 <1365608911.707.65.camel@Wailaba2> <1365763837.17140.52.camel@laptop>
 <1365782115.17140.68.camel@laptop> <CAFTL4hwQ4FZs0VCNXP37f=+DBW7Q2EQc6PW_EtYiVnZCPWN4OQ@mail.gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Fri, 19 Apr 2013 10:38:27 -0700
Message-ID: <CAHGf_=pWPT4XdrJ8ZveL4zJKm1SE0whpL_fMHd5_TokuNQxSJQ@mail.gmail.com>
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

> I feel we are hitting the same issue than this patch:
> https://lkml.org/lkml/2013/4/5/116
>
> I'm adding Kosaki in Cc, who proposed roughly the same fix.

Thanks to CCing. I'm now sitting LSF and I can't read whole tons emails.
However the fix is definitely same and I definitely agree this approach.

thank you.
