Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935599Ab3E3Rx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 13:53:57 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:34126 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935568Ab3E3Rxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 13:53:51 -0400
MIME-Version: 1.0
In-Reply-To: <1369161163-6448-2-git-send-email-rvaswani@codeaurora.org>
References: <1369161163-6448-1-git-send-email-rvaswani@codeaurora.org>
	<1369161163-6448-2-git-send-email-rvaswani@codeaurora.org>
Date: Thu, 30 May 2013 19:53:51 +0200
Message-ID: <CACRpkdYqiri8-VPM+uR2HrXUdFWFbanTip-v3sG98MNjxYDN8w@mail.gmail.com>
Subject: Re: [PATCH 1/3] ARM: msm: Remove gpiomux-v2 and re-organize
 MSM_GPIOMUX configs
From: Linus Walleij <linus.walleij@linaro.org>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 8:32 PM, Rohit Vaswani <rvaswani@codeaurora.org> wrote:

> Remove gpiomux-v2 as it's not being used and make way for future improvements.
>
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>

OK less problems in my world -> good.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

I hope "future improvements" mean "we're switching to pin control".

Yours,
Linus Walleij
