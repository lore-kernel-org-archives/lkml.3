Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbaDOLED (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:04:03 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:56246 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753164AbaDOLEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:04:00 -0400
Message-ID: <534D121D.9030304@semaphore.gr>
Date: Tue, 15 Apr 2014 14:03:57 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "David S. Miller" <davem@davemloft.net>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 00/20] Introduce new cpufreq helper macros
References: <534C4E14.3080509@semaphore.gr> <CAKohpomB5fSDS4inMrxfE57r+N22yVJskgK+wUXL8UGcXqdZow@mail.gmail.com>
In-Reply-To: <CAKohpomB5fSDS4inMrxfE57r+N22yVJskgK+wUXL8UGcXqdZow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/04/2014 09:01 πμ, Viresh Kumar wrote:
> On 15 April 2014 02:37, Stratos Karafotis <stratosk@semaphore.gr> wrote:
>> This patch set introduces two freq_table helper macros which
>> can be used for iteration over cpufreq_frequency_table and
>> makes the necessary changes to cpufreq core and drivers that
>> use such an iteration procedure.
>>
>> The motivation was a usage of common procedure to iterate over
>> cpufreq_frequency_table across all drivers and cpufreq core.
>>
>> This was tested on a x86_64 platform.
>> Patches 4-17 compiled successfully but unfortunately I was not
>> able to compile test patches 18-20.
> 
> Mostly okay, just some Nitpicks..
> 
> Please rearrange your patches this way:
> - First patch just adds the wrappers
> - Second one makes changes to drivers/cpufreq/, i.e. include all core
> and drivers
>   changes into a single patch here as the logs are exactly same.
> - Then framework by framework, as we may need Acks/Reviews by them
>   separately..
> 
> So, probably just 5-7 would do.
> 


Thanks for your review and your corrections!
I will prepare and send the v2 according to your suggestions.

Stratos
