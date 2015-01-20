Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbbATDea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:34:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:64550 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbbATDe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:34:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,431,1418112000"; 
   d="scan'208";a="514631921"
Message-ID: <54BDCCC0.2080805@linux.intel.com>
Date: Tue, 20 Jan 2015 11:34:24 +0800
From: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>, Arend van Spriel <arend@broadcom.com>
CC: brudley@broadcom.com, Franky Lin <frankyl@broadcom.com>,
        meuleman@broadcom.com, linville@tuxdriver.com, pieterpg@broadcom.com,
        hdegoede@redhat.com, wens@csie.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list@broadcom.com, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcmfmac: avoid duplicated suspend/resume operation
References: <54B36C88.3030609@linux.intel.com> <54B39B59.8000907@broadcom.com> <877fwotddy.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <877fwotddy.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2015/1/15 20:52, Kalle Valo wrote:
> Arend van Spriel <arend@broadcom.com> writes:
>
>> On 01/12/15 07:41, Fu, Zhonghui wrote:
>>>  From 8685c3c2746b4275fc808d9db23c364b2f54b52a Mon Sep 17 00:00:00 2001
>>> From: Zhonghui Fu<zhonghui.fu@linux.intel.com>
>>> Date: Mon, 12 Jan 2015 14:25:46 +0800
>>> Subject: [PATCH] brcmfmac: avoid duplicated suspend/resume operation
>>>
>>> WiFi chip has 2 SDIO functions, and PM core will trigger
>>> twice suspend/resume operations for one WiFi chip to do
>>> the same things. This patch avoid this case.
>>>
>>> Acked-by: Arend van Spriel<arend@broadcom.com>
>>> Acked-by: Sergei Shtylyov<sergei.shtylyov@cogentembedded.com>
>>> Signed-off-by: Zhonghui Fu<zhonghui.fu@linux.intel.com>
>> This patch needs to be rebased.
>>
>> Kalle,
>>
>> Please drop this one.
> Ok, dropped. I'll wait for the rebase.
I have re-based this patch and sent it in another mail with the same subject.

Thanks,
Zhonghui
>

