Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaBEQTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 11:19:14 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42782 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbaBEQTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 11:19:12 -0500
Message-ID: <52F26444.5090707@ti.com>
Date: Wed, 5 Feb 2014 18:18:12 +0200
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH v5 2/3] clocksource: keystone: add bindings for keystone
 timer
References: <1391608060-10760-1-git-send-email-ivan.khoronzhuk@ti.com>	<1391608060-10760-3-git-send-email-ivan.khoronzhuk@ti.com> <CAL_JsqKVc2fdg1Q+TH6ro9kpJmUYyHw8FCwhORfm2_oj6GYM2Q@mail.gmail.com>
In-Reply-To: <CAL_JsqKVc2fdg1Q+TH6ro9kpJmUYyHw8FCwhORfm2_oj6GYM2Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 02/05/2014 04:39 PM, Rob Herring wrote:
> On Wed, Feb 5, 2014 at 7:47 AM, Ivan Khoronzhuk <ivan.khoronzhuk@ti.com> wrote:
>> This patch provides bindings for the 64-bit timer in the KeyStone
>> architecture devices. The timer can be configured as a general-purpose 64-bit
>> timer, dual general-purpose 32-bit timers. When configured as dual 32-bit
>> timers, each half can operate in conjunction (chain mode) or independently
>> (unchained mode) of each other.
> This is software configurable or h/w design time configurations?
>
> Rob
>

This is h/w design time configurations

-- 
Regards,
Ivan Khoronzhuk

