Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbaEMPya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:54:30 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:51575 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbaEMPyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:54:21 -0400
Date: Tue, 13 May 2014 17:54:16 +0200
From: Juri Lelli <juri.lelli@gmail.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Dario Faggioli <raistlin@linux.it>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [SCHED_DEADLINE man pages 0/2] Summary
Message-Id: <20140513175416.765abe5b536257ab72d827bc@gmail.com>
In-Reply-To: <53723235.40101@gmail.com>
References: <53723235.40101@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 13 May 2014 16:54:45 +0200
"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> wrote:

> Peter, at al.
> 
> The follow ups to this mail contain the changes to man-pages for
> the new sched_setattr() and sched_getattr() system calls, as well
> as the changes to the sched(7) man page to document the 
> SCHED_DEADLINE policy, all new changes in kernel 3.14.
> 
> I used the text you submitted, but _heavily_ edited it, and added
> a _lot_ of further details. Therefore, could you (and Juri, and 
> Dario?) please carefully review the text.
> 
> The follow-up mails are:
> 
> [1/2] The sched_setattr.2 page that documents sched_setattr(2) 
>       and sched_getattr(2).
> 
> [2/2] The revisions to the sched(7) page.
>

Apart from nitpicks in 2/2, this looks great to me.

Thanks a lot!

Best,

- Juri
 
> In each case, I've posted the formatted output for easy reading,
> and attached the page source to the message.
> 
> Thanks,
> 
> Michael
> 
