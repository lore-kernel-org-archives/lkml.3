Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbaJHK6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 06:58:20 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:10153 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbaJHK6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 06:58:17 -0400
X-IronPort-AV: E=Sophos;i="5.04,677,1406617200"; 
   d="scan'208";a="47693303"
Message-ID: <543518C7.9070809@broadcom.com>
Date: Wed, 8 Oct 2014 03:58:15 -0700
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        <bcm-kernel-feedback-list@broadcom.com>,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, <devicetree@vger.kernel.org>,
        Ray Jui <rjui@broadcom.com>, <linux-kernel@vger.kernel.org>,
        Jonathan Richardson <jonathar@broadcom.com>,
        JD Zheng <jdzheng@broadcom.com>
Subject: Re: [PATCH 3/6] dt-bindings: Document Broadcom Cygnus SoC and clock
 driver
References: <1412746025-11998-4-git-send-email-sbranden@broadcom.com> <2480056.Cs3dr8EM2e@wuerfel>
In-Reply-To: <2480056.Cs3dr8EM2e@wuerfel>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-10-08 12:57 AM, Arnd Bergmann wrote:
> On Tuesday 07 October 2014 22:27:02 Scott Branden wrote:
>> diff --git a/Documentation/devicetree/bindings/arm/cygnus.txt b/Documentation/devicetree/bindings/arm/cygnus.txt
>> new file mode 100644
>> index 0000000..a210377
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/arm/cygnus.txt
>> @@ -0,0 +1,12 @@
>> +Broadcom Cygnus device tree bindings
>> +------------------------------------
>> +
>> +All Cygnus boards shall have the following properties:
>> +
>> +Required root node property:
>> +       - compatible = "brcm,cygnus";
>
> Can you add a more specific model number for the soc as well?
> I assume that cygnus refers to more than one model, so you
> should probably list both the family and the individual
> SoC type here.
Add specific model numbers does not seem necessary because they are not 
needed to be specified in the device tree for compatible purposes for 
the kernel to work.  Plus, the list of model numbers will continue to 
grow over time and compatible strings would need to be added to the 
kernel for no apparent reason?
>
>> +Boards variants shall have the following additional properties:
>> +
>> +Required root node property for the BCM911360_ENTPHN board:
>> +       - compatible = "brcm,bcm911360_entphn";
>>
>
> We normally don't list specific boards here, since it's hard to
> keep up.
Thanks - removed specific boards from file and moved the cygnus.txt file 
to devicetree/bindings/arm/bcm/cygnus.txt in next version.  This seems 
to be like the appropriate place to put this document. We will need to 
add back in board specific bindings when ALSA support is added.  But 
that will be a later commit to deal with.
>
> 	Arnd
>

