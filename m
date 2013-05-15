Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759665Ab3EOQ6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 12:58:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:27795 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758588Ab3EOQ6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 12:58:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,678,1363158000"; 
   d="scan'208";a="337783991"
Message-ID: <5193BF58.1030805@intel.com>
Date: Wed, 15 May 2013 10:01:12 -0700
From: David Cohen <david.a.cohen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130315 Icedove/17.0.4
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio-langwell: fix irq conflicts when DT is not used
References: <1367881863-6025-1-git-send-email-david.a.cohen@intel.com> <20130507075904.GE20562@intel.com> <51892D29.7030803@intel.com>
In-Reply-To: <51892D29.7030803@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On 05/07/2013 09:34 AM, David Cohen wrote:
> On 05/07/2013 12:59 AM, Mika Westerberg wrote:
>> On Mon, May 06, 2013 at 04:11:03PM -0700, David Cohen wrote:
>>> When DT is not used IOAPIC does not register irq domain. As result
>>> IOAPIC won't care about gpio-langwell's virq and may cause conflict if
>>> an irq number is equal to gpio-langwell's virq mapped beforehand.
>>>
>>> This patch tells gpio_langwell to not ignore irq_base if != 0 and
>>> preferably use it to avoid the conflict.
>>>
>>> If DT is used, irq_base can safely be 0.
>>>
>>> Signed-off-by: David Cohen <david.a.cohen@intel.com>
>> Presuming that you have tested this on Medfield and it still works 
>> there.
>
> Medfield and Clovertrail :)
>
> Br, David
>
>>
>> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Kindly ping :)
Comments?

Br, David

