Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966384Ab3E2Oxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 10:53:55 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46878 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966245Ab3E2Oxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 10:53:54 -0400
Message-ID: <51A60E7E.2070905@ti.com>
Date: Wed, 29 May 2013 16:19:42 +0200
From: "Cousson, Benoit" <b-cousson@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 3/3] arm: dts: add bandgap entry for OMAP4460 devices
References: <1368629928-6723-1-git-send-email-eduardo.valentin@ti.com> <1368629928-6723-4-git-send-email-eduardo.valentin@ti.com> <5193A875.1020000@ti.com> <5193B9AA.7020507@ti.com> <519488D3.5070003@ti.com> <5194D0AF.3010407@ti.com> <51A60C74.4010307@ti.com>
In-Reply-To: <51A60C74.4010307@ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

On 5/29/2013 4:11 PM, Eduardo Valentin wrote:
> Salut Monsieur Benoit,
>
> On 16-05-2013 08:27, Eduardo Valentin wrote:
>> On 16-05-2013 03:20, Benoit Cousson wrote:
>>> Hi Eduardo,
>>>
>
> <cut>
>
>>> We need to check.
>>
>> Yeah, I also dont think this will work, because we will reparent the
>> interrupt, setting to a different controller. That will break the TALERT
>> signal already defined at GIC (check original patch).
>>
>> I propose keeping the way I sent. Unless there is a way to set two
>> different controllers to same device.
>>
>
> Any idea on this patch? Shall we keep the way it is?

Well since we cannot use directly interrupt, I think we need to use at 
least the proper gpio binding.

Thanks,
Benoit

