Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965399AbaGPPWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 11:22:33 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:31278 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933863AbaGPPWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 11:22:30 -0400
Date: Wed, 16 Jul 2014 11:22:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Corey Minyard <cminyard@mvista.com>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH RT 0/3] Linux 3.10.47-rt50-rc1
Message-ID: <20140716112227.7b8bc4bf@gandalf.local.home>
In-Reply-To: <53C68CB5.4020002@mvista.com>
References: <20140714200420.805309842@goodmis.org>
	<53C4714C.8000103@mvista.com>
	<20140714205333.6d28ed1f@gandalf.local.home>
	<53C68CB5.4020002@mvista.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2014 09:31:17 -0500
Corey Minyard <cminyard@mvista.com> wrote:

 
> I originally did a patch that just always did the else clause (the
> schedule_work_on() and wait_for_completion()) on all CPUs.  That seemed
> to work just fine and simplifies the code a bit and gets rid of all the
> preempt/migrate calls.  You could try that approach, or I could submit
> something if you liked.

Yeah, perhaps that's the way to go. But it needs to go to mainline
before it goes to -rt.

Can you resend it against my for-next branch.

Thanks,

-- Steve
