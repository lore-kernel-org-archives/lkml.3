Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbaEOQJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:09:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42851 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbaEOQJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:09:43 -0400
Message-ID: <5374E653.2080309@zytor.com>
Date: Thu, 15 May 2014 09:07:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: chrubis@suse.cz
CC: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>,
        "Carlos O'Donell" <carlos@redhat.com>
Subject: Re: futex(2) man page update help request
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com> <537407ED.8050606@zytor.com> <CF999CD6.90A93%dvhart@linux.intel.com> <5374C54B.7040408@gmail.com> <20140515154246.GC6926@rei.Home> <5374E2A4.2070408@zytor.com> <20140515160152.GA7529@rei.Home>
In-Reply-To: <20140515160152.GA7529@rei.Home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 09:01 AM, chrubis@suse.cz wrote:
> 
>> I really believe the proper fix is to use assembly syscall stubs.  In
>> klibc I build a fairly elaborate machinery to autogenerate such syscall
>> stubs for a variety of architectures.
> 
> Then it would be nice to share these between klibc and LTP (and possible
> everybody else).
> 

It should be quite easy to extract from klibc.

	-hpa

