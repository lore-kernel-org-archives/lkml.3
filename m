Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab3LJOyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 09:54:52 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:51388 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766Ab3LJOyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 09:54:50 -0500
Message-ID: <52A72B01.9090305@ti.com>
Date: Tue, 10 Dec 2013 16:53:53 +0200
From: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        <grygorii.strashko@ti.com>, Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] arm: keystone: enable watchdog support
References: <1386686869-729-1-git-send-email-ivan.khoronzhuk@ti.com> <1386686869-729-2-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1386686869-729-2-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.122]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ CC
devicetree@vger.kernel.org
linux-arm-kernel@lists.infradead.org
linux-kernel@vger.kernel.org

On 12/10/2013 04:47 PM, Ivan Khoronzhuk wrote:
> After Keystone watchdog driver updates are already merged we can
> enable WDT in config.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---
> Based on
> git://git.kernel.org/pub/scm/linux/kernel/git/ssantosh/linux-keystone.git
> keystone/master
>
>   arch/arm/configs/keystone_defconfig |    2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/arch/arm/configs/keystone_defconfig b/arch/arm/configs/keystone_defconfig
> index 9943e5d..8bd940c 100644
> --- a/arch/arm/configs/keystone_defconfig
> +++ b/arch/arm/configs/keystone_defconfig
> @@ -129,6 +129,8 @@ CONFIG_SPI_DAVINCI=y
>   CONFIG_SPI_SPIDEV=y
>   # CONFIG_HWMON is not set
>   CONFIG_WATCHDOG=y
> +CONFIG_WATCHDOG_CORE=y
> +CONFIG_DAVINCI_WATCHDOG=y
>   # CONFIG_USB_SUPPORT is not set
>   CONFIG_DMADEVICES=y
>   CONFIG_COMMON_CLK_DEBUG=y
>


-- 
Regards,
Ivan Khoronzhuk
