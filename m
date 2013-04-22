Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab3DVNIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 09:08:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33500 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab3DVNIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 09:08:50 -0400
Message-ID: <5175362E.4080602@ti.com>
Date: Mon, 22 Apr 2013 09:07:58 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: amit daniel kachhap <amit.daniel@samsung.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org >> \"linux-kernel@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/30] thermal: cpu_cooling: code improvements
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com> <516F06F5.9060200@ti.com> <CADGdYn7KxqLBtZAZSb0my7OSC_Q3As=G9vZuHVyB3zv=3TpxJg@mail.gmail.com>
In-Reply-To: <CADGdYn7KxqLBtZAZSb0my7OSC_Q3As=G9vZuHVyB3zv=3TpxJg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit,

On 21-04-2013 22:34, amit daniel kachhap wrote:
> Hi Eduardo,
>
> I looked at your whole series and they certainly looks useful, so for
> the entire series,
> Acked-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>

Ok, thanks.

Side note: Your Linaro email address is bouncing. Could you please send 
a patch updating the files you have signed?

> Thanks,
> Amit Daniel Kachhap
>
> On Thu, Apr 18, 2013 at 2:02 AM, Eduardo Valentin
> <eduardo.valentin@ti.com> wrote:
>> On 17-04-2013 13:11, Eduardo Valentin wrote:
>>>
>>> Rui,
>>
>>
>>
>> Looks like I forgot to add the lists on patch 00. Doing so..
>>>
>>>
>>> This is a series of patches to improve the code for cpu_cooling.
>>> Majority of these changes are actually kernel-doc updates, as
>>> they required to be revised. A part from these, there are some
>>> changes regarding code style and readiness.
>>>
>>> Some may complain that these are a matter of taste, indeed.
>>> But I tried to just be unbiased and just keep the changes related
>>> to kernel-doc and checkpatch.pl. After this series, theses
>>> tools should be generating decent output ;-).
>>>
>>> The remaining changes are actually a couple of fixes for defensive
>>> coding. A part from updating the MAINTAINERS entry to cover cpu_cooling.
>>>
>>> This series has been tested on TI OMAP4430, together with the
>>> thermal driver under staging tree.
>>>
>>> All these patches are based on current linux-next/master.
>>>
>>> They are also available here:
>>>
>>> All best,
>>>
>>> Eduardo Valentin (30):
>>>     thermal: cpu_cooling: remove unused headers
>>>     thermal: cpu_cooling: remove trailing white spaces
>>>     thermal: cpu_cooling: fix kernel_doc for cpufreq_cooling_device
>>>     thermal: cpu_cooling: use EXPORT_SYMBOL_GPL
>>>     thermal: cpu_cooling: remove compiler warning
>>>     thermal: cpu_cooling: standardize end of function
>>>     thermal: cpu_cooling: fix kernel doc for is_cpufreq_valid
>>>     thermal: cpu_cooling: add documentation for get_property
>>>     thermal: cpu_cooling: standardize comment style
>>>     thermal: cpu_cooling: align on open parenthesis
>>>     thermal: cpu_cooling: remove trailing blank line
>>>     thermal: cpu_cooling: document cpufreq_get_cooling_level
>>>     thermal: cpu_cooling: remove checkpatch.pl warning
>>>     thermal: cpu_cooling: improve documentation for get_cpu_frequency
>>>     thermal: cpu_cooling: update documentation for cpufreq_apply_cooling
>>>     thermal: cpu_cooling: update documentation for
>>>       cpufreq_thermal_notifier
>>>     thermal: cpu_cooling: update Kconfig entry
>>>     thermal: cpu_cooling: alignment improvements
>>>     thermal: cpu_cooling: update documentation for cpufreq_get_max_state
>>>     thermal: cpu_cooling: update documentation for cpufreq_get_cur_state
>>>     thermal: cpu_cooling: update documentation for cpufreq_set_cur_state
>>>     thermal: cpu_cooling: update kernel-doc for cpufreq_cooling_register
>>>     thermal: cpu_cooling: update kernel-doc comment for
>>>       cpufreq_cooling_unregister
>>>     thermal: cpu_cooling: use snprintf instead of sprintf
>>>     thermal: cpu_cooling: remove not needed curl brackets
>>>     thermal: cpu_cooling: remove unused symbols
>>>     thermal: cpu_cooling: add needed header for cpu_cooling.h
>>>     MAINTAINERS: update thermal entry by adding file cpu_cooling.h
>>>     thermal: cpu_cooling: remove unused symbols on cpu_cooling.h
>>>     thermal: cpu_cooling: improve line breaking
>>>
>>>    MAINTAINERS                   |   1 +
>>>    drivers/thermal/Kconfig       |   5 +-
>>>    drivers/thermal/cpu_cooling.c | 156
>>> ++++++++++++++++++++++++++++++------------
>>>    include/linux/cpu_cooling.h   |  20 +++---
>>>    4 files changed, 125 insertions(+), 57 deletions(-)
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>

