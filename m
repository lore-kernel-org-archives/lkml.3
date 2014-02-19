Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaBSAgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 19:36:04 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:51156 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbaBSAf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 19:35:29 -0500
Message-ID: <5303FC4E.7040305@gmail.com>
Date: Tue, 18 Feb 2014 16:35:26 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: dirk.brandewie@gmail.com,
        "dirk.j.brandewie@intel.com" <dirk.j.brandewie@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] intel_pstate updates for v3.14-rcX
References: <1392228067-14817-1-git-send-email-dirk.j.brandewie@intel.com> <4187014.8zm183CESa@vostro.rjw.lan> <CANOOhLToR8ajjiM1x7m_4Pbak3sUkjfq0h4EX6dz1U23D3X3EA@mail.gmail.com> <1862084.mmnlZ4yS6m@vostro.rjw.lan>
In-Reply-To: <1862084.mmnlZ4yS6m@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 04:43 PM, Rafael J. Wysocki wrote:
> On Tuesday, February 18, 2014 04:24:02 PM Dirk Brandewie wrote:
>> On Tuesday, February 18, 2014, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>>
>>> On Tuesday, February 18, 2014 03:53:48 PM Dirk Brandewie wrote:
>>>> On 02/18/2014 02:27 PM, Rafael J. Wysocki wrote:
>>>>> On Tuesday, February 18, 2014 12:29:54 PM Dirk Brandewie wrote:
>>>>>> Hi Rafael,
>>>>>
>>>>> Hi,
>>>>>
>>>>>> On 02/12/2014 10:01 AM, dirk.brandewie@gmail.com <javascript:;>wrote:
>>>>>>> From: Dirk Brandewie <dirk.j.brandewie@intel.com <javascript:;>>
>>>>>>>
>>>>>>> Based on v3.14-rc2
>>>>>>>
>>>>>>> Patch 1 removes energy reporting the patch from Maurizio Lambardi
>>>>>>>     intel_pstate: fix race condition in intel_pstate_init() can be
>>> dropped.
>>>>>>>
>>>>>>
>>>>>> Any reason why patches 2-5 did not make rc3 other than timing?
>>>>>>
>>>>>> Patches 2/3 can easily wait for v3.15.x
>>>>>>
>>>>>> Patches 4/5 fix bugs that are in the wild.
>>>>>
>>>>> I asked you about them, but you didn't reply:
>>>>>
>>>>> http://marc.info/?l=linux-pm&m=139225158531023&w=4
>>>>>
>>>>> Again, do patches [4-5/5] depend on [2-3/5]?
>>>>>
>>>>> If not, I can queue them up for -rc4.
>>>>
>>>> All the patches are independent of one another.
>>>>
>>>> Patch 2 is straight cleanup no functional change but reduces the memory
>>>> footprint slightly.
>>>>
>>>> Patch 3 is a bug that will only be seen when the PID is reset at init
>>> time
>>>> or when a change is made to PID params via debugfs.  The problem will
>>> only
>>>> exist for one sample time since it is setting last_err in the PID.
>>>>
>>>> Patch 4-5 are bugs found during Baytrail-T testing
>>>
>>> Are there any pointers to bug reports that may be included in the
>>> changelogs
>>> of these?
>>
>>
>> No.  I got the reports via email.  I could probably get the reporters to
>> file bugzillas.
>
> It would be good to add information about what machines are affected
> and what the user-visible problems are to the changelogs for future
> reference.
>
> And do we want these two patches in -stable?  If so, what -stable series should
> they go into?

Patch 2 v3.10+

Patch 3 v3.12+

Patch 4/5 v3.13+

--Dirk
>
> Rafael
>

