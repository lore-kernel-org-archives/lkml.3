Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab3IWXRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 19:17:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:44483 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394Ab3IWXRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 19:17:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,966,1371106800"; 
   d="scan'208";a="382510092"
Message-ID: <5240CDED.40501@linux.intel.com>
Date: Mon, 23 Sep 2013 16:25:33 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Jean Delvare <khali@linux-fr.org>, Fenghua Yu <fenghua.yu@intel.com>,
        "Artem S. Tashkinov" <t.artem@mailcity.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v5 2/2] hwmon: (coretemp) Report power and energy consumption
References: <1379968489-13781-1-git-send-email-linux@roeck-us.net> <1379968489-13781-2-git-send-email-linux@roeck-us.net> <5240C145.6080104@linux.intel.com> <20130923224541.GA25966@roeck-us.net>
In-Reply-To: <20130923224541.GA25966@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 03:45 PM, Guenter Roeck wrote:
> On Mon, Sep 23, 2013 at 03:31:33PM -0700, Srinivas Pandruvada wrote:
>> On 09/23/2013 01:34 PM, Guenter Roeck wrote:
>>> Supported by SandyBridge and newer CPUs.
>>>
>>> Cc: Fenghua Yu <fenghua.yu@intel.com>
>>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>>> ---
>>> v5: Merged to 3.12-rc1
>>> v4: Replaced INIT_DELAYED_WORK with INIT_DEFERRABLE_WORK
>>> v3: Added Cc:
>>> v2: Fix missing symbol error on i386 builds
>>>      Dropped leftover pr_info from debugging
>>>
>>> I am inclined to drop this patch set, as I received neither test nor code
>>> review feedback even though the patch set has been out there for a long time.
>>> Also, I am concerned that it overlaps or even conflicts with the proposed
>>> Power Cap/RAPL driver (https://lkml.org/lkml/2013/9/19/260).
>> <We feel that the power capping framework is the right place to show
>> the RAPL data. This is not just monitoring but also control.
>> There are other drivers getting developed using this framework to
>> expose an uniform sysfs interface.
> Thought so. Have you thought about providing a hwmon bridge ?
<Good idea. I think after base version is accepted, we can add this. >
>
> Thanks,
> Guenter

Thanks,
Srinivas

