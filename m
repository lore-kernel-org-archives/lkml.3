Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271Ab3DBIf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 04:35:26 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42102 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab3DBIfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:35:23 -0400
Message-ID: <515A983D.8040907@ti.com>
Date: Tue, 2 Apr 2013 14:05:09 +0530
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

Can you check if this is really true even in newer boards (have a look
at the latest schematics)? I remember this used to be a problem in very
early versions but was fixed later.

Thanks,
Sekhar
