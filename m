Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbaHDRbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:31:22 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33736 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaHDRbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 13:31:20 -0400
Message-ID: <53DFC360.9080304@collabora.co.uk>
Date: Mon, 04 Aug 2014 19:31:12 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>,
        =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
CC: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Tomasz Figa <t.figa@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        open list <linux-kernel@vger.kernel.org>,
        Julius Werner <jwerner@google.com>
Subject: Re: [PATCH v6 10/10] ARM: dts: Add exynos5250-spring device tree
References: <1406940750-15880-1-git-send-email-afaerber@suse.de>	<1406940750-15880-11-git-send-email-afaerber@suse.de> <CAD=FV=WFP53bZAks7t9xybUxpna89Nz=KG+PQwAcxFEH0D+3mw@mail.gmail.com>
In-Reply-To: <CAD=FV=WFP53bZAks7t9xybUxpna89Nz=KG+PQwAcxFEH0D+3mw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Doug,

On 08/04/2014 05:22 PM, Doug Anderson wrote:
>> +
>> +&pinctrl_0 {
>> +       s5m8767_dvs: s5m8767-dvs {
>> +               samsung,pins = "gpd1-0", "gpd1-1", "gpd1-2";
>> +               samsung,pin-function = <0>;
>> +               samsung,pin-pud = <1>;
>> +               samsung,pin-drv = <0>;
>> +       };
>> +
>> +       dp_hpd_gpio: dp-hpd-gpio {
>> +               samsung,pins = "gpc3-0";
>> +               samsung,pin-function = <0>;
>> +               samsung,pin-pud = <3>;
>> +               samsung,pin-drv = <0>;
>> +       };
>> +
>> +       power_key_irq: power-key-irq {
>> +               samsung,pins = "gpx1-3";
>> +               samsung,pin-function = <0>;
>> +               samsung,pin-pud = <0>;
>> +               samsung,pin-drv = <0>;
>> +       };
> 
> The fact that snow is missing the pinctrl lines for power and lid is a
> bug on snow.  Perhaps Javier would be interested in submitting a patch
> to fix that?
> 
> 

Sure, added on my TODO list to not only add these missing pin control lines for
lid and power and reference them on gpio-keys but also to double check if there
is anything else missing in the mainline Snow DTS that is on the downstream
Chrome OS one.

I'll wait for Andreas series to be picked by Kukjin before submit a patch though
to avoid any unnecessary churn.

Best regards,
Javier
