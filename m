Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161155Ab3BGSyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 13:54:20 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:53261 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161081Ab3BGSyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 13:54:17 -0500
Message-ID: <1360263258.25382.4.camel@gitbox>
Subject: Re: [PATCH 08/10] USB: EHCI: make ehci-vt8500 a separate driver
From: Tony Prisk <linux@prisktech.co.nz>
To: manjunath.goudar@linaro.org
Cc: linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, stern@rowland.harvard.edu, arnd@linaro.org,
        gregkh@linuxfoundation.org, Greg KH <greg@kroah.com>,
        Alexey Charkov <alchark@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 08 Feb 2013 07:54:18 +1300
In-Reply-To: <5113e626.c84e420a.08c3.ffffbf07@mx.google.com>
References: <yes> <1360258447-27247-1-git-send-email-yes>
	 <5113e626.c84e420a.08c3.ffffbf07@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-07 at 23:04 +0530, manjunath.goudar@linaro.org wrote:
> From: Manjunath Goudar <manjunath.goudar@linaro.org>
> 
> Separate the vt8500 host controller driver from ehci-hcd host code
> into its own driver module.
> 
> Signed-off-by: Manjunath Goudar <manjunath.goudar@linaro.org>
> Cc: Greg KH <greg@kroah.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Tony Prisk <linux@prisktech.co.nz>
> Cc: Alexey Charkov <alchark@gmail.com>
> Cc: linux-usb@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/usb/host/Kconfig       |    8 +++++
>  drivers/usb/host/Makefile      |    1 +
>  drivers/usb/host/ehci-hcd.c    |    5 ---
>  drivers/usb/host/ehci-vt8500.c |   73 ++++++++++++++++++----------------------
>  4 files changed, 42 insertions(+), 45 deletions(-)
> 
...
> diff --git a/drivers/usb/host/ehci-vt8500.c b/drivers/usb/host/ehci-vt8500.c
> index 11695d5..ff4e3ae 100644
> --- a/drivers/usb/host/ehci-vt8500.c
> +++ b/drivers/usb/host/ehci-vt8500.c
> @@ -16,52 +16,25 @@
...
> +MODULE_DESCRIPTION(DRIVER_DESC);
> +MODULE_AUTHOR("Alexey Charkov");
> +MODULE_LICENSE("GPL");
Should be "GPL v2" as per the license header.

>  MODULE_ALIAS("platform:vt8500-ehci");
>  MODULE_DEVICE_TABLE(of, vt8500_ehci_ids);

Regards
Tony Prisk

