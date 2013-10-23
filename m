Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab3JWE0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 00:26:32 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:56866 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab3JWE0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 00:26:30 -0400
MIME-Version: 1.0
Date: Wed, 23 Oct 2013 09:56:30 +0530
Message-ID: <CAKohpomR1rtRFP2bLi2M6gf6sN6Rc5H8Q8v9mk9M7+9EWHxsnw@mail.gmail.com>
Subject: Re: [PATCH V2 Resend 13/34] cpufreq: ia64: Convert to light weight
 ->target_index() routine
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "rjw@sisk.pl" <rjw@sisk.pl>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 October 2013 22:02, Luck, Tony <tony.luck@intel.com> wrote:
>> This patch converts existing .target() to newly defined light weight
>> .target_index() routine for this driver.
>>
>> CPUFreq core will call cpufreq_frequency_table_target() before calling this
>> routine and will pass index to it.
>>
>> Cc: Tony Luck <tony.luck@intel.com>
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> Tested-by: Tony Luck <tony.luck@intel.com>

Thanks Tony..

@Rafael: Count this Tested-by for 1/34 and 31/34 as he actually
tested both :)
