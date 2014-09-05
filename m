Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717AbaIEN65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 09:58:57 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:50447 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318AbaIEN6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 09:58:55 -0400
Message-ID: <5409C19C.4030901@roeck-us.net>
Date: Fri, 05 Sep 2014 06:58:52 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [kernel.org PATCH] Li Zefan is now the 3.4 stable maintainer
References: <20140826230858.GA29970@kroah.com> <20140827045938.GA28282@roeck-us.net> <540813A5.7020704@huawei.com> <20140904183953.GA28599@roeck-us.net> <54096C8D.8000008@huawei.com>
In-Reply-To: <54096C8D.8000008@huawei.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.5409C19F.0095,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 09/05/2014 12:55 AM, Li Zefan wrote:
>>>> Li,
>>>>
>>>> it would be great if you can send me information about your -stable queue,
>>>> ie how you maintain it and where it is located. This will enable me to
>>>> continue testing the stable queue for the 3.4 kernel.
>>>>
>>>
>>> Thanks for testing LTS kernels!
>>>
>>> This is my 3.4.y git tree:
>>>
>>> https://git.kernel.org/cgit/linux/kernel/git/lizf/linux-3.4.y.git/
>>>
>>> And this is the patch queue:
>>>
>>> https://git.kernel.org/cgit/linux/kernel/git/lizf/linux-3.4.y-queue.git/
>>>
>>> I use quilt. When I've added some patches to 3.4.y, I'll update this
>>> queue. The patches and series file are under /patches. Currently there's
>>> already a patch in the queue.
>>>
>>> When I release a new version, I'll clean up the queue by removing all
>>> the files under /patches.
>>>
>>> Hope this is all the information you need. Please tell me if you need
>>> me to slightly adjust my workflow so it's easier for you.
>>
>> It almost works.
>>
>> Problem is that the pending patch got converted to use <cr><lf> instead of
>> just <lf> as common in Linux. When I try to apply it with "git quiltimport",
>> it bails out with "trailing whitespace" errors. "git am" with the individual
>> patch works fine for some reason, though.
>>
>> I can try to find a workaround, but it would be better to have the file in
>> linux file format to start with. Would that be possible ?
>>
>
> Yeah, I've fixed it. I'll run dos2unix for every patch file.
>

Yes, it now works. Wonder how it comes that the patch in Greg's patch tree
didn't have the problem. Any idea ?

Guenter

