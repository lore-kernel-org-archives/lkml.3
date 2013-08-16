Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab3HPPsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:48:40 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:48750 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab3HPPs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:48:29 -0400
Message-ID: <520E49CA.9010800@linaro.org>
Date: Fri, 16 Aug 2013 11:48:26 -0400
From: Matt Porter <matt.porter@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: balbi@ti.com
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH 2/2] usb: gadget: ffs: add ACM + FunctionFS configuration
References: <1376666868-32581-1-git-send-email-matt.porter@linaro.org> <1376666868-32581-3-git-send-email-matt.porter@linaro.org> <20130816153226.GO15861@radagast>
In-Reply-To: <20130816153226.GO15861@radagast>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2013 11:32 AM, Felipe Balbi wrote:
> On Fri, Aug 16, 2013 at 11:27:48AM -0400, Matt Porter wrote:
>> Adds an additional configuration to g_ffs to allow for
>> CDC ACM support in conjuction with FunctionFS. A module
>> parameter is added to allow for multiple ACM ports to
>> be instantiated.
>>
>> Signed-off-by: Matt Porter <matt.porter@linaro.org>
>
> the whole idea of the configfs interface was that we wouldn't add this
> sort of patch to the kernel anymore. What's wrong with building your
> device through configfs in userland ?
>

That would be nice. Unless I missed it, we don't have support for ffs
via the gadget configfs framework. That's what drove this as I wanted 
ACM + a ffs driven function. I'll look into adding an ffs option.

Thanks,
Matt
