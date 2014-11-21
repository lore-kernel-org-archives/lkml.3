Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574AbaKUQNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 11:13:53 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:60144 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473AbaKUQNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 11:13:50 -0500
Message-ID: <546F64B9.8060300@linaro.org>
Date: Fri, 21 Nov 2014 17:13:45 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm >> Linux PM mailing list" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL] cpuidle: A few improvements for ARM cpuidle via DT
References: <546C6DEB.8060204@linaro.org> <17509116.2bjC4d8bef@vostro.rjw.lan>
In-Reply-To: <17509116.2bjC4d8bef@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2014 04:56 PM, Rafael J. Wysocki wrote:
> On Wednesday, November 19, 2014 11:16:11 AM Daniel Lezcano wrote:
>>
>> Hi Rafael,
>>
>> this pull request, based on 3.18-rc5, contains a set of changes from
>> Lorenzo Pieralisi.
>>
>>    * Added a 'status' definition flag in the DT to specify the
>> unsupported firmware idle states and ignore those states in the parsing
>> code when initializing the cpuidle driver
>>
>>    * Added an idle state description in the DT. As the idle states are
>> not standardized on ARM, the description gives information about the
>> idle state
>>
>>    * Removed duplicate error message in the arm64 cpuidle drivers
>>
>> Thanks !
>>
>>     -- Daniel
>>
>>
>> The following changes since commit fc14f9c1272f62c3e8d01300f52467c0d9af50f9:
>>
>>     Linux 3.18-rc5 (2014-11-16 16:36:20 -0800)
>>
>> are available in the git repository at:
>>
>>     http://git.linaro.org/git-ro/people/daniel.lezcano/linux.git cpuidle/3.19
>>
>> for you to fetch changes up to 18f95a3640dbf421ab9532e517070a0c1cd4d582:
>>
>>     drivers: cpuidle: Remove cpuidle-arm64 duplicate error messages
>> (2014-11-19 10:16:28 +0100)
>
> Pulled, but I had a conflict with one patch from you I'd already queued up for
> 3.19-rc1.
>
> Can you please have a look at my bleeding-edge branch and check if I resolved
> the conflict correctly?

Hi Rafael,

yes the conflict is correctly resolved.

Thanks
   -- Daniel



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

