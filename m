Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbaDAKco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 06:32:44 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:48610 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751089AbaDAKcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 06:32:42 -0400
Message-ID: <533A95C3.5030103@hurleysoftware.com>
Date: Tue, 01 Apr 2014 06:32:35 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: Greg KH <greg@kroah.com>, jslaby@suse.cz, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: tty: hang on ldisc_sem
References: <53344CE4.4070609@oracle.com> <5334520D.8060602@hurleysoftware.com> <53377259.3050205@oracle.com> <533A3549.5050707@oracle.com>
In-Reply-To: <533A3549.5050707@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 11:40 PM, Sasha Levin wrote:
> On 03/29/2014 09:24 PM, Sasha Levin wrote:
>> On 03/27/2014 12:30 PM, Peter Hurley wrote:
>>> Hi Sasha,
>>>
>>> On 03/27/2014 12:08 PM, Sasha Levin wrote:
>>>>
>>>> Hi all,
>>>>
>>>> While fuzzing with trinity inside a KVM tools guest running latest -next
>>>> kernel, I've encountered a lockup on ldisc_sem.
>>>
>>> Can you send me the whole system log, preferably with the sysrq
>>> show-task-states and held locks output in it (attachment is fine)?
>>
>> Attached whole system log which contains all of the above.
>
> Peter,
>
> Could you confirm you got the log file? Oddly enough I see it as sent here
> but don't see it on lkml (Oracle servers tend to make mess out of mails).

Yep, thanks, I got it.

Regards,
Peter Hurley
