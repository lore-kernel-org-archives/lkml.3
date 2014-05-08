Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbaEHVIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 17:08:35 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:62642 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733AbaEHVId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 17:08:33 -0400
Message-ID: <536BF24E.1000709@gmail.com>
Date: Thu, 08 May 2014 14:08:30 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: dirk.brandewie@gmail.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: [PATCH 0/5] updates for intel_pstate
References: <1399579047-5792-1-git-send-email-dirk.j.brandewie@intel.com> <3320314.vMXib5RYFF@vostro.rjw.lan>
In-Reply-To: <3320314.vMXib5RYFF@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2014 01:30 PM, Rafael J. Wysocki wrote:
> On Thursday, May 08, 2014 12:57:22 PM dirk.brandewie@gmail.com wrote:
>> From: Dirk Brandewie <dirk.j.brandewie@intel.com>
>>
>> Patches 1-4 are bugfixes.  Patch 4 specifically removes the wreckage
>> caused by C0 tracking change.
>
> I would appreciate sending such stuff before the -rc4 time frame.

Agreed.

Patch 1 is a resend the others were sent as soon as they were ready/tested

>
>> Patch 5 Adds new CPU IDs for the Broadwell processors.
>>
>> Dirk Brandewie (5):
>>    intel_pstate: Set turbo VID for Baytrail
>>    intel_pstate: remove setting P state to MAX on init
>>    intel_pstate: Fix fixed point rounding macro
>>    intel_pstate: Remove C0 tracking
>>    intel_pstate: Add CPU IDs for Broadwell processors
>>
>>   drivers/cpufreq/intel_pstate.c | 52 +++++++++++++++++-------------------------
>>   1 file changed, 21 insertions(+), 31 deletions(-)
>
> I'll queue them up for 3.15-rc6, but that's a bit too late.
>
> Next time I may just wait for the next merge window, fixes or not.

OK the reporters of the issues already have the fixes in hand.

>
>

