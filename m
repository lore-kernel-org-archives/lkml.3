Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbaHHMP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 08:15:58 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:56011 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989AbaHHMP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 08:15:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140807085024.GE27051@dragon>
References: <1407309129-5562-1-git-send-email-b20788@freescale.com>
	<20140807085024.GE27051@dragon>
Date: Fri, 8 Aug 2014 08:15:54 -0400
Message-ID: <CAC-25o_C1ijr64NyA22JqfS9Z90-v9iseaYzcf1ojy_QNXzExA@mail.gmail.com>
Subject: Re: [PATCH V3] Thermal: imx: add i.mx6sx thermal support
From: "edubezval@gmail.com" <edubezval@gmail.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Anson Huang <b20788@freescale.com>, Zhang Rui <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Shawn,

On Thu, Aug 7, 2014 at 4:50 AM, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Wed, Aug 06, 2014 at 03:12:09PM +0800, Anson Huang wrote:
>> i.MX6SX has some new features of thermal interrupt function,
>> there are LOW, HIGH and PANIC irq for thermal sensor, so add
>> platform data to separate different thermal version;
>>
>> The reset value of LOW ALARM is 0 which means the highest
>> temp, so the LOW ALARM will be triggered once irq is enabled,
>> so we need to correct it before enabling thermal irq;
>>
>> Enable PANIC ALARM as critical trip point, it will trigger
>> system reset via SRC module once PANIC IRQ is triggered, it
>> is pure hardware function, so use it instead of software
>> reset by cooling device.
>>
>> Signed-off-by: Anson Huang <b20788@freescale.com>
>
> Tested-by: Shawn Guo <shawn.guo@linaro.org>

Thanks!

Did you have the chance to test on both? i.MX6Q and i.MX6SX?

-- 
Eduardo Bezerra Valentin
