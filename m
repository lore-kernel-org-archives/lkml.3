Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbbAWSJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:09:54 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:17017 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbbAWSJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:09:52 -0500
X-IronPort-AV: E=Sophos;i="5.09,455,1418112000"; 
   d="scan'208";a="55310031"
Message-ID: <54C28E6B.8090408@broadcom.com>
Date: Fri, 23 Jan 2015 19:09:47 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>, <brudley@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>, <meuleman@broadcom.com>,
        <linville@tuxdriver.com>, <pieterpg@broadcom.com>,
        <hdegoede@redhat.com>, <wens@csie.org>,
        <linux-wireless@vger.kernel.org>, <brcm80211-dev-list@broadcom.com>,
        <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcmfmac: avoid duplicated suspend/resume operation
References: <54BDCC06.8090107@linux.intel.com>	<87twzincvz.fsf@kamboji.qca.qualcomm.com>	<54C1012F.1020400@cogentembedded.com> <54C1646B.4080409@broadcom.com> <87y4otldln.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87y4otldln.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/15 16:29, Kalle Valo wrote:
> Arend van Spriel<arend@broadcom.com>  writes:
>
>> On 01/22/15 14:54, Sergei Shtylyov wrote:
>>> Hello.
>>>
>>> On 1/22/2015 4:49 PM, Kalle Valo wrote:
>>>
>>>>> > From 04d3fa673897ca4ccbea6c76836d0092dba2484a Mon Sep 17 00:00:00 2001
>>>>> From: Zhonghui Fu<zhonghui.fu@linux.intel.com>
>>>>> Date: Tue, 20 Jan 2015 11:14:13 +0800
>>>>> Subject: [PATCH] brcmfmac: avoid duplicated suspend/resume operation
>>>
>>>>> WiFi chip has 2 SDIO functions, and PM core will trigger
>>>>> twice suspend/resume operations for one WiFi chip to do
>>>>> the same things. This patch avoid this case.
>>>
>>>>> Acked-by: Arend van Spriel<arend@broadcom.com>
>>>>> Acked-by: Sergei Shtylyov<sergei.shtylyov@cogentembedded.com>
>>>>> Acked-by: Kalle Valo<kvalo@codeaurora.org>
>>>>> Signed-off-by: Zhonghui Fu<zhonghui.fu@linux.intel.com>
>>>
>>>> I don't remember giving Acked-by to this (or for matter to anything for
>>>> a long time). What about Sergei or Arend?
>>>
>>> I haven't ACK'ed this patch either.
>>
>> I did ACK the initial patch and felt it still valid for this 'V2' patch.
>
> Ok, thanks. So the patch is good, Zhonghui just needs to remove the two
> acked-by lines.

Indeed.

Regards,
Arend
