Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab3CYIPF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 04:15:05 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60081 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724Ab3CYIPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 04:15:03 -0400
Message-ID: <5150076D.3080904@ti.com>
Date: Mon, 25 Mar 2013 13:44:37 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Philip Avinash <avinashphilip@ti.com>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <prakash.pm@ti.com>,
        <jacmet@sunsite.dk>
Subject: Re: [PATCH v3 0/3] Platform support for EHRPWM & ECAP devices in
 DAVINCI.
References: <1364197789-16783-1-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1364197789-16783-1-git-send-email-avinashphilip@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/25/2013 1:19 PM, Philip Avinash wrote:
> Add platform support for EHRPWM and ECAP by providing clock nodes and
> device tree nodes.
> This series depends on [1] and [2] and is available for testing at [3].
> Tested for back light support in da850 EVM with EHRPWM PWM device.
> 
> [1] http://gitorious.org/linux-davinci/linux-davinci/trees/davinci-for-v3.9/dt-2
> [2] https://gitorious.org/linux-pwm/linux-pwm/trees/for-next
> [3] https://github.com/avinashphilip/am335x_linux/tree/davinci-for-v3.9_soc_pwm
> 
> Note:
> DT support for EHRPWM backlight has not been added in da850-evm.dts as there is
> conflicting pin-mux requirement with SPI flash.
> 
> Philip Avinash (3):
>   ARM: davinci: clk framework support for enable/disable functionality

Patch 1/3 did not reach me. I cant find it in archives either so most
likely no one received it. Can you please send that one patch again?

>   arm: davinci: clock node support for ECAP & EHRPWM

For future, please be consistent and capitalize 'ARM' in subject line.

>   ARM: davinci: da850: add EHRPWM & ECAP DT node
> 
>  arch/arm/boot/dts/da850.dtsi               |   30 ++++++++++++++++++
>  arch/arm/mach-davinci/clock.c              |   21 ++++++++-----
>  arch/arm/mach-davinci/clock.h              |    2 ++
>  arch/arm/mach-davinci/da850.c              |   46 ++++++++++++++++++++++++++++
>  arch/arm/mach-davinci/da8xx-dt.c           |    5 +++
>  arch/arm/mach-davinci/include/mach/da8xx.h |    1 +
>  6 files changed, 98 insertions(+), 7 deletions(-)
> 

Thanks,
Sekhar
