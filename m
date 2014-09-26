Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbaIZHZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 03:25:27 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:40826 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbaIZHZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 03:25:25 -0400
Message-ID: <542514DF.6050204@roeck-us.net>
Date: Fri, 26 Sep 2014 00:25:19 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Sebastian Reichel <sre@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 1/1] power: Add simple gpio-restart driver
References: <1409167431-21155-1-git-send-email-davidriley@chromium.org> <1409167431-21155-2-git-send-email-davidriley@chromium.org> <541BB278.9010701@roeck-us.net> <20140925234145.GA2063@earth.universe> <5424DD5E.3040809@roeck-us.net>
In-Reply-To: <5424DD5E.3040809@roeck-us.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.542514E5.001F,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
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

On 09/25/2014 08:28 PM, Guenter Roeck wrote:
> On 09/25/2014 04:41 PM, Sebastian Reichel wrote:
>> Hi Guenter,
>>
>> On Thu, Sep 18, 2014 at 09:35:04PM -0700, Guenter Roeck wrote:
>>> On 08/27/2014 12:23 PM, David Riley wrote:
>>>> This driver registers a restart handler to set a GPIO line high/low
>>>> to reset a board based on devicetree bindings.
>>>>
>>>> Signed-off-by: David Riley <davidriley@chromium.org>
>>>
>>> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
>>
>> Is there an immutable branch available with your restart handler
>> stuff, which I can pull into battery-2.6.git?
>>
>> -- Sebastian
>>
>
>
> Hi Sebastian,
>
> Unfortunately not.
>
> Andrew has the patches in his tree and will hopefully send the set to Linus
> during the next commit window. Not sure if/how I could create an immutable
> branch from the commits in his repository, especially since (if I understand
> it correctly) he re-creates his tree on a regular basis, which is changing
> the SHAs and, unless I am missing something, the commit dates.
>
> [ Not really sure how to best handle situations like that .. ]
>
> Guenter
>
Followup ... I am in the process of creating a branch.
Expect to see a pull request tomorrow.

Guenter

