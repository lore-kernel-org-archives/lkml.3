Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbaJBPIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:08:51 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:59958 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbaJBPIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:08:50 -0400
Message-ID: <542D6A73.9020505@gmail.com>
Date: Thu, 02 Oct 2014 23:08:35 +0800
From: Orson Zhai <orsonzhai@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>
CC: Catalin Marinas <Catalin.Marinas@arm.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "artagnon@gmail.com" <artagnon@gmail.com>,
        "rrichter@cavium.com" <rrichter@cavium.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "zhizhou.zhang@spreadtrum.com" <zhizhou.zhang@spreadtrum.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chunyan.zhang" <chunyan.zhang@spreadtrum.com>
Subject: Re: [PATCH 1/6] Documentation: DT: Add bindings for Spreadtrum serial
References: <1411992293-7729-1-git-send-email-zhang.lyra@gmail.com> <1411992293-7729-2-git-send-email-zhang.lyra@gmail.com> <20141001112149.GA13759@leverpostej>
In-Reply-To: <20141001112149.GA13759@leverpostej>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014年10月01日 19:21, Mark Rutland wrote:
>> diff --git a/Documentation/devicetree/bindings/serial/of-serial.txt b/Documentation/devicetree/bindings/serial/of-serial.txt
>> >index 7705477..a0bb1d1 100644
>> >--- a/Documentation/devicetree/bindings/serial/of-serial.txt
>> >+++ b/Documentation/devicetree/bindings/serial/of-serial.txt
>> >@@ -14,6 +14,7 @@ Required properties:
>> >  	- "altr,16550-FIFO32"
>> >  	- "altr,16550-FIFO64"
>> >  	- "altr,16550-FIFO128"
>> >+	- "sprd,serial"
> Is there not a more specific name? I'd imagine you might build a
> different uart in future.
AFAIK, sprd's uart is re-used the same ip core in ARM 32bit chip.
so it is neither 16550 or pl011 compatible.
>
> I didn't spot "sprd" in vendor-prefixes.txt in mainline. Is there a
> patch adding that?
sorry for missing it. we'll add it at patch V2.
thanks for reviewing! :)
>
> Mark.
>

