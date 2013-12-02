Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab3LBG2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 01:28:54 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:43766 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab3LBG2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 01:28:50 -0500
Message-ID: <529C2868.2090404@ti.com>
Date: Mon, 2 Dec 2013 11:57:52 +0530
From: Sricharan R <r.sricharan@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        ext Tony Lindgren <tony@atomide.com>, Rajendra Nayak <rnayak@ti.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robherring2@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kumar Gala <galak@codeaurora.org>,
        Rob Herring <rob.herring@calxeda.com>, Nishanth Menon <nm@ti.com>,
        Benoit Cousson <bcousson@baylibre.com>
Subject: Re: [PATCH V4 0/4] DRIVERS: IRQCHIP: Add support for crossbar IP
References: <1384431530-2166-1-git-send-email-r.sricharan@ti.com> <CACRpkdYM1XcBAznCpmPU+j2kHFPKYA98OAYrpLhcSJr4KbRZzA@mail.gmail.com>
In-Reply-To: <CACRpkdYM1XcBAznCpmPU+j2kHFPKYA98OAYrpLhcSJr4KbRZzA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 November 2013 02:07 PM, Linus Walleij wrote:
> On Thu, Nov 14, 2013 at 1:18 PM, Sricharan R <r.sricharan@ti.com> wrote:
>
>> The minimal crossbar driver to track and allocate free GIC lines and configure the
>> crossbar is added here, along with the DT bindings.
>>
>> V4:
>>    Addressed a couple of comments and split the DTS file updates in to
>>    a separate series.
> I'm pretty happy with the work and effort put into this now it's looking
> real elegant.
> FWIW: Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
> Yours,
> Linus Walleij
Thanks Linus.

Regards,
 Sricharan
