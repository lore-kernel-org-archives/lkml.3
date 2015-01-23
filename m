Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbbAWP3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:29:50 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47732 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbbAWP3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:29:48 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "Fu\, Zhonghui" <zhonghui.fu@linux.intel.com>, <brudley@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>, <meuleman@broadcom.com>,
        <linville@tuxdriver.com>, <pieterpg@broadcom.com>,
        <hdegoede@redhat.com>, <wens@csie.org>,
        <linux-wireless@vger.kernel.org>, <brcm80211-dev-list@broadcom.com>,
        <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcmfmac: avoid duplicated suspend/resume operation
References: <54BDCC06.8090107@linux.intel.com>
	<87twzincvz.fsf@kamboji.qca.qualcomm.com>
	<54C1012F.1020400@cogentembedded.com> <54C1646B.4080409@broadcom.com>
Date: Fri, 23 Jan 2015 17:29:40 +0200
In-Reply-To: <54C1646B.4080409@broadcom.com> (Arend van Spriel's message of
	"Thu, 22 Jan 2015 21:58:19 +0100")
Message-ID: <87y4otldln.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arend van Spriel <arend@broadcom.com> writes:

> On 01/22/15 14:54, Sergei Shtylyov wrote:
>> Hello.
>>
>> On 1/22/2015 4:49 PM, Kalle Valo wrote:
>>
>>>> >From 04d3fa673897ca4ccbea6c76836d0092dba2484a Mon Sep 17 00:00:00 2001
>>>> From: Zhonghui Fu <zhonghui.fu@linux.intel.com>
>>>> Date: Tue, 20 Jan 2015 11:14:13 +0800
>>>> Subject: [PATCH] brcmfmac: avoid duplicated suspend/resume operation
>>
>>>> WiFi chip has 2 SDIO functions, and PM core will trigger
>>>> twice suspend/resume operations for one WiFi chip to do
>>>> the same things. This patch avoid this case.
>>
>>>> Acked-by: Arend van Spriel <arend@broadcom.com>
>>>> Acked-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>>>> Acked-by: Kalle Valo <kvalo@codeaurora.org>
>>>> Signed-off-by: Zhonghui Fu <zhonghui.fu@linux.intel.com>
>>
>>> I don't remember giving Acked-by to this (or for matter to anything for
>>> a long time). What about Sergei or Arend?
>>
>> I haven't ACK'ed this patch either.
>
> I did ACK the initial patch and felt it still valid for this 'V2' patch.

Ok, thanks. So the patch is good, Zhonghui just needs to remove the two
acked-by lines.

-- 
Kalle Valo
