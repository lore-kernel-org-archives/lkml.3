Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab3G2NRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 09:17:55 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33040 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914Ab3G2NRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 09:17:53 -0400
Message-ID: <51F66B65.4030702@ti.com>
Date: Mon, 29 Jul 2013 08:17:25 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: =?UTF-8?B?QmVub8OudCBDb3Vzc29u?= <benoit.cousson@linaro.org>,
        Tony Lindgren <tony@atomide.com>, <benoit.cousson@gmail.com>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        J Keerthy <j-keerthy@ti.com>
Subject: Re: [PATCH 0/9] ARM: dts: omap5-uevm: fixup wrong regulator configuration
References: <1374079538-19548-1-git-send-email-nm@ti.com> <51F63C74.6070503@ti.com>
In-Reply-To: <51F63C74.6070503@ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 04:57 AM, Keerthy wrote:
> Hi Nishanth,
>
> On Wednesday 17 July 2013 10:15 PM, Nishanth Menon wrote:
>> Due to wrong older revision of documentation used as reference, we
>> seem to have a bunch of LDOs wrongly configured on OMAP5 uEVM. This
>> series is based power tree on production board 750-2628-XXX platform.
>> Unfortunately, the wrong voltages may be detrimental to OMAP5 as they
>> supply hardware blocks at voltages that are out of specification.
>
> This series looks good to me.
>
> Acked-by:  J Keerthy <j-keerthy@ti.com>

Tony, Benoit - this series could prevent OMAP5 from being damaged on 
uEVMs with current 3.11 rc - could you suggest what we need to do to get 
it in?


-- 
Regards,
Nishanth Menon
