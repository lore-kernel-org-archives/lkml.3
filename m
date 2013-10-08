Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab3JHUOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:14:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44082 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab3JHUOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:14:31 -0400
Date: Tue, 8 Oct 2013 13:14:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Paul Mundt <paul.mundt@gmail.com>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/3]  Move ARCH specific fpu_counter out of
 task_struct
Message-Id: <20131008131430.f7f46ec85a6bf4e2d95819a6@linux-foundation.org>
In-Reply-To: <1381218389-16585-1-git-send-email-vgupta@synopsys.com>
References: <1381218389-16585-1-git-send-email-vgupta@synopsys.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Oct 2013 13:16:26 +0530 Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:

> When debugging a ARC SMP 3.11 build failure due to a ST insn dealing with
> task_struct.thread going out of range, I spotted @fpu_counter in task_struct
> which only SH/x86 happen to use, and can be easily moved out into corresponding
> ARCH specific thread_struct. This saves 4 bytes per task_struct instantiated,
> for all the other 18 arches.
> 
> While the change is relatively strightforward, I've failed to connect with
> SH arch folks / Paul Mundt, latter's SH email keeps bouncing back.
> Hence I'm taking the liberty to use his alternate email (as listed on his
> github page) and I appologize in advance if this causes any inconvenience.

I can't find [patch v2 2/3] anywhere.  Resend, please?
