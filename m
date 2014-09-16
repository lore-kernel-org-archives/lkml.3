Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbaIPNY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 09:24:59 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:59326 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbaIPNY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 09:24:57 -0400
Message-ID: <54183A1C.3010206@roeck-us.net>
Date: Tue, 16 Sep 2014 06:24:44 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Jesper Nilsson <jesper.nilsson@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cris <linux-cris-kernel@axis.com>, Jesper Nilsson <jespern@axis.com>,
        Mikael Starvik <starvik@axis.com>,
        Grant Likely <grant.likely@linaro.org>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>
Subject: Re: Status of 'cris' architecture support in Linux kernel
References: <20140831175010.GA15408@roeck-us.net>	<20140915145203.GK4659@axis.com>	<20140915195514.GC18175@roeck-us.net> <CAMuHMdXafiDxr2QtbiuYs48BZ_wyNVFGar91oJyYvBJ+U1Co-w@mail.gmail.com>
In-Reply-To: <CAMuHMdXafiDxr2QtbiuYs48BZ_wyNVFGar91oJyYvBJ+U1Co-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.54183A28.0232,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 6
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2014 12:23 AM, Geert Uytterhoeven wrote:
> Hi Günther,
>
> On Mon, Sep 15, 2014 at 9:55 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>>>> ./scripts/Makefile.headersinst:14: arch/cris/include/uapi/asm/arch-v10/Kbuild:
>>>>      No such file or directory
>>>> make[2]: *** No rule to make target `arch/cris/include/uapi/asm/arch-v10/Kbuild'.  Stop.
>>>
>>> Yes, known error, I believe that Sam Ravnborg's patch will correct this.
>>>
>> Is that patch available in public ? Sam's response seems to suggest that he
>> sent it to Michael (Mikael ?) who wanted to handle it, but I don't find a
>> matching patch in public archives.
>
> https://lkml.org/lkml/2014/7/14/424
>
Must be blind. Looked at the series for a long time but didn't see it.

>>> On a tangential note, my automatic (minimal) builds does not do
>>> make install, so I haven't seen this error. :-P
>>>
>> Mine not either ;-). I only found it because I tried to build an initramfs
>> which needs installed headers.
>
> http://kisskb.ellerman.id.au/kisskb/buildresult/11881673/
>
> We need an Auto-Builder Consolidation Project ;-)
>

More likely we need someone to actually look at build results. Like all the -next
builds that are currently failing, and I bet those responsible are not even aware
of it. Any ideas ?

Guenter

