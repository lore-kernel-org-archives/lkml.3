Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbaEIIhE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:37:04 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:54993 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784AbaEIIhA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:37:00 -0400
MIME-Version: 1.0
In-Reply-To: <1399005842-27898-1-git-send-email-agross@codeaurora.org>
References: <1399005842-27898-1-git-send-email-agross@codeaurora.org>
Date: Fri, 9 May 2014 10:37:00 +0200
Message-ID: <CACRpkdaZowxds1pLEEvaWwro2u=ycivzEwLkW0=Q2dgbTj3H9g@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: msm: Add more MSM8X74 pin definitions
From: Linus Walleij <linus.walleij@linaro.org>
To: Andy Gross <agross@codeaurora.org>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>
Cc: "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2014 at 6:44 AM, Andy Gross <agross@codeaurora.org> wrote:

> This patch adds pin definitiones for the MSM8x74 TLMM.  New definitions
> include:
>
> BLSP devices (I2C, UART, UART flow control, SPI, and UIM), mi2s, gp clk, pdm,
> gcc clk, cci_timer, cci_i2c, cam_clk, hsic, tsif, sdc3, sdc4, and other assorted
> pins.
>
> Signed-off-by: Andy Gross <agross@codeaurora.org>

This patch does not apply on top of the pin control "devel" branch,
can you please rebase it on my tree, branch devel?
https://git.kernel.org/cgit/linux/kernel/git/linusw/linux-pinctrl.git/

Also keep Björn on CC so he can check/Ack this.

Yours,
Linus Walleij
