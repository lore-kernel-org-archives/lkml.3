Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab3EPUXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 16:23:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41348 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884Ab3EPUXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 16:23:33 -0400
Message-ID: <5195401B.5070209@ti.com>
Date: Thu, 16 May 2013 15:22:51 -0500
From: Dan Murphy <dmurphy@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: =?ISO-8859-1?Q?Beno=EEt_Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-omap <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] ARM:dts:omap4-panda: Update the LED support for the
 panda DTS
References: <1368636386-17138-1-git-send-email-dmurphy@ti.com> <20130515170516.GA6135@kahuna> <5194FCDD.8080209@ti.com> <CAGo_u6pX+DdVNWqdPXDChzMr27YAXL_Zvt7DxWBijOCW0rXpkA@mail.gmail.com>
In-Reply-To: <CAGo_u6pX+DdVNWqdPXDChzMr27YAXL_Zvt7DxWBijOCW0rXpkA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 01:18 PM, Nishanth Menon wrote:
> On Thu, May 16, 2013 at 10:35 AM, Dan Murphy <dmurphy@ti.com> wrote:
>> I am not sure you really want to do this.
>> If I make the pinctrl part of the led structure then the only way the gpio_wk7 on a1-a3 to be configured is when
>> the CONFIG_LEDS_GPIO flag is set.
>>
>> Do you really want that dependency?  You did say it was a key fix
>> At least this way the pins are configured regardless of that flag.
> That is better as the system will be left in the pinmux configuration
> handed over from bootloader.
So you want to depend on a boot loader to configure pins correctly for the kernel?
Hmmm seems risky to me.
> The point being, muxing up pins even when not needed(config switched
> off) has no real benefit - in this case albeit, the default mux was
> causing a bug.
> pinctrl IMHO should be considered as any other resource, if it is not
> mandatory for boot, and needed only for a device functionality when
> probed, it should done there only.
>
> just my 2 cents.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
------------------
Dan Murphy

