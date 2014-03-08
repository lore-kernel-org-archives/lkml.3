Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbaCHHW6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 02:22:58 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60649 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbaCHHWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 02:22:55 -0500
Message-ID: <531AC52E.3010402@ti.com>
Date: Sat, 8 Mar 2014 12:52:22 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
CC: Kamil Debski <k.debski@samsung.com>, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <kyungmin.park@samsung.com>,
        <t.figa@samsung.com>, <s.nawrocki@samsung.com>,
        <m.szyprowski@samsung.com>, <gautam.vivek@samsung.com>,
        <mat.krawczuk@gmail.com>, <yulgon.kim@samsung.com>,
        <p.paneri@samsung.com>, <av.tikhomirov@samsung.com>,
        <jg1.han@samsung.com>, <galak@codeaurora.org>,
        <matt.porter@linaro.org>, <stern@rowland.harvard.edu>,
        <sander@humilis.net>
Subject: Re: [PATCH v10 2/4] phy: core: Add devm_of_phy_get to phy-core
References: <1394104609-28242-1-git-send-email-k.debski@samsung.com> <1394104609-28242-3-git-send-email-k.debski@samsung.com> <531A1F5A.7060504@math.uni-bielefeld.de>
In-Reply-To: <531A1F5A.7060504@math.uni-bielefeld.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias,

On Saturday 08 March 2014 01:04 AM, Tobias Jakobi wrote:
> Kamil Debski wrote:
>> Adding devm_of_phy_get will allow to get phys by supplying a
>> pointer to the struct device_node instead of struct device.
>>
>> Signed-off-by: Kamil Debski <k.debski@samsung.com>
>> ---
>>   drivers/phy/phy-core.c  |   31 +++++++++++++++++++++++++++++++
>>   include/linux/phy/phy.h |    8 ++++++++
>>   2 files changed, 39 insertions(+)
> Tested-by: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>

Thanks for testing these patches. However I've already queued all these 
patches so won't be able to add your 'Tested-by' :-s

Thanks
Kishon
