Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab3GPNTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 09:19:07 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:2916 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562Ab3GPNTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 09:19:05 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <51E5483F.4020209@broadcom.com>
Date: Tue, 16 Jul 2013 15:18:55 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Roger Quadros" <rogerq@ti.com>
cc: tony@atomide.com, benoit.cousson@linaro.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Balbi, Felipe" <balbi@ti.com>
Subject: Re: [PATCH v2 4/4] ARM: OMAP2+: Provide alias to USB PHY clock
References: <1371571487-14389-1-git-send-email-rogerq@ti.com>
 <1371571487-14389-5-git-send-email-rogerq@ti.com>
 <51E40199.9070906@ti.com> <51E546D2.6000100@broadcom.com>
In-Reply-To: <51E546D2.6000100@broadcom.com>
X-WSS-ID: 7DFB99892L848971782-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 03:12 PM, Arend van Spriel wrote:
> On 07/15/2013 04:05 PM, Roger Quadros wrote:
>> Hi Tony,
>>
>> On 06/18/2013 07:04 PM, Roger Quadros wrote:
>>> Till the OMAP clocks are correctly defined in device tree, use
>>> this temporary hack to provide clock alias to the USB PHY clocks.
>>>
>>> Without this, USB Host & Ethernet will not be functional with
>>> device tree boots on Panda and uEVM.
>>
>> Looks like this one got missed out.
>
> Could it be because you promised to resend it (see [1]). I was upgrading
> our test stuff to 3.11-rc1 and made a DT appended image. Boot went fine,
> but no USB/ethernet. Should I pickup all four patches?

Nevermind. The first three seem to be in already.

> Regards,
> Arend
>
> [1] http://mid.gmane.org/51C2EC5F.8050703@ti.com
>
>> USB host no longer works on Panda with DT boot.
>> Could you please queue this for next 3.11-rc? Thanks.
>>
>> cheers,
>> -roger
>>
>


