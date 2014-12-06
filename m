Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbaLFFOh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 00:14:37 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:57721 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaLFFOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 00:14:36 -0500
Message-ID: <548290B2.1040707@roeck-us.net>
Date: Fri, 05 Dec 2014 21:14:26 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.17 000/122] 3.17.5-stable review
References: <20141205223305.514276242@linuxfoundation.org> <54827868.4040100@roeck-us.net> <20141206034425.GA3350@kroah.com>
In-Reply-To: <20141206034425.GA3350@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.548290BF.0173,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
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

On 12/05/2014 07:44 PM, Greg Kroah-Hartman wrote:
> On Fri, Dec 05, 2014 at 07:30:48PM -0800, Guenter Roeck wrote:
>> On 12/05/2014 02:42 PM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 3.17.5 release.
>>> There are 122 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sun Dec  7 22:32:17 UTC 2014.
>>> Anything received after that time might be too late.
>>>
>>
>> Build results:
>> 	total: 133 pass: 132 fail: 1
>> Failed builds:
>> 	avr32:atngw100mkii_evklcd101_defconfig
>
> Bah, it looks like no one cares about avr32 anymore :(
>

Hard to imagine that anyone working on a new design would select an atmel chip
with avr32 core instead of one with arm core. So that isn't really surprising.

Guenter

