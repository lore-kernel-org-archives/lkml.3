Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030714Ab3HIOrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 10:47:35 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37319 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030474Ab3HIOre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 10:47:34 -0400
Message-ID: <520500F2.2000200@ti.com>
Date: Fri, 9 Aug 2013 09:47:14 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bill Huang <bilhuang@nvidia.com>
CC: Lee Jones <lee.jones@linaro.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "j-keerthy@ti.com" <j-keerthy@ti.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mallikarjun Kasoju <mkasoju@nvidia.com>
Subject: Re: [PATCH RESEND v2 1/1] mfd: palmas: Add power off control
References: <1375962305-7438-1-git-send-email-bilhuang@nvidia.com>  <20130808123203.GD14515@lee--X1> <1376053269.20259.34.camel@bilhuang-vm1>
In-Reply-To: <1376053269.20259.34.camel@bilhuang-vm1>
Content-Type: text/plain; charset="ISO-8859-9"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 08:01 AM, Bill Huang wrote:
> On Thu, 2013-08-08 at 20:32 +0800, Lee Jones wrote:
>> On Thu, 08 Aug 2013, Bill Huang wrote:
>>
>>> Hook up "pm_power_off" to palmas power off routine if there is DT
>>> property "ti,system-power-controller" defined, so platform which is
>>> powered by this regulator can be powered off properly.
>>>
>>> Signed-off-by: Mallikarjun Kasoju <mkasoju@nvidia.com>
>>> Signed-off-by: Bill Huang <bilhuang@nvidia.com>
>>> ---
>>>   .../devicetree/bindings/regulator/palmas-pmic.txt  |    5 +++
>>>   drivers/mfd/palmas.c                               |   33 ++++++++++++++++++--
>>>   include/linux/mfd/palmas.h                         |    1 +
>>>   3 files changed, 37 insertions(+), 2 deletions(-)
>>
>> Was a clear conclusion reached between Nishanth and yourself?
>>
>> As he has strong opinions on this I'd ideally like his Ack before
>> applying the patch.
>>
> Feel free to NACK if you are feeling this can't fit what you would like
> to add, then I'll pass the ball to you for implementing Palmas power off
> since you have already wrote part of the driver (with USB IRQ unmask?).
Apologies on the delay in review. As long as we are ok with not having a 
drivers/power/reset driver, I can buy this as a step #1. USB IRQ unmask 
could go on top of it.

Other than that,
Acked-by: Nishanth Menon <nm@ti.com>

-- 
Regards,
Nishanth Menon
