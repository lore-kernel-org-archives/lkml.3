Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab3DVVbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 17:31:17 -0400
Received: from mb1i1mx.ns.pitt.edu ([136.142.11.141]:39874 "EHLO
	mb1i1.ns.pitt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752630Ab3DVVbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 17:31:16 -0400
Date: Mon, 22 Apr 2013 17:31:14 -0400
From: Jiannan Ouyang <ouyang@cs.pitt.edu>
Subject: Re: Preemptable Ticket Spinlock
In-reply-to: <1366664138.8337.18.camel@laptop>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Avi Kivity <avi.kivity@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Andrew Jones <drjones@redhat.com>, Karen Noel <knoel@redhat.com>
Message-id: <CAJocwce9e=fcnJomctC82H9t5EUMaTStzLSgqoaUoAzbYm3p+A@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
References: <CAJocwccu5QQyuKRvgNyPSFz2K_rzCW419W9-XdSUYOL7+KqQKg@mail.gmail.com>
 <51745650.9050204@redhat.com> <1366631460.4443.3.camel@laptop>
 <51753289.70406@redhat.com> <1366660147.6454.6.camel@laptop>
 <517595FA.800@redhat.com> <1366661294.6454.18.camel@laptop>
 <CAJocwceW6BuEu0Yuyv472aarpcziZH1wd-Xbc+Om81ES8+w+SA@mail.gmail.com>
 <1366664138.8337.18.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 4:55 PM, Peter Zijlstra <peterz@infradead.org> wrote:

>
> Which pv_lock? The current pv spinlock mess is basically the old unfair
> thing. The later patch series I referred to earlier implemented a
> paravirt ticket lock, that should perform much better under overcommit.
>

Yes, it is a paravirt *ticket* spinck. I got the patch from
Raghavendra K T through email
http://lwn.net/Articles/495597/
