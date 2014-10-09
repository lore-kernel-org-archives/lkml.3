Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254AbaJIKuT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 06:50:19 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:59936 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaJIKuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 06:50:13 -0400
Date: Thu, 9 Oct 2014 11:50:07 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        David Paris <david.paris@st.com>, "wim@iguana.be" <wim@iguana.be>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH 4/4] watchdog: st_wdt: Add new driver for ST's LPC
 Watchdog
Message-ID: <20141009105007.GO20647@lee--X1>
References: <1412760810-23199-1-git-send-email-lee.jones@linaro.org>
 <1412760810-23199-5-git-send-email-lee.jones@linaro.org>
 <20141009100115.GD3869@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141009100115.GD3869@leverpostej>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Oct 2014, Mark Rutland wrote:

> > +       res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "syscfg-type");
> 
> This wasn't mentioned in the binding. A comment mentioned "type", but
> there was no explicit mention of "syscfg-type" in reg-names.

Thanks Mark, I'll fixup.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
