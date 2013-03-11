Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab3CKRxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:53:30 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4661 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab3CKRx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:53:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 11 Mar 2013 10:47:00 -0700
Message-ID: <513E19A8.5060403@nvidia.com>
Date: Mon, 11 Mar 2013 23:21:36 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 2/5] rtc: tegra: Use struct dev_pm_ops for power management
References: <1362991468-30226-1-git-send-email-ldewangan@nvidia.com> <1362991468-30226-3-git-send-email-ldewangan@nvidia.com> <20130311085132.GA7900@avionic-0098.mockup.avionic-design.de> <513D9C48.8090505@nvidia.com> <513E11EE.1020405@wwwdotorg.org>
In-Reply-To: <513E11EE.1020405@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 March 2013 10:48 PM, Stephen Warren wrote:
> On 03/11/2013 02:56 AM, Laxman Dewangan wrote:
>> On Monday 11 March 2013 02:21 PM, Thierry Reding wrote:
>>> * PGP Signed by an unknown key
>>>
>>> On Mon, Mar 11, 2013 at 02:14:25PM +0530, Laxman Dewangan wrote:
>>> [...]
>>>> diff --git a/drivers/rtc/rtc-tegra.c b/drivers/rtc/rtc-tegra.c
>>> [...]
>>>> @@ -431,6 +430,8 @@ static int tegra_rtc_resume(struct
>>>> platform_device *pdev)
>>>>    }
>>>>    #endif
>>>>    +SIMPLE_DEV_PM_OPS(tegra_rtc_pm_ops, tegra_rtc_suspend,
>>>> tegra_rtc_resume);
>>> I should've been more explicit. Since you had this marked as static in
>>> the previous patch, this needs to be static SIMPLE_DEV_PM_OPS.
>> Yaah, I should keep the static.
>>
>> I think I will need to respin this patch only in place of whole series.
>>
>> Andrew,
>>
>> Let me know if this is fine.
> In general, it's much easier if you repost a whole series. Otherwise,
> you make the maintainer manually piece together the series from bits of
> V2 and bits of V3, which is harder than just grabbing all of V3.

yaah, this will be easy. I will respin 3rd version.

Thanks,
Laxman


