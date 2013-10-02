Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab3JBUZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 16:25:48 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40336 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab3JBUZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 16:25:46 -0400
Date: Wed, 2 Oct 2013 21:25:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chris Ball <cjb@laptop.org>, Alessandro Zummo <a.zummo@towertech.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Wim Van Sebroeck <wim@iguana.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        linux-mmc@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-spi@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] amba: Ensure drvdata is NULL
Message-ID: <20131002202521.GU12758@n2100.arm.linux.org.uk>
References: <1b2479137287fa8dfda3089ca0cb9fba8c4b1f1d.1380524337.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b2479137287fa8dfda3089ca0cb9fba8c4b1f1d.1380524337.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 08:59:06AM +0200, Michal Simek wrote:
> This patch is inpired by the patch for drvdata
> "device-core: Ensure drvdata = NULL when no driver is bound"
> (sha1: 0998d0631001288a5974afc0b2a5f568bcdecb4d)
> 
> Also it fixes all occurences in drivers.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> This patch has been sent as RFC in this thread.
> http://lkml.org/lkml/2013/9/4/393

Why not have the driver core do this?  Then it gets applied to all bus
types uniformly.

Thanks.
