Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab3FXPg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 11:36:27 -0400
Received: from multi.imgtec.com ([194.200.65.239]:29677 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab3FXPg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 11:36:26 -0400
Message-ID: <51C86777.9040006@imgtec.com>
Date: Mon, 24 Jun 2013 16:36:23 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
CC: <linux-kernel@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        "Rob Landley" <rob@landley.net>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v3 2/4] gpio-tz1090: add TZ1090 gpio driver
References: <1371720391-21825-1-git-send-email-james.hogan@imgtec.com> <1371720391-21825-3-git-send-email-james.hogan@imgtec.com> <20130624133453.8FC5D3E0A89@localhost> <51C85C31.4070003@imgtec.com>
In-Reply-To: <51C85C31.4070003@imgtec.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_06_24_16_36_24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/06/13 15:48, James Hogan wrote:
> On 24/06/13 14:34, Grant Likely wrote:
>> Similarly, can this driver use the generic irq chip to eliminate the
>> above hooks?
> 
> hmm, I could probably get away with it for irq callbacks since a bank's
> IRQ cannot be shared with non-Linux threads/cores.

I just remembered, the commits that make the generic irqchip work with
linear irq domains are in tip/irq/core so this won't work on
pinctrl/devel or gpio/next branches.

How would you like that handled? I'm happy to write a patch to convert
to generic irqchip ready to be applied later (e.g. for v3.12).

Cheers
James

