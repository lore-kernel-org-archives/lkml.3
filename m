Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab3CSGxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 02:53:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43034 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834Ab3CSGxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 02:53:03 -0400
Message-ID: <51480BAD.2040902@ti.com>
Date: Tue, 19 Mar 2013 12:24:37 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sourav Poddar <sourav.poddar@ti.com>
CC: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <b-cousson@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: Re: [PATCH 0/2] omap serial fix.
References: <1363604081-11169-1-git-send-email-sourav.poddar@ti.com>
In-Reply-To: <1363604081-11169-1-git-send-email-sourav.poddar@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 March 2013 04:24 PM, Sourav Poddar wrote:
> The first patch is a rearrangement of a macro "OMAP_MAX_HSUART_PORTS"
> to a header file so that it can be used in other file. 
> The second patch fixes the wakeup from uart issue while using "no_console_suspend" in the
> bootargs.
> 
> These patches are developed on 3.8 custom kernel containing omap5 supend/resume support.
> 
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Thanks Sourav for sorting out the issue. With update of changelog
suggested by Kevin on patch 1, Feel free to add,
Acked-Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>


> Sourav Poddar (2):
>   driver: serial-omap: move max uart count into generic header file.
>   arm: mach-omap2: prevent UART console idle on suspend while using
>     "no_console_suspend"
> 
>  arch/arm/mach-omap2/omap_device.c         |   36 ++++++++++++++++++++++++++++-
>  drivers/tty/serial/omap-serial.c          |    2 -
>  include/linux/platform_data/serial-omap.h |    1 +
>  3 files changed, 36 insertions(+), 3 deletions(-)
> 

