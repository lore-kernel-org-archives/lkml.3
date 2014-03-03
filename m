Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbaCCQQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 11:16:06 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:49705 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbaCCQQE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 11:16:04 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH 1/3] soc: Introduce drivers/soc place-holder for SOC specific drivers
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1393629520-12713-2-git-send-email-santosh.shilimkar@ti.com>
Date: Mon, 3 Mar 2014 10:16:00 -0600
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Paul Walmsley <paul@pwsan.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sandeep Nair <sandeep_n@ti.com>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 8BIT
Message-Id: <15AC514D-6D59-4209-9365-BACDD388ABA1@codeaurora.org>
References: <1393629520-12713-1-git-send-email-santosh.shilimkar@ti.com> <1393629520-12713-2-git-send-email-santosh.shilimkar@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 28, 2014, at 5:18 PM, Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:

> Based on earlier thread "https://lkml.org/lkml/2013/10/7/662" and
> further discussion at Kernel Summit'2013, it was agreed to create
> 'driver/soc' for drivers which are quite SOC specific.
> 
> Lets take the discussion forward with this patch.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: Paul Walmsley <paul@pwsan.com>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Sandeep Nair <sandeep_n@ti.com>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
> drivers/Kconfig     |    2 ++
> drivers/Makefile    |    4 ++++
> drivers/soc/Kconfig |    3 +++
> 3 files changed, 9 insertions(+)
> create mode 100644 drivers/soc/Kconfig
> 
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index b3138fb..37f955f 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -130,6 +130,8 @@ source "drivers/staging/Kconfig"
> 
> source "drivers/platform/Kconfig"
> 
> +source "drivers/soc/Kconfig"
> +
> source "drivers/clk/Kconfig"
> 
> source "drivers/hwspinlock/Kconfig"
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 8e3b8b0..0d8e2a4 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -132,6 +132,10 @@ obj-$(CONFIG_VHOST_RING)	+= vhost/
> obj-$(CONFIG_VLYNQ)		+= vlynq/
> obj-$(CONFIG_STAGING)		+= staging/
> obj-y				+= platform/
> +
> +# SOC specific drivers
> +obj-y				+= soc/
> +
> #common clk code
> obj-y				+= clk/
> 
> diff --git a/drivers/soc/Kconfig b/drivers/soc/Kconfig
> new file mode 100644
> index 0000000..2f9d7d0
> --- /dev/null
> +++ b/drivers/soc/Kconfig
> @@ -0,0 +1,3 @@
> +menu "SOC specific Drivers"
> +
> +endmenu
> -- 
> 1.7.9.5

Is there a follow up patch that populates this with something real?

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

