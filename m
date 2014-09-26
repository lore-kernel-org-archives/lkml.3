Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbaIZGrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 02:47:18 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:34593 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbaIZGrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 02:47:16 -0400
Message-ID: <54250BEC.3080904@roeck-us.net>
Date: Thu, 25 Sep 2014 23:47:08 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Carlo Caione <carlo@caione.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the watchdog tree
References: <20140926154031.4bc4dc39@canb.auug.org.au>	<5424FFF4.4010506@smartplayin.com>	<542503B1.9090206@roeck-us.net> <20140926163412.4135c44a@canb.auug.org.au>
In-Reply-To: <20140926163412.4135c44a@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A02020A.54250BF4.003F,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 10
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

On 09/25/2014 11:34 PM, Stephen Rothwell wrote:
> Hi Guenter,
>
> On Thu, 25 Sep 2014 23:12:01 -0700 Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> Someone suggested that I should create an immutable tree with the
>> restart handler patchset, which everyone using the restart handlers
>> could merge. Is that an option ? I could technically do that,
>> but I would want to pick the patches from Andrew's tree to retain
>> his sign-off. Andrew, any thoughts/comments ?
>
> That is exactly what you should do.
>
Ok, I'll do that first thing tomorrow morning.

Guenter

