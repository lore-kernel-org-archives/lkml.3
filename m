Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964886Ab3FSTpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 15:45:08 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:37070 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935125Ab3FSTpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 15:45:01 -0400
MIME-Version: 1.0
In-Reply-To: <1371603747-27436-3-git-send-email-rvaswani@codeaurora.org>
References: <1371603747-27436-1-git-send-email-rvaswani@codeaurora.org>
	<1371603747-27436-3-git-send-email-rvaswani@codeaurora.org>
Date: Wed, 19 Jun 2013 21:45:01 +0200
Message-ID: <CACRpkdbYimoG1H4U8gKTN=jkX2S6_SK8jtfii2-kKWhQW58drQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] drivers: gpio: msm: Fix the error condition for
 reading ngpio
From: Linus Walleij <linus.walleij@linaro.org>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 3:02 AM, Rohit Vaswani <rvaswani@codeaurora.org> wrote:

> of_property_read_u32 return 0 on success. The check was using a ! to
> return error. Fix the if condition.
>
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

I guess this is going through the MSM tree as well?

Yours,
Linus Walleij
