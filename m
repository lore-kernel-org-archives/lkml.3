Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934066Ab3BNKoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 05:44:01 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:49263 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933606Ab3BNKn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 05:43:59 -0500
Date: Thu, 14 Feb 2013 11:43:53 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, aquini@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michel Lespinasse <walken@google.com>,
        linux-tip-commits@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [tip:core/locking] x86/smp: Move waiting on contended ticket
 lock out of line
Message-ID: <20130214104353.GA25282@gmail.com>
References: <20130206150403.006e5294@cuia.bos.redhat.com>
 <tip-4aef331850b637169ff036ed231f0d236874f310@git.kernel.org>
 <CA+55aFx6N6SaRN+w=CTXJ=ZSsOE6KeS2R9sT_uhAx9h2j+hjKg@mail.gmail.com>
 <511BE4A3.8050607@redhat.com>
 <CA+55aFycMB7OZGQ54ueQ74C42beDBSdQE_fKJDV=TbjTjr_emg@mail.gmail.com>
 <511C1204.9040608@redhat.com>
 <CA+55aFwxYK-BLH0crhySHaQvAYHOH-VGUi7WTd1aq-24+WTDYw@mail.gmail.com>
 <511C24A6.8020409@redhat.com>
 <CA+55aFws80EEJQskqiP+a5J-HOGu=M1Fe=uCs50ifedVxPxT1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFws80EEJQskqiP+a5J-HOGu=M1Fe=uCs50ifedVxPxT1Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Eric got a 45% increase in network throughput, and I saw a 
> > factor 4x or so improvement with the semaphore test. I 
> > realize these are not "real workloads", and I will give you 
> > numbers with those once I have gathered some, on different 
> > systems.
> 
> Good. This is what I want to see.

I've put these commits aside meanwhile, until we have the 
numbers and decide one way or another.

Thanks,

	Ingo
