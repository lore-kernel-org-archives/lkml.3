Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbaDWFvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 01:51:54 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49442 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376AbaDWFvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 01:51:52 -0400
Message-ID: <535754F3.6020003@ti.com>
Date: Wed, 23 Apr 2014 11:21:47 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: <myungjoo.ham@samsung.com>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <balbi@ti.com>
Subject: Re: [PATCH] extcon: palmas: explicitly set edev name as node name
References: <1395989462-14613-1-git-send-email-kishon@ti.com> <534614DB.9000805@samsung.com>
In-Reply-To: <534614DB.9000805@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On Thursday 10 April 2014 09:19 AM, Chanwoo Choi wrote:
> Hi Kishon,
> 
> On 03/28/2014 03:51 PM, Kishon Vijay Abraham I wrote:
>> commit ca488 (extcon: of: Remove unnecessary function call by using the
>> name of device_node) started using node name instead of device name
>> to get the extcon device. This breaks dwc3-omap since it's not able to
>> get the extcon device anymore. Fixed it by setting edev name of
>> palmas to be the same as its node name.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> Reported-by: Felipe Balbi <balbi@ti.com>
>> ---
> 
> Applied this patch
> but, you could check this patch on extcon-next branch
> after few days. becuase I have firewall issue of kerner.org.

I see the commit being merged in extcon-next branch. Will you be sending it in
this -rc cycle?

Thanks
Kishon
