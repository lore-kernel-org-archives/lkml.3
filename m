Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbaLWKHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:07:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38317 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899AbaLWKHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:07:34 -0500
Message-ID: <54993EE3.6000204@suse.cz>
Date: Tue, 23 Dec 2014 11:07:31 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Drysdale <drysdale@google.com>
Subject: Re: Linux 3.19-rc1 - merge window closed
References: <CA+55aFwu19GP5vHTwadX+ygAKwOqNLuEBA9TVEdnfxgvzP1zHA@mail.gmail.com>	 <1419145899.8696.5.camel@haakon3.risingtidesystems.com>	 <20141222124310.b35177e67db8d76b64ec55f6@linux-foundation.org>	 <alpine.LRH.2.00.1412222156260.29843@twin.jikos.cz> <1419288214.8696.14.camel@haakon3.risingtidesystems.com>
In-Reply-To: <1419288214.8696.14.camel@haakon3.risingtidesystems.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 22.12.2014 v 23:43 Nicholas A. Bellinger napsal(a):
> On Mon, 2014-12-22 at 21:56 +0100, Jiri Kosina wrote:
>> On Mon, 22 Dec 2014, Andrew Morton wrote:
>>
>>> On Sat, 20 Dec 2014 23:11:39 -0800 "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
>>>
>>>> Just hit the following build failure with CONFIG_AUDIT=y:
>>>>
>>>> arch/x86/ia32/audit.c: In function ‘ia32_classify_syscall’:
>>>> arch/x86/ia32/audit.c:38:7: error: ‘__NR_execveat’ undeclared (first use in this function)
>>>> arch/x86/ia32/audit.c:38:7: note: each undeclared identifier is reported only once for each function it appears in
>>>> make[2]: *** [arch/x86/ia32/audit.o] Error 1
>>>> make[1]: *** [arch/x86/ia32] Error 2
>>>> make: *** [arch/x86] Error 2
>>>> make: *** Waiting for unfinished jobs....
>>>
>>> Your .config works for me.  Does a `make mrproper' fix it?
>>>
>>> I've seen a few reports like this in recent months.  Something's
>>> up with the build dependency system.
>>
>> Let's add Michal Marek to CC then.
>>
> 
> Yep, post 'make mrproper' builds with CONFIG_AUDIT=y don't hit this
> failure.
> 
> The previous build was with v3.18-rc2 btw.

I guess you don't have the v3.18-rc2 based .config anymore, do you? Do
you remember what kind of confuration it was, i.e. was it a defconfig /
allmodconfig / 'typical distro build' / ...?

Thanks,
Michal

