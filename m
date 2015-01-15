Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbbAOMwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 07:52:20 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:59292 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbbAOMwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:52:18 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: "Fu\, Zhonghui" <zhonghui.fu@linux.intel.com>, <brudley@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>, <meuleman@broadcom.com>,
        <linville@tuxdriver.com>, <pieterpg@broadcom.com>,
        <hdegoede@redhat.com>, <wens@csie.org>,
        <linux-wireless@vger.kernel.org>, <brcm80211-dev-list@broadcom.com>,
        <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcmfmac: avoid duplicated suspend/resume operation
References: <54B36C88.3030609@linux.intel.com> <54B39B59.8000907@broadcom.com>
Date: Thu, 15 Jan 2015 14:52:09 +0200
In-Reply-To: <54B39B59.8000907@broadcom.com> (Arend van Spriel's message of
	"Mon, 12 Jan 2015 11:00:57 +0100")
Message-ID: <877fwotddy.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arend van Spriel <arend@broadcom.com> writes:

> On 01/12/15 07:41, Fu, Zhonghui wrote:
>>  From 8685c3c2746b4275fc808d9db23c364b2f54b52a Mon Sep 17 00:00:00 2001
>> From: Zhonghui Fu<zhonghui.fu@linux.intel.com>
>> Date: Mon, 12 Jan 2015 14:25:46 +0800
>> Subject: [PATCH] brcmfmac: avoid duplicated suspend/resume operation
>>
>> WiFi chip has 2 SDIO functions, and PM core will trigger
>> twice suspend/resume operations for one WiFi chip to do
>> the same things. This patch avoid this case.
>>
>> Acked-by: Arend van Spriel<arend@broadcom.com>
>> Acked-by: Sergei Shtylyov<sergei.shtylyov@cogentembedded.com>
>> Signed-off-by: Zhonghui Fu<zhonghui.fu@linux.intel.com>
>
> This patch needs to be rebased.
>
> Kalle,
>
> Please drop this one.

Ok, dropped. I'll wait for the rebase.

-- 
Kalle Valo
