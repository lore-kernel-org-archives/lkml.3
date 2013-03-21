Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307Ab3CUO0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 10:26:49 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:37237 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab3CUO0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 10:26:48 -0400
Message-ID: <514B18A5.20001@gmail.com>
Date: Thu, 21 Mar 2013 09:26:45 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <Pawel.Moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "haojian.zhuang@linaro.org" <haojian.zhuang@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH 01/11] OF: add empty of_device_is_available for !OF
References: <1363820051-24428-1-git-send-email-robherring2@gmail.com> <1363820051-24428-2-git-send-email-robherring2@gmail.com> <20130321141812.GG15279@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130321141812.GG15279@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2013 09:18 AM, Mark Rutland wrote:
> On Wed, Mar 20, 2013 at 10:54:01PM +0000, Rob Herring wrote:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> Add an empty version of of_device_is_available.
>>
>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>> ---
>>  include/linux/of.h |    5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/include/linux/of.h b/include/linux/of.h
>> index a0f1292..6fe655b 100644
>> --- a/include/linux/of.h
>> +++ b/include/linux/of.h
>> @@ -379,6 +379,11 @@ static inline int of_device_is_compatible(const struct device_node *device,
>>  	return 0;
>>  }
>>  
>> +static inline int of_device_is_available(const struct device_node *device,)
> 
> I assume that comma shouldn't be there?                                     ^

Right. I've fixed that up in my git tree.

Rob

