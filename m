Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881Ab3AOXwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:52:07 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:62810 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757756Ab3AOXwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 18:52:01 -0500
Message-ID: <1358293944.11794.3.camel@gitbox>
Subject: Re: [PATCH v2] mtd: vt8500: Add support for Wondermedia Serial
 Flash Controller
From: Tony Prisk <linux@prisktech.co.nz>
To: dedekind1@gmail.com
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        vt8500-wm8505-linux-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Wed, 16 Jan 2013 12:52:24 +1300
In-Reply-To: <1358278604.1668.11.camel@kyv>
References: <1358272414-6266-1-git-send-email-linux@prisktech.co.nz>
	 <1358278604.1668.11.camel@kyv>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-15 at 21:36 +0200, Artem Bityutskiy wrote:
> On Wed, 2013-01-16 at 06:53 +1300, Tony Prisk wrote:
> > This patch adds support for the Wondermedia serial flash controller
> > found on WM8505, WM8650 and WM8850 SoCs.
> > 
> > Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> 
> Would please you also send a defconfig which I can use to compile-test
> this?
> 

This should be sufficient. I haven't done a defconfig for arch-vt8500
yet as multiplatform-only support has gone through in this window and
any previous defconfig would now be useless. This defconfig is based on
3.8-rc3 - some features may not be available in earlier revisions.


CONFIG_EXPERIMENTAL=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_ARCH_VT8500_SINGLE=y
# CONFIG_ARCH_VEXPRESS_CORTEX_A5_A9_ERRATA is not set
CONFIG_ARM_ARCH_TIMER=y
CONFIG_AEABI=y
CONFIG_HIGHMEM=y
CONFIG_HIGHPTE=y
CONFIG_ARM_APPENDED_DTB=y
CONFIG_VFP=y
CONFIG_NEON=y
CONFIG_NET=y
CONFIG_BLK_DEV_SD=y
CONFIG_NETDEVICES=y
CONFIG_NET_CALXEDA_XGMAC=y
CONFIG_SMSC911X=y
CONFIG_STMMAC_ETH=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_VT8500=y
CONFIG_SERIAL_VT8500_CONSOLE=y
CONFIG_GPIO_VT8500=y
CONFIG_GPIOLIB=y
CONFIG_FB=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FB_VT8500=y
CONFIG_FB_WM8505=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_DRV_VT8500=y
CONFIG_USB=y
CONFIG_MMC=y
CONFIG_PWM=y
CONFIG_PWM_VT8500=y
CONFIG_MTD=y
CONFIG_MTD_WMT_SFLASH=y
CONFIG_DMADEVICES=y


Regards
Tony P

