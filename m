Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbaIFQe1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 12:34:27 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:41255 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaIFQe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 12:34:26 -0400
Message-ID: <540B378E.2000400@roeck-us.net>
Date: Sat, 06 Sep 2014 09:34:22 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>, Mark Brown <broonie@kernel.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linuxfoundation.org>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Sep 5: build failure due to 'mm: introduce
 dump_vma'
References: <20140905165052.GF29327@sirena.org.uk> <20140906154309.GB25739@roeck-us.net> <540B2C84.5000002@oracle.com>
In-Reply-To: <540B2C84.5000002@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.540B3791.00E3,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 09/06/2014 08:47 AM, Sasha Levin wrote:
> On 09/06/2014 11:43 AM, Guenter Roeck wrote:
>> I see the following build failure in next-20140905.
>>
>> Guenter
>
> Hey Guenter,
>
> Apologies for that. There is already a fix in -mm:
>
No worries.

> 	http://ozlabs.org/~akpm/mmots/broken-out/introduce-dump_vma-fix-2.patch
>
> So -next would be fixed once -mm is pulled in again.
>
Great!

Thanks,
Guenter

