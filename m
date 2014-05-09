Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197AbaEIRAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 13:00:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39698 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271AbaEIRAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 13:00:46 -0400
Date: Fri, 9 May 2014 12:00:44 -0500
From: Andy Gross <agross@codeaurora.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Bjorn Andersson <Bjorn.Andersson@sonymobile.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: msm: Add more MSM8X74 pin definitions
Message-ID: <20140509170044.GA26165@qualcomm.com>
References: <1399005842-27898-1-git-send-email-agross@codeaurora.org>
 <CACRpkdaZowxds1pLEEvaWwro2u=ycivzEwLkW0=Q2dgbTj3H9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaZowxds1pLEEvaWwro2u=ycivzEwLkW0=Q2dgbTj3H9g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 10:37:00AM +0200, Linus Walleij wrote:
> On Fri, May 2, 2014 at 6:44 AM, Andy Gross <agross@codeaurora.org> wrote:
> 
> > This patch adds pin definitiones for the MSM8x74 TLMM.  New definitions
> > include:
> >
> > BLSP devices (I2C, UART, UART flow control, SPI, and UIM), mi2s, gp clk, pdm,
> > gcc clk, cci_timer, cci_i2c, cam_clk, hsic, tsif, sdc3, sdc4, and other assorted
> > pins.
> >
> > Signed-off-by: Andy Gross <agross@codeaurora.org>
> 
> This patch does not apply on top of the pin control "devel" branch,
> can you please rebase it on my tree, branch devel?
> https://git.kernel.org/cgit/linux/kernel/git/linusw/linux-pinctrl.git/

Sure thing.

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
