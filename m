Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaBQOjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 09:39:17 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58373 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbaBQOjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 09:39:15 -0500
Message-ID: <53021EF9.2040105@ti.com>
Date: Mon, 17 Feb 2014 09:38:49 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: <mturquette@linaro.org>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <ivan.khoronzhuk@ti.com>
Subject: Re: [PATCH 0/2] clk: keystone: Couple of fixes for 3.14-rcx
References: <1392064011-11986-1-git-send-email-santosh.shilimkar@ti.com>
In-Reply-To: <1392064011-11986-1-git-send-email-santosh.shilimkar@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping,

On Monday 10 February 2014 03:26 PM, Santosh Shilimkar wrote:
> Mike,
> 
> Can you please look at these couple of keystone clock fixes ?
> Without these, we have seen some random kernel crashes. I
> have included the dts fix since both fixes are related. Do
> let me know if you prefer dts patch to be sent it via arm-soc tree.
> 
> The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:
> 
>   Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ssantosh/linux-keystone.git for_3.14-rcx/clk-fixes
> 
> for you to fetch changes up to 565bbdcd3b91523b4142587c00206302e091a23e:
> 
>   ARM: keystone: dts: fix clkvcp3 control register address (2014-02-10 15:17:43 -0500)
> 
> ----------------------------------------------------------------
> Ivan Khoronzhuk (2):
>       clk: keystone: gate: fix clk_init_data initialization
>       ARM: keystone: dts: fix clkvcp3 control register address
> 
>  arch/arm/boot/dts/keystone-clocks.dtsi |    2 +-
>  drivers/clk/keystone/gate.c            |    1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> Regards,
> Santosh
> 

