Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaELW1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 18:27:13 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40417 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaELW1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 18:27:10 -0400
MIME-Version: 1.0
In-Reply-To: <1399932968-24780-1-git-send-email-agross@codeaurora.org>
References: <1399932968-24780-1-git-send-email-agross@codeaurora.org>
Date: Mon, 12 May 2014 15:27:10 -0700
Message-ID: <CAJAp7OgKkyp1_=+ytDO=oUvLj__CLW6C8XPv7k0e8vvq5bu7Rg@mail.gmail.com>
Subject: Re: [Patch v3] pinctrl: msm: Add more MSM8X74 pin definitions
From: Bjorn Andersson <bjorn@kryo.se>
To: Andy Gross <agross@codeaurora.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 3:16 PM, Andy Gross <agross@codeaurora.org> wrote:
> This patch adds pin definitiones for the MSM8x74 TLMM.  New definitions
> include:
>
> BLSP devices (I2C, UART, SPI, and UIM), mi2s, gp clk, pdm, gcc clk, cci_timer,
> cci_i2c, cam_clk, hsic, tsif, sdc3, sdc4, and other assorted pins.
>
> Signed-off-by: Andy Gross <agross@codeaurora.org>

Acked-By: Bjorn Andersson <bjorn.andersson@sonymobile.com>
