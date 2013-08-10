Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394Ab3HJL7o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 07:59:44 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48055 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757902Ab3HJL7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 07:59:42 -0400
Date: Sat, 10 Aug 2013 08:59:38 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: George Cherian <george.cherian@ti.com>
Cc: linux-usb@vger.kernel.org, balbi@ti.com, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-omap@vger.kernel.org, kishon@ti.com,
        bigeasy@linutronix.de
Subject: Re: [PATCH v2 0/4] Add phy support for AM335X platform using Generic
 PHy framework
Message-ID: <20130810115936.GA2365@localhost>
References: <1374237277-17769-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1374237277-17769-1-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 06:04:33PM +0530, George Cherian wrote:
> This patch series adds phy support for AM335X platform.
> This patch series is based on Generic PHY framework [1].
> 
> 
> This series has
>         - adds dual musb instances support for am335x platform 
>         - adds phy-amxxxx-usb driver used in AMxxxx platforms
> 	- adds OTG callbacks
> 	- adds PHY wakeup enable/disable
>         - adds dt  bindings for the phys
>         - removes usb-phy and replaced with generic phy apis in glue layer
> 
> All these changes are avilable at [2]
> 
> [1] - http://marc.info/?l=linux-usb&m=137224750928570&w=2
> [2] - git://git.ti.com/~georgecherian/ti-linux-kernel/georgec-connectivity-linux-feature-tree.git
>         am335x-phy-driver-v2
> 
> George Cherian (4):
>   usb: phy: phy-omap-control: Add API to power and wakeup
>   phy: phy-amxxxx-usb: Add PHY driver for amxxxx platform
>   arm: dts: Add USB phy nodes for AM33XX

Is there any reason why there's no DT binding patch to this
series? (aka Documentation/devicetree/... + sent to devicetree list)

(sorry if this has been already explained somewhere...)

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
