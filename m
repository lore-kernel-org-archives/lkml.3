Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbaEIId3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:33:29 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:48648 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaEIId1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:33:27 -0400
MIME-Version: 1.0
In-Reply-To: <1398794794-28920-1-git-send-email-linus.walleij@linaro.org>
References: <1398794794-28920-1-git-send-email-linus.walleij@linaro.org>
Date: Fri, 9 May 2014 10:33:26 +0200
Message-ID: <CACRpkdb7ctDocntcPG_E4b_an2G8VNd+ei0N+Uk_7XtsFssiEA@mail.gmail.com>
Subject: Re: [PATCH] RFT: pinctrl: msm: switch to using generic GPIO irqchip helpers
From: Linus Walleij <linus.walleij@linaro.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Andy Gross <agross@codeaurora.org>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 8:06 PM, Linus Walleij <linus.walleij@linaro.org> wrote:

> This switches the Qualcomm MSM pin control driver over to using
> the generic GPIO irqchip helpers.
>
> Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Josh Cartwright <joshc@codeaurora.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Anyone up for testing this patch?

Björn? Andy?

Or shall I just push it to linux-next and see what happens?

Yours,
Linus Walleij
