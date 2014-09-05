Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702AbaIEN5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 09:57:50 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:50245 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169AbaIEN5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 09:57:48 -0400
Message-ID: <5409C156.4040405@roeck-us.net>
Date: Fri, 05 Sep 2014 06:57:42 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>, Richard Weinberger <richard@nod.at>
CC: Lennox Wu <lennox.wu@gmail.com>, Chen Liqin <liqin.linux@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/28] Remove GENERIC_HAS_IOMAP
References: <1391971686-9517-1-git-send-email-richard@nod.at>	 <1391971686-9517-17-git-send-email-richard@nod.at>	 <CAF0htA5xWQwkMqdp0_zz05DLJvyCOJZf-v1Rso20de5VWFmPTA@mail.gmail.com>	 <1397553547.1985.25.camel@x220>	 <CAF0htA403PKyAgQjrMpYgawNZWKZm06UYrgV-7N_9tbas=SniA@mail.gmail.com>	 <1397673008.6361.0.camel@x220> <1403082609.1984.66.camel@x220>	 <CAF0htA691-9ccAr1FX-7xdBgx+OYjv7bG0VRMzETj_=0HW9pUQ@mail.gmail.com> <1409909543.5546.150.camel@x220>
In-Reply-To: <1409909543.5546.150.camel@x220>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.5409C15B.014E,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 1
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

On 09/05/2014 02:32 AM, Paul Bolle wrote:
> Guenter, Richard,
>
> On Thu, 2014-06-19 at 03:53 +0800, Lennox Wu wrote:
>> 2014-06-18 17:10 GMT+08:00 Paul Bolle <pebolle@tiscali.nl>:
>>>> On Wed, 2014-04-16 at 20:30 +0200, Paul Bolle wrote:
>>>> On Thu, 2014-04-17 at 01:29 +0800, Lennox Wu wrote:
>>>>> OK, we will merge it into our tree.
>>>
>>> The last few messages in this thread were sent shortly after v3.15-rc1.
>>> We're now at v3.16-rc1 and those three references to GENERIC_HAS_IOMAP
>>> are still there.
>>>
>>> Are there any issues with this patch?
>>>
>>>
>>> Paul Bolle
>>>
>> NO, there is no issue. We just want to push patches in a batched way.
>> The patch will show recently. Thank you.
>
> And at v3.17-rc3 this patch has still not shown up in mainline. Do you
> have suggestions for an alternative route to get this triviality finally
> merged?
>

I merged it with the latest kernel, added Lennox' Ack, and sent it to
trivial@kernel.org. Let's see what happens.

Guenter

