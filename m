Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbaDYG1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 02:27:49 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44197 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbaDYG1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 02:27:47 -0400
Message-ID: <535A0047.5030807@ti.com>
Date: Fri, 25 Apr 2014 09:27:19 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>, Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Sricharan R <r.sricharan@ti.com>
CC: Sekhar Nori <nsekhar@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 00/19] bus: omap_l3_noc: driver cleanups and support
 for DRA7/AM4372
References: <1397492726-17203-1-git-send-email-nm@ti.com> <1397767775-10965-1-git-send-email-nm@ti.com> <53504041.7090906@ti.com> <5350410B.5010507@ti.com> <5358D16A.9000500@ti.com> <53591D6D.3060507@ti.com>
In-Reply-To: <53591D6D.3060507@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 05:19 PM, Nishanth Menon wrote:
> On 04/24/2014 03:55 AM, Peter Ujfalusi wrote:
>> On 04/18/2014 12:00 AM, Nishanth Menon wrote:
>>> On 04/17/2014 03:57 PM, Santosh Shilimkar wrote:
>>>> I looked at the series and its looks pretty good. Thanks for fixups, updates.
>>>> For whole series,
>>>> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>>>>
>>>
>>> Thanks.
>>>
>>>>> Patches(including Peter's) is available here:
>>>>> https://github.com/nmenon/linux-2.6-playground/commits/l3noc/driver-fixes-v2
>>>>>
>>>> Can Tony pull this branch for 3.16 then which includes Peter's series as well ?
>>>
>>> there is just an empty commit with information about peter's patches
>>> that i lined up to differentiate the series.. I can drop it if Tony
>>> would like me to.
>>
>> Looking at the branch I see my patches underneath so they are in the branch.
>> It would be great if Tony pulls this... Will be a great present to my patches
>> (omap_l3 patches in the branch) for their 1 year anniversary of being out on
>> the mailing list ;)
>>
> Peter, can I take this as an Ack for this series? if yes, I can repost
> a v3 with all the acks, updates together.

Nishanth, sure you can add my Ack or Reviewed-by.

-- 
Péter
