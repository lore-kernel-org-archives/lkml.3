Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252Ab3BKRhH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 12:37:07 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41701 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758191Ab3BKRhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 12:37:05 -0500
Message-ID: <51192C3D.5050403@wwwdotorg.org>
Date: Mon, 11 Feb 2013 10:37:01 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: manjunath.goudar@linaro.org
CC: linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, stern@rowland.harvard.edu, arnd@linaro.org,
        gregkh@linuxfoundation.org, Greg KH <greg@kroah.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] USB: EHCI: make ehci-msm a separate driver
References: <y> <1360522697-22902-1-git-send-email-y> <5117ee12.860e440a.097c.3521@mx.google.com>
In-Reply-To: <5117ee12.860e440a.097c.3521@mx.google.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2013 11:58 AM, manjunath.goudar@linaro.org wrote:
> Separate the Qualcomm On-Chip host controller driver from ehci-hcd host code

> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig

> @@ -203,7 +203,7 @@ config USB_EHCI_TEGRA
>         boolean "NVIDIA Tegra HCD support"
>         depends on USB_EHCI_HCD && ARCH_TEGRA
>         select USB_EHCI_ROOT_HUB_TT
> -       help
> +      --- help---
>           This driver enables support for the internal USB Host Controllers
>           found in NVIDIA Tegra SoCs. The controllers are EHCI compliant.

I still don't think that's correct.
