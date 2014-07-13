Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbaGMQy6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 12:54:58 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:35984 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753903AbaGMQyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 12:54:49 -0400
Message-ID: <53C2B9D3.6040500@semaphore.gr>
Date: Sun, 13 Jul 2014 19:54:43 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Doug Smythies <dsmythies@telus.net>, rjw@rjwysocki.net,
        viresh.kumar@linaro.org
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] cpufreq: ondemand: Eliminate the deadband effect
References: <1404147574-17422-1-git-send-email-stratosk@semaphore.gr> <000001cf9de8$43925230$cab6f690$@net>
In-Reply-To: <000001cf9de8$43925230$cab6f690$@net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On 12/07/2014 06:45 μμ, Doug Smythies wrote:
> 
> On 2014.07.30 10:00 Stratos Karafotis wrote:
> 
>> This patchset changes slightly the calculation of target frequency to
>> eliminate the deadband effect (explained in patch 2 changelog) that it
>> seems to slow down the CPU in low and medium loads.
>>
>> Patch 1 introduces a new relation (RELATION_C) for the next frequency
>> selection, which chooses the closest frequency to target.
>>
>> Patch 2 is the actual change to ondemand governor.
> 
>> You may find graphs with the 'deadband' effect and benchmark results:
>> https://docs.google.com/spreadsheets/d/16kDBh5lyc6YvBnoS1hUa1t2O38z0xrWvaEj5XtJ8auw/edit#gid=2072493052
> 
> I did the same benchmark tests before (without) and after (with) this patch set on my i7-2600K system.
> I added the results, which are similar to Stratos', under a new "benchmark" tab on the spreadsheet.

Thank you very much for your benchmarks!

Stratos
