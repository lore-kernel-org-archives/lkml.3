Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab3FKDVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 23:21:47 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:58839 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab3FKDVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 23:21:46 -0400
Message-ID: <51B697C2.7010701@linaro.org>
Date: Tue, 11 Jun 2013 08:51:38 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: linux-kernel@vger.kernel.org, thierry.reding@gmail.com, patches@linaro.org,
        linux-usb@vger.kernel.org, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 14/15] usb: phy: rcar-usb: Fix comment w.r.t. devm_ioremap_resource
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org> <1370864113-17895-15-git-send-email-tushar.behera@linaro.org> <51B5C3D3.9000609@cogentembedded.com>
In-Reply-To: <51B5C3D3.9000609@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 05:47 PM, Sergei Shtylyov wrote:
> Hello.
> 
> On 10-06-2013 15:35, Tushar Behera wrote:
> 

[ ... ]

>>        * CAUTION
>>        *
>>        * Because this phy address is also mapped under OHCI/EHCI
>> address area,
>> -     * this driver can't use devm_request_and_ioremap(dev, res) here
>> +     * this driver can't use devm_ioremap_resource(dev, res) here
>>        */
>>       reg0 = devm_ioremap_nocache(dev, res0->start, resource_size(res0));
>>       reg1 = devm_ioremap_nocache(dev, res1->start, resource_size(res1));
> 
>     I'm completely removing this comment in my series pushed thru
> renesas.git, so I advise this patch to be ignored not to create conflict
> in the future.
> 

Ok. I will drop this from the patchset.

> WBR, Sergei
> 

Thanks.

-- 
Tushar Behera
