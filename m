Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab3JJOET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 10:04:19 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:64284 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab3JJOER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 10:04:17 -0400
MIME-Version: 1.0
In-Reply-To: <5256AA7F.8030005@ti.com>
References: <20131003054104.8941.88857.stgit@localhost>
	<20131003054221.8941.87801.stgit@localhost>
	<5256AA7F.8030005@ti.com>
Date: Thu, 10 Oct 2013 16:04:16 +0200
Message-ID: <CACRpkdZx5+OCcQytkpjd7_nz4hw6VXoXOS0LByKgJ8_cQjbA4g@mail.gmail.com>
Subject: Re: [PATCH 4/6] pinctrl: single: Add support for wake-up interrupts
From: Linus Walleij <linus.walleij@linaro.org>
To: Roger Quadros <rogerq@ti.com>
Cc: Tony Lindgren <tony@atomide.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Prakash Manjunathappa <prakash.pm@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 3:24 PM, Roger Quadros <rogerq@ti.com> wrote:

> I think pcs_irq_set_wake() is where need to control system wakeup behaviour for the irq.
> This is where we should be able to change WAKEUP_EN bit of the pad
> to enable/disable system wakeup for that pad and also call _reconfigure_io_chain().

As an innocent bystander who has no clue what the _reconfigure_io_chain()
is about can you tell me what this is all about?

Is this another one of the OMAP forked paths where you must call back into
the machine with a special callback from each and every driver?

Yours,
Linus Walleij
