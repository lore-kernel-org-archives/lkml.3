Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab3BEIVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 03:21:15 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:47283 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751426Ab3BEIVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 03:21:13 -0500
Message-ID: <5110C0F2.1080108@marvell.com>
Date: Tue, 05 Feb 2013 16:21:06 +0800
From: Qing Xu <qingx@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Haojian Zhuang <haojian.zhuang@linaro.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Chao Xie <cxie4@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: Re: [PATCH 1/6] mfd: max8925: add irqdomain for dt
References: <1359992448-22229-1-git-send-email-haojian.zhuang@linaro.org> <20130205081924.GM8476@sortiz-mobl>
In-Reply-To: <20130205081924.GM8476@sortiz-mobl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Feb 2013 08:21:06.0412 (UTC) FILETIME=[BE9BA2C0:01CE0379]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 04:19 PM, Samuel Ortiz wrote:
> Hi Haojian,
>
> On Mon, Feb 04, 2013 at 11:40:42PM +0800, Haojian Zhuang wrote:
>> From: Qing Xu <qingx@marvell.com>
>>
>> Add irqdomains for max8925's main irq, wrap irq register operations
>> into irqdomain's map func. it is necessary for dt support.
>>
>> Also, add dt support for max8925 driver.
>>
>> Signed-off-by: Qing Xu <qingx@marvell.com>
>> Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
>> ---
>>   drivers/mfd/max8925-core.c  |   73 +++++++++++++++++++++++++------------------
>>   drivers/mfd/max8925-i2c.c   |   36 +++++++++++++++++++--
>>   include/linux/mfd/max8925.h |    3 +-
>>   3 files changed, 78 insertions(+), 34 deletions(-)
> This and the next 5 patches applied, thanks for the heads up.
>
> Cheers,
> Samuel.
>
Hi Samuel, Haojian,

Thank you very much!

-Qing
