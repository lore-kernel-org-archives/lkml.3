Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933660AbaE2Iou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 04:44:50 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:39073 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932546AbaE2Ior (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 04:44:47 -0400
MIME-Version: 1.0
In-Reply-To: <1399932968-24780-1-git-send-email-agross@codeaurora.org>
References: <1399932968-24780-1-git-send-email-agross@codeaurora.org>
Date: Thu, 29 May 2014 10:44:46 +0200
Message-ID: <CACRpkdbHp88Mi5FFKuxkMEwO8WQ7qAM+OZcODaLOn4DopmSzSA@mail.gmail.com>
Subject: Re: [Patch v3] pinctrl: msm: Add more MSM8X74 pin definitions
From: Linus Walleij <linus.walleij@linaro.org>
To: Andy Gross <agross@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Kumar Gala <galak@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 12:16 AM, Andy Gross <agross@codeaurora.org> wrote:

> This patch adds pin definitiones for the MSM8x74 TLMM.  New definitions
> include:
>
> BLSP devices (I2C, UART, SPI, and UIM), mi2s, gp clk, pdm, gcc clk, cci_timer,
> cci_i2c, cam_clk, hsic, tsif, sdc3, sdc4, and other assorted pins.
>
> Signed-off-by: Andy Gross <agross@codeaurora.org>

Patch applied after unacceptable delay from my side, sorry.
And thanks to Kumar for poking me about this.

Yours,
Linus Walleij
