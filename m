Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbaBRXxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:53:55 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:44857 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbaBRXxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:53:52 -0500
Message-ID: <5303F28C.4060906@intel.com>
Date: Tue, 18 Feb 2014 15:53:48 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
CC: dirk.j.brandewie@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] intel_pstate updates for v3.14-rcX
References: <1392228067-14817-1-git-send-email-dirk.j.brandewie@intel.com> <5303C2C2.8040605@intel.com> <2705558.gK5sRhMz43@vostro.rjw.lan>
In-Reply-To: <2705558.gK5sRhMz43@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 02:27 PM, Rafael J. Wysocki wrote:
> On Tuesday, February 18, 2014 12:29:54 PM Dirk Brandewie wrote:
>> Hi Rafael,
>
> Hi,
>
>> On 02/12/2014 10:01 AM, dirk.brandewie@gmail.com wrote:
>>> From: Dirk Brandewie <dirk.j.brandewie@intel.com>
>>>
>>> Based on v3.14-rc2
>>>
>>> Patch 1 removes energy reporting the patch from Maurizio Lambardi
>>>    intel_pstate: fix race condition in intel_pstate_init() can be dropped.
>>>
>>
>> Any reason why patches 2-5 did not make rc3 other than timing?
>>
>> Patches 2/3 can easily wait for v3.15.x
>>
>> Patches 4/5 fix bugs that are in the wild.
>
> I asked you about them, but you didn't reply:
>
> http://marc.info/?l=linux-pm&m=139225158531023&w=4
>
> Again, do patches [4-5/5] depend on [2-3/5]?
>
> If not, I can queue them up for -rc4.

All the patches are independent of one another.

Patch 2 is straight cleanup no functional change but reduces the memory
footprint slightly.

Patch 3 is a bug that will only be seen when the PID is reset at init time
or when a change is made to PID params via debugfs.  The problem will only
exist for one sample time since it is setting last_err in the PID.

Patch 4-5 are bugs found during Baytrail-T testing

--Dirk
>
> Thanks,
> Rafael
>

