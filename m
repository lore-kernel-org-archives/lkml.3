Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbaIZGqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 02:46:35 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:34292 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbaIZGqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 02:46:34 -0400
Message-ID: <54250BB9.1020700@roeck-us.net>
Date: Thu, 25 Sep 2014 23:46:17 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux <linux@openrisc.net>
Subject: Re: linux-next: New build failures in Sep 25 tree
References: <20140925202559.GA1750@roeck-us.net> <CAMuHMdXE4aU1qZ9iGBT48QfMv5v7gsBZSjL_1_D8p=JBJfeN6A@mail.gmail.com>
In-Reply-To: <CAMuHMdXE4aU1qZ9iGBT48QfMv5v7gsBZSjL_1_D8p=JBJfeN6A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020207.54250BC9.00BE,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 5
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

On 09/25/2014 11:30 PM, Geert Uytterhoeven wrote:
> Hi Günther,
>
> [cc openrisc]
>
> On Thu, Sep 25, 2014 at 10:25 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> New build failures:
>
>> openrisc-defconfig
>>
>> In file included from arch/openrisc/kernel/signal.c:31:0:
>> ./arch/openrisc/include/asm/syscall.h: In function 'syscall_get_arch':
>> ./arch/openrisc/include/asm/syscall.h:77:9: error: 'EM_OPENRISC' undeclared
>
> That's not a new one. It's been failing for half or year or so.
>
Thought I had seen it before.

> If you only see it now, that means something else got fixed ;-)
>
That's one way to put it ;-)

Guenter

