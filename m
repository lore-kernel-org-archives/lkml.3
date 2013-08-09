Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967990Ab3HIPjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 11:39:40 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:9202 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965056Ab3HIPji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 11:39:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 09 Aug 2013 08:37:50 -0700
Message-ID: <52051083.4070403@nvidia.com>
Date: Fri, 9 Aug 2013 21:23:39 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "kishon@ti.com" <kishon@ti.com>, Stephen Warren <swarren@nvidia.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "Mark.Rutland@arm.com" <Mark.Rutland@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "broonie@kernel.org" <broonie@kernel.org>
Subject: Re: [PATCH] drivers/rtc/rtc-palmas.c: rename charging dt property
 name
References: <1376063230-22578-1-git-send-email-ldewangan@nvidia.com> <105188C0-FD22-488B-B9D2-1E3C801616B6@codeaurora.org>
In-Reply-To: <105188C0-FD22-488B-B9D2-1E3C801616B6@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 August 2013 09:07 PM, Kumar Gala wrote:
> On Aug 9, 2013, at 10:47 AM, Laxman Dewangan wrote:
>
>> Renaming the charging property names to have more meaningful:
>>
>> Renaming property "ti,back-battery-charge-enable" to "ti,backup-battery-chargeable"
>> to tells OS that attahced battery is chargeable and OS can do charging.
>>
>> Renaming property "ti,back-battery-charge-low-current" to
>> "ti,backup-battery-charge-high-current" for safe configuration as maximum charging current
>> of battery depends on battery type and overcurrent charging can damage the battery. So
>> enable the high current charging only if this property is available.
>>
>> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
>> ---
>> The patch V4 version of the change
>> [PATCH V4] drivers/rtc/rtc-palmas.c: support for backup battery charging
>> is already applied but still the discussion is going on the property name.
>>
>> To correct the property name, I am sending this patch on top of above patch
>> as per discussion on above patch.
>>
>> .../devicetree/bindings/rtc/rtc-palmas.txt         |   21 +++++++++++--------
>> drivers/rtc/rtc-palmas.c                           |   14 ++++++------
>> 2 files changed, 19 insertions(+), 16 deletions(-)
> Are you not concerned about any dts with the old property names being around such that the code should support the old name as well?
>

I introduced these properties on above patch and it applied yesterday 
only. Hence no one is using now. So no issue here.

