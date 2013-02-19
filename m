Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704Ab3BSK7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:59:23 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56272 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758428Ab3BSK7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:59:22 -0500
Message-ID: <51235B3D.5000907@ti.com>
Date: Tue, 19 Feb 2013 16:30:13 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Mohammed, Afzal" <afzal@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, "Nori, Sekhar" <nsekhar@ti.com>,
        "Syed Mohammed, Khasim" <khasim@ti.com>
Subject: Re: [PATCH, RFC 8/8] ARM: dts: am43-pre-silicon support
References: <cover.1361186097.git.afzal@ti.com> <e344f74da47579c11db68d9f6efe25259ed7f25d.1361186097.git.afzal@ti.com> <5123556A.9050109@ti.com> <C8443D0743D26F4388EA172BF4E2A7A93EAA86DE@DBDE01.ent.ti.com>
In-Reply-To: <C8443D0743D26F4388EA172BF4E2A7A93EAA86DE@DBDE01.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2013 04:22 PM, Mohammed, Afzal wrote:
> Hi Santosh,
>
> On Tue, Feb 19, 2013 at 16:05:22, Shilimkar, Santosh wrote:
>> On Monday 18 February 2013 05:08 PM, Afzal Mohammed wrote:
>
>>> AM43 SoC is in pre-silicon stage, meanwhile it has been modelled in
>>> a pre-silicon platform. To validate and boot Linux in pre-silicon
>>> platform that emulates an AM43 SoC, add DT build support.
>
>>> Note: This would be replaced by an original board support.
>
>>> -	am335x-bone.dtb
>>> +	am335x-bone.dtb \
>>> +	am43-pre-silicon.dtb
>
>> Well the pre-silicon platform and the SOC are very
>> close and at least the support you are adding here is
>> exactly same. So lets just use am437x.dtb or something
>> like that.
>
> SoC support is already added in patch 7/8. This is board (which doesn't
> exist now) support, hence a pre-silicon temporary one to validate it.
>
I mean we can call it am437x-xyxboard.dtb already considering the data
here can be re-used. Boot-args can be used from default kernel config
with CONFIG_CMDLINE_FORCE.

No strong opinion if you still insist to have a pre-silicon dtb.

Regards,
Santosh

