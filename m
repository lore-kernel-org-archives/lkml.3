Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbaFRFWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 01:22:53 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:41245 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaFRFWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 01:22:52 -0400
MIME-Version: 1.0
In-Reply-To: <1403066951-31266-1-git-send-email-agross@codeaurora.org>
References: <1403066951-31266-1-git-send-email-agross@codeaurora.org>
Date: Tue, 17 Jun 2014 22:22:51 -0700
Message-ID: <CAJAp7Oi2Dmvn6tHWQhPbSW5bjFA9jpUHR62q=PKg3htZWsGGXQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: qcom: Add BUS_HOLD pin bias
From: Bjorn Andersson <bjorn@kryo.se>
To: Andy Gross <agross@codeaurora.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 9:49 PM, Andy Gross <agross@codeaurora.org> wrote:
> This patch adds the BUS_HOLD (Keeper) bias option for pins.
>
> Signed-off-by: Andy Gross <agross@codeaurora.org>

Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
