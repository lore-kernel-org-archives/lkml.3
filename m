Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964779Ab3HHMAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 08:00:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58969 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab3HHMAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 08:00:38 -0400
Message-ID: <5203885D.8040401@ti.com>
Date: Thu, 8 Aug 2013 07:00:29 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: <linaro-kernel@lists.linaro.org>, <patches@linaro.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: OPP: rename functions? (was [PATCH] OPP: Export opp_add())
References: <58acb4a8a4e98089078de3ed71999730b6d97b4b.1375521724.git.viresh.kumar@linaro.org> <1611420.5h2rr9N0mt@vostro.rjw.lan> <52026C66.2080509@ti.com> <1999730.6oshSp9AC9@vostro.rjw.lan>
In-Reply-To: <1999730.6oshSp9AC9@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 05:53 PM, Rafael J. Wysocki wrote:
> On Wednesday, August 07, 2013 10:48:54 AM Nishanth Menon wrote:
>> Rafael,
>> offline question:
>
> Not really offline. :-)
>

:D..

>> On 08/06/2013 09:15 AM, Rafael J. Wysocki wrote:
>>> On Tuesday, August 06, 2013 08:08:20 AM Nishanth Menon wrote:
>>>> change in subject to reflect new discussion.
>>>>
>>>> On 05:53-20130806, Randy Dunlap wrote:
>>>>> On 08/03/2013 02:25 AM, Viresh Kumar wrote:
>>
>>>>>> +EXPORT_SYMBOL_GPL(opp_add);
>>>>>
>>>>> Could it be renamed to pm_opp_add() or power_opp_add() ?
>>>>> The name is a bit too unspecific IMO.
>>>> Though this has nothing specific with this patch, an interesting point.
>>>>
>>>> git grep -w opp . showed drivers/tty/n_tty.c,
>>>> drivers/sbus/char/openprom.c and arch/powerpc/kvm/mpic.c using
>>>> variables named opp to mean what ever they had in context. rest(around
>>>> 40 odd files) seem to use opp as in Documentation/power/opp.txt..
>>>>
>>>> We could go with a pm_ prefix or even dev_pm_opp_ prefix to be more
>>>> specific, though I prefer just pm_. If Rafael and others are ok, I can
>>>> post a series out.
>>>
>>> Yup, that would be useful.  I'm for dev_pm_opp_ if that matters.
>>
>> Given that there would be quiet a few conflicts, do you have a
>> suggestion around what baseline I should submit this?
>
> Well, ideally, on top of 3.12-rc1 when it's out and put it into linux-next
> right after that.

Will do. Thanks on the hint.

-- 
Regards,
Nishanth Menon
