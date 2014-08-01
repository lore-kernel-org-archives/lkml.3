Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbaHAMtr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 08:49:47 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:41012 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796AbaHAMtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 08:49:45 -0400
Message-ID: <53DB8CEA.9010902@cogentembedded.com>
Date: Fri, 01 Aug 2014 16:49:46 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, nsekhar@ti.com, robh+dt@kernel.org
CC: devicetree@vger.kernel.org, davinci-linux-open-source@linux.davincidsp.com,
        linux@arm.linux.org.uk, pawel.moll@arm.com,
        khilman@deeprootsystems.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 5/6] ARM: DTS: da850-evm: Add node for tlv320aic3106 codec
References: <1406801934-23334-1-git-send-email-peter.ujfalusi@ti.com> <1406801934-23334-6-git-send-email-peter.ujfalusi@ti.com> <53DA519A.4090905@cogentembedded.com> <53DB240F.2030908@ti.com>
In-Reply-To: <53DB240F.2030908@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01-08-2014 9:22, Peter Ujfalusi wrote:

>>> The board uses aic3106 for audio.

>>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>>> ---
>>>    arch/arm/boot/dts/da850-evm.dts | 14 ++++++++++++++
>>>    1 file changed, 14 insertions(+)

>>> diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
>>> index 09118c72e83f..b9ef2be0b145 100644
>>> --- a/arch/arm/boot/dts/da850-evm.dts
>>> +++ b/arch/arm/boot/dts/da850-evm.dts
>>> @@ -51,6 +51,20 @@
>>>                tps: tps@48 {
>>>                    reg = <0x48>;
>>>                };
>>> +            tlv320aic3106: tlv320aic3106@1b {

[...]

>> Also, the ePAPR standard [1] says:

>> The name of a node should be somewhat generic, reflecting the function of the
>> device and not its precise programming model.

> True. This is why the node for the audio support is named as 'sound'. For the
> components, like in this case I do not see issue to call the audio codec with
> it's name.

    I do. We should follow the standard consistently. Why not call the node 
"sound-codec"?

WBR, Sergei

