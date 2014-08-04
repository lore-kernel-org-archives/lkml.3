Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbaHDOr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:47:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbaHDOrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:47:25 -0400
Message-ID: <53DF9CC6.3090003@redhat.com>
Date: Mon, 04 Aug 2014 10:46:30 -0400
From: "Carlos O'Donell" <carlos@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Darren Hart <dvhart@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: futex(2) man page update help request
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com> <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com> <5373D0CA.2050204@redhat.com> <alpine.DEB.2.02.1405150121230.6261@ionos.tec.linutronix.de> <CAKgNAkjQ5Dd_U9OojXdgeforpRevvPHNFAw99kBFPCwHgf7Ggg@mail.gmail.com> <alpine.DEB.2.02.1405151144390.6261@ionos.tec.linutronix.de> <53752157.9070803@gmail.com>
In-Reply-To: <53752157.9070803@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 04:19 PM, Michael Kerrisk (man-pages) wrote:
> On 05/15/2014 04:14 PM, Thomas Gleixner wrote:
>> On Thu, 15 May 2014, Michael Kerrisk (man-pages) wrote:
>>> And that universe would love to have your documentation of
>>> FUTEX_WAKE_BITSET and FUTEX_WAIT_BITSET ;-),
>>
>> I give you almost the full treatment, but I leave REQUEUE_PI to Darren
>> and FUTEX_WAKE_OP to Jakub. :)
> 
> Thanks Thomas--that's fantastic! Hopefully, Darren and Jakub fill in those
> missing pieces...

Michael,

Do you need any help getting these additional futex error codes
into the linux kernel man pages project? Thomas provided the
missing bits and Darren commented... what else do we need?

I'm asking because I want to point other Red Hat engineers at
these pages to say: "these are the canonical error codes." 

We're trying to cleanup the userspace side of things.

Cheers,
Carlos.

