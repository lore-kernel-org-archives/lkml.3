Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723AbaGAJHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 05:07:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757512AbaGAJHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 05:07:02 -0400
Message-ID: <53B27A22.8020604@redhat.com>
Date: Tue, 01 Jul 2014 11:06:42 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Mark Brown <broonie@linaro.org>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Carlo Caione <carlo@caione.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH resend v2 0/3]  mfd-core: Don't register supplies from
 add_device, add register_supply_aliases()
References: <1404138369-23907-1-git-send-email-hdegoede@redhat.com> <20140701090524.GC27971@lee--X1>
In-Reply-To: <20140701090524.GC27971@lee--X1>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/01/2014 11:05 AM, Lee Jones wrote:
>> I already send this series before (in time for 3.16) and AFAIK we agreed
>> on going with this series instead of the incomplete fix for the related oops
>> which now has been merged as commit d137be00ee017bc40e6027cb66d667a2e0b450fd
>>
>> I still believe that this series is the more correct fix, as platform
>> devices must simply not be used at all before they have been added.
> 
> We were waiting for Mark's comments.  Which we still have to do.
> 
> As they never appeared the temporary fix went in instead.
> 
> Moving forward, should that fix be reverted, or it is okay just to
> apply this set on top?

The resend has been rebased on top of the fix, so it should be applied
on top.

Regards,

Hans
