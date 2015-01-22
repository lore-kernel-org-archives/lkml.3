Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbbAVNuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 08:50:04 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:55465 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbbAVNuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 08:50:01 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: "Fu\, Zhonghui" <zhonghui.fu@linux.intel.com>
Cc: brudley@broadcom.com, Arend van Spriel <arend@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>, meuleman@broadcom.com,
        linville@tuxdriver.com, pieterpg@broadcom.com, hdegoede@redhat.com,
        wens@csie.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list@broadcom.com, netdev@vger.kernel.org,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcmfmac: avoid duplicated suspend/resume operation
References: <54BDCC06.8090107@linux.intel.com>
Date: Thu, 22 Jan 2015 15:49:52 +0200
In-Reply-To: <54BDCC06.8090107@linux.intel.com> (Zhonghui Fu's message of
	"Tue, 20 Jan 2015 11:31:18 +0800")
Message-ID: <87twzincvz.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Fu, Zhonghui" <zhonghui.fu@linux.intel.com> writes:

>>From 04d3fa673897ca4ccbea6c76836d0092dba2484a Mon Sep 17 00:00:00 2001
> From: Zhonghui Fu <zhonghui.fu@linux.intel.com>
> Date: Tue, 20 Jan 2015 11:14:13 +0800
> Subject: [PATCH] brcmfmac: avoid duplicated suspend/resume operation
>
> WiFi chip has 2 SDIO functions, and PM core will trigger
> twice suspend/resume operations for one WiFi chip to do
> the same things. This patch avoid this case.
>
> Acked-by: Arend van Spriel <arend@broadcom.com>
> Acked-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Acked-by: Kalle Valo <kvalo@codeaurora.org>
> Signed-off-by: Zhonghui Fu <zhonghui.fu@linux.intel.com>

I don't remember giving Acked-by to this (or for matter to anything for
a long time). What about Sergei or Arend?

Please do not add Acked-by, Signed-off-by or any other tags unless
explicitly specified by the person in question. I'm dropping this,
please resend with real Acked-by lines.

-- 
Kalle Valo
