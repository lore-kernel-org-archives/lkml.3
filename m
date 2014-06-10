Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149AbaFJUPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:15:01 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:58134 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933132AbaFJUO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 16:14:57 -0400
Message-ID: <5397673D.8010200@semaphore.gr>
Date: Tue, 10 Jun 2014 23:14:53 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
CC: dirk.j.brandewie@intel.com, Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] cpufreq: intel_pstate: Trivial code cleanup
References: <5396208F.6070400@semaphore.gr> <1447217.dTmMAkaUnF@vostro.rjw.lan> <53973FD4.7090904@intel.com> <5753346.hxK14sqO5y@vostro.rjw.lan>
In-Reply-To: <5753346.hxK14sqO5y@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2014 11:17 μμ, Rafael J. Wysocki wrote:
> On Tuesday, June 10, 2014 10:26:44 AM Dirk Brandewie wrote:
>> On 06/10/2014 08:31 AM, Rafael J. Wysocki wrote:
>>> On Tuesday, June 10, 2014 08:12:48 AM Dirk Brandewie wrote:
>>>> On 06/09/2014 02:01 PM, Stratos Karafotis wrote:
>>>>> Remove unnecessary blank lines.
>>>>> Remove unnecessary parentheses.
>>>>> Remove unnecessary braces.
>>>>> Put the code in one line where possible.
>>>>> Add blank lines after variable declarations.
>>>>> Alignment to open parenthesis.
>>>>>
>>>>
>>>> I don't have an issue with this patch in general but I would rather
>>>> the cleanup be done when there is a functional change in the given
>>>> hunk of code otherwise you are setting up a fence for stable/backporters
>>>> of functional changes in the future.
>>>
>>> I actually prefer separate cleanups so as to avoid doing multiple things
>>> in one patch.
>>>
>>> Rafael
>>>
>> I don't have strong feelings either way I was just trying to be kind
>> to the maintainers of distro kernels.
> 
> And mixing fixes with cleanups in one patch doesn't do any good to them.
> 
> Trust me, I used to work for a distro. :-)
> 

So, should I proceed and split the patch or drop it? :)

Stratos


