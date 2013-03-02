Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab3CBVRB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 16:17:01 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:2093 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab3CBVRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 16:17:00 -0500
Message-ID: <1362259010.3602.4.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 2/2] ipc: semaphores: do not hold ipc lock more than
 necessary
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Michel Lespinasse <walken@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, "Vinod, Chegu" <chegu_vinod@hp.com>,
        "Low, Jason" <jason.low2@hp.com>, linux-tip-commits@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Ingo Molnar <mingo@kernel.org>, Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 02 Mar 2013 13:16:50 -0800
In-Reply-To: <CANN689FuYfNZjPSPYFKq4HkN5MVe_dOOAm8yswKE=bvw8s4vUQ@mail.gmail.com>
References: <1362183404.3420.25.camel@buesod1.americas.hpqcorp.net>
	 <CANN689FuYfNZjPSPYFKq4HkN5MVe_dOOAm8yswKE=bvw8s4vUQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-02 at 12:41 +0800, Michel Lespinasse wrote:
> On Sat, Mar 2, 2013 at 8:16 AM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
> > Instead of holding the ipc lock for permissions and security
> > checks, among others, only acquire it when necessary.
> >
> > Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
> 
> You got some really great test results on this; I think they deserve
> to be mentioned in the commit message.

Absolutely.

> 
> Code looks fine to me otherwise, but I only had a quick look.
> 
> Nice work!
> 
> Acked-by: Michel Lespinasse <walken@google.com>
> 

Thanks for reviewing, Michel.

Davidlohr

