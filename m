Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab3LCMbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 07:31:40 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:43099 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab3LCMbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 07:31:36 -0500
Date: Tue, 3 Dec 2013 12:31:28 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        angus.clark@st.com,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 14/36] mtd: st_spi_fsm: Add device-tree binding
 documentation
Message-ID: <20131203123128.GE12031@lee--X1>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
 <1385727565-25794-15-git-send-email-lee.jones@linaro.org>
 <CACRpkdaWXBchz78Yby11VpveBDtn6FrmupS=cnNYhvHgFJsBUw@mail.gmail.com>
 <20131202110304.GB31626@lee--X1>
 <CACRpkdb8=RRsNRKe4Nbefu2BJ4xHakmNjxFC1gwLea=bAmOz-A@mail.gmail.com>
 <20131203113156.GB12031@lee--X1>
 <CACRpkdYdW+p4-sDNCr8L75YB+e6agiQfvfEX5V+wCs4iZUaKSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYdW+p4-sDNCr8L75YB+e6agiQfvfEX5V+wCs4iZUaKSQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Dec 2013, Linus Walleij wrote:

> On Tue, Dec 3, 2013 at 12:31 PM, Lee Jones <lee.jones@linaro.org> wrote:
> > On Tue, 03 Dec 2013, Linus Walleij wrote:
> 
> >> So it can be in <linux/mfd/my-sysconfig-regs.h> as
> >> a
> >>
> >> #define MY_SYSCON_V1_BOOT_DEV_REG 0x958
> >> #define MY_SYSCON_V1_BOOT_DEV_SPI 0x1a
> >>
> >> The kernel should know which SoC is in use and
> >> act apropriately right?
> >
> > And this have lots of machine_is() calls everywhere?
> 
> No need for Mr. Everywhere to know about the SoC.
> 
> There are other ways to achieve this. arch/arm/mach-foo
> always knows which ASIC it is running on, and it can do
> various things:
> 
> - Add device tree fragments/overlays (OK high-tech, but
>   we're getting to this, inevitably)
> 
> - Selectively add AUXDATA, which is absolutely OK if
>   we can do autoprobing of hardware IMO.

I prefer our solution TBH.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
