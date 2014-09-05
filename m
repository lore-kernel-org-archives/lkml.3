Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbaIEAdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 20:33:33 -0400
Received: from regular1.263xmail.com ([211.150.99.132]:38447 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaIEAdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 20:33:31 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: zyf@rock-chips.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <f4aadac526d095f39719ce7399789bd9>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <540904D3.1070004@rock-chips.com>
Date: Fri, 05 Sep 2014 08:33:23 +0800
From: Caesar Wang <caesar.wang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, huangtao@rock-chips.com, cf@rock-chips.com,
        dianders@chromium.org, zyw@rock-chips.com, addy.ke@rock-chips.com,
        zhaoyifeng <zyf@rock-chips.com>
Subject: Re: [PATCH v4 1/4] thermal: rockchip: add driver for thermal
References: <1409710239-19941-1-git-send-email-caesar.wang@rock-chips.com> <1409710239-19941-2-git-send-email-caesar.wang@rock-chips.com> <20140904170559.GB10224@core.coreip.homeip.net>
In-Reply-To: <20140904170559.GB10224@core.coreip.homeip.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


在 2014年09月05日 01:06, Dmitry Torokhov 写道:
> Hi Caesar,
>
> On Wed, Sep 03, 2014 at 10:10:36AM +0800, Caesar Wang wrote:
>> +static int rockchip_thermal_remove(struct platform_device *pdev)
>> +{
>> +	struct rockchip_thermal_data *data = platform_get_drvdata(pdev);
>> +
>> +	rockchip_thermal_control(data, false);
>> +
>> +	thermal_zone_device_unregister(data->tz);
>> +	cpufreq_cooling_unregister(data->cdev);
>> +	cpufreq_cooling_unregister(data->cdev);
> It looks like we are unregistering the same cooling device one too many times.
>
> Thanks.
>
yes,I made a stupid mistake.  Thanks~

-- 
Best regards,
Caesar


