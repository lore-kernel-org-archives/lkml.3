Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbbAVNzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 08:55:00 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:56905 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbbAVNy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 08:54:58 -0500
Message-ID: <54C1012F.1020400@cogentembedded.com>
Date: Thu, 22 Jan 2015 16:54:55 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>,
        "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
CC: brudley@broadcom.com, Arend van Spriel <arend@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>, meuleman@broadcom.com,
        linville@tuxdriver.com, pieterpg@broadcom.com, hdegoede@redhat.com,
        wens@csie.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list@broadcom.com, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcmfmac: avoid duplicated suspend/resume operation
References: <54BDCC06.8090107@linux.intel.com> <87twzincvz.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87twzincvz.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 1/22/2015 4:49 PM, Kalle Valo wrote:

>> >From 04d3fa673897ca4ccbea6c76836d0092dba2484a Mon Sep 17 00:00:00 2001
>> From: Zhonghui Fu <zhonghui.fu@linux.intel.com>
>> Date: Tue, 20 Jan 2015 11:14:13 +0800
>> Subject: [PATCH] brcmfmac: avoid duplicated suspend/resume operation

>> WiFi chip has 2 SDIO functions, and PM core will trigger
>> twice suspend/resume operations for one WiFi chip to do
>> the same things. This patch avoid this case.

>> Acked-by: Arend van Spriel <arend@broadcom.com>
>> Acked-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>> Acked-by: Kalle Valo <kvalo@codeaurora.org>
>> Signed-off-by: Zhonghui Fu <zhonghui.fu@linux.intel.com>

> I don't remember giving Acked-by to this (or for matter to anything for
> a long time). What about Sergei or Arend?

    I haven't ACK'ed this patch either.

WBR, Sergei

