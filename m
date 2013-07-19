Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760252Ab3GSKtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 06:49:04 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54145 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760235Ab3GSKtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 06:49:00 -0400
Message-ID: <51E9197F.7010608@ti.com>
Date: Fri, 19 Jul 2013 16:18:31 +0530
From: Sricharan R <r.sricharan@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>, Nishanth Menon <nm@ti.com>,
        <balbi@ti.com>, <linux@arm.linux.org.uk>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <rnayak@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/3] misc: Add crossbar driver
References: <1374165830-6367-1-git-send-email-r.sricharan@ti.com> <1374165830-6367-2-git-send-email-r.sricharan@ti.com> <51E83A4F.5080904@ti.com> <51E87C98.5030001@ti.com> <20130719071728.GX7656@atomide.com>
In-Reply-To: <20130719071728.GX7656@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 July 2013 12:47 PM, Tony Lindgren wrote:
>> On Thursday 18 July 2013 02:56 PM, Nishanth Menon wrote:
>>
>> Since the cross-bar is not limited t0 IRQ lines and applicable for
>> DMA request lines as well, making it IRQ chip doesn't make sense. Its
>> not typical pin control functionality either but at least that framework
>> is much closer to consider as an option.
>>
>> Actually its more of setting up the IRQ and DMA pins maps once
>> at boot for a given SOC based on chosen configuration by the
>> board. So I am leaning towards pinctrl as well. Just haven't
>> thought enough about whether thats the best approach.
>>
>> CC'ing Linus W and Tony L whether we can use pinctrl framework
>> for such an IP and if yes how ;-).
> If it really muxes signals then using pinctrl seems logical.
> Especially if the registers are in the SCM block.
>
> It might be already possible to handle it already with
> pinctrl-single,bits for the muxing part.
 I also thought of using the pinctrl itself.
 But then i wanted  to have the error handling as well,
 hence did this.

Regards,
 Sricharan
