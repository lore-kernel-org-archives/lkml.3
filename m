Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab3LDMXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 07:23:00 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42658 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083Ab3LDMW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 07:22:58 -0500
Message-ID: <529F1E89.6080700@ti.com>
Date: Wed, 4 Dec 2013 14:22:33 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Belisko Marek <marek.belisko@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: 3.13-rc2 phy-twl4030-usb.c - Timeout setting T2 HSUSB PHY DPLL
References: <CAAfyv37aM6SrpuU9fzKA6GKsWn=To5ANOpG_kSX509NjMjdecA@mail.gmail.com>
In-Reply-To: <CAAfyv37aM6SrpuU9fzKA6GKsWn=To5ANOpG_kSX509NjMjdecA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Kishon

On 12/03/2013 11:33 PM, Belisko Marek wrote:
> Hi,
> 
> current 3.13-rcX break usb support on gta04 board (similar to
> beagleboard) when booting via board file.
> 
> In console we can see messages:
>  [ 5227.287841] twl4030_usb twl4030_usb: Timeout setting T2 HSUSB PHY DPLL clock
> [ 5232.936096] omap_musb_mailbox: musb core is not yet ready
> [ 5233.958160] twl4030_usb twl4030_usb: Timeout setting T2 HSUSB PHY DPLL clock
> [ 5235.058227] twl4030_usb twl4030_usb: Timeout setting T2 HSUSB PHY DPLL clock
> 
> Any pointer what could cause that? (in 3.12 usb works fine)
> 
> BR,
> 
> marek
> 

