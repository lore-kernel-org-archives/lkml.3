Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbaDKIHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 04:07:08 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:9373 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaDKIGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 04:06:55 -0400
X-IronPort-AV: E=Sophos;i="4.97,840,1389772800"; 
   d="scan'208";a="23771425"
Message-ID: <5347A29C.7020602@broadcom.com>
Date: Fri, 11 Apr 2014 10:06:52 +0200
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?J=F6rg_Krause?= <jk@lintech.de>,
        <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [RFC] dt: bindings: add bindings for Broadcom bcm43xx sdio devices
References: <1392059868-8782-1-git-send-email-arend@broadcom.com> <52FC8CB3.4090305@gmail.com> <CAGb2v67za+5yW3RE0pwBWk-NdTUSm-JkKE+j9NLjbBkE_Fc1hQ@mail.gmail.com> <5337DC2E.5040000@broadcom.com> <1397165245229-838046.post@n7.nabble.com>
In-Reply-To: <1397165245229-838046.post@n7.nabble.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/14 23:27, Jörg Krause wrote:
> On 02/13/14 10:28, Chen-Yu Tsai wrote:
>> Hi,
>>
>> On Thu, Feb 13, 2014 at 5:13 PM, Tomasz Figa&lt;tomasz.figa@&gt;  wrote:
>>> Hi Arend,
>>>
>>>
>>> On 10.02.2014 20:17, Arend van Spriel wrote:
>
> [...]
>
> Hi Chen-Yu,
>
> picking up this thread.
>
>> AFAIK, the pinctrl in tied to the device node, and is selected when the
>> device
>> is registered. The MMC subsystem currently does not register child nodes,
>> so
>> this would be useless.
>
> So if MMC does not register child nodes, brcmfmac will not be probed
> with of_node set? Have there been patches submitted for this in mmc
> subsystem recently.
>
> [...]
>
>
>
> Sascha Hauer submitted a patch a week ago. Link:
> https://lkml.org/lkml/2014/4/3/522 <https://lkml.org/lkml/2014/4/3/522>

Thanks, Jörg

It is a partial solution, but it seems to conflict with my change. So 
thanks for the heads up. I am not convinced whether the GPIO and clock 
should be bound to the function. They seem more a property of the 
card/device inserted.

Regards,
Arend
> --
> View this message in context: http://linux-kernel.2935.n7.nabble.com/RFC-dt-bindings-add-bindings-for-Broadcom-bcm43xx-sdio-devices-tp801976p838046.html
> Sent from the Linux Kernel mailing list archive at Nabble.com.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

