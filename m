Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaC3A3P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 20:29:15 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:44323 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbaC3A3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 20:29:12 -0400
Message-ID: <5337653D.6020002@oracle.com>
Date: Sat, 29 Mar 2014 20:28:45 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Alessandro Zummo <a.zummo@towertech.it>
CC: Tejun Heo <tj@kernel.org>, Greg KH <greg@kroah.com>,
        rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernfs/rtc: circular dependency between kernfs and ops_lock
References: <5308E3AE.3040405@oracle.com>	<20140222205217.GC16272@mtj.dyndns.org>	<20140224120427.6394d5dd@linux.lan.towertech.it>	<5331FA9E.20506@oracle.com> <20140325233936.655a798e@linux.lan.towertech.it> <53321D04.2040102@oracle.com>
In-Reply-To: <53321D04.2040102@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2014 08:19 PM, Sasha Levin wrote:
> On 03/25/2014 06:39 PM, Alessandro Zummo wrote:
>> On Tue, 25 Mar 2014 17:52:30 -0400
>> Sasha Levin <sasha.levin@oracle.com> wrote:
>>
>>>>
>>>>    Pretty interesting indeed. One option would be to remove
>>>>    the sys files before acquiring the lock. But I wonder
>>>>    if this could lead to other issues.
>>>>
>>>
>>> Ping? Seems this thing got lost.
>>
>>   What if we move
>>
>>     rtc_sysfs_del_device(rtc);
>>
>>   before acquiring the lock?
>
> Trying it now, I'll leave it going for a week and see if it reproduces.

Look good, thanks!


Thanks,
Sasha

