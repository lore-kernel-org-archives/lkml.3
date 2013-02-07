Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422636Ab3BGSs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 13:48:57 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:50973 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286Ab3BGSs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 13:48:56 -0500
Message-ID: <5113F714.6000201@wwwdotorg.org>
Date: Thu, 07 Feb 2013 11:48:52 -0700
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
Subject: Re: [PATCH 09/10] USB: EHCI: make ehci-msm a separate driver
References: <yes> <1360258447-27247-1-git-send-email-yes> <5113e62e.c84e420a.08c3.ffffbf14@mx.google.com>
In-Reply-To: <5113e62e.c84e420a.08c3.ffffbf14@mx.google.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 10:34 AM, manjunath.goudar@linaro.org wrote:
> Separate the Qualcomm On-Chip host controller driver from ehci-hcd host code
> into its own driver module.

> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig

> @@ -209,7 +210,7 @@ config USB_EHCI_TEGRA
>         boolean "NVIDIA Tegra HCD support"
>         depends on USB_EHCI_HCD && ARCH_TEGRA
>         select USB_EHCI_ROOT_HUB_TT
> -       help
> +      --- help---
>           This driver enables support for the internal USB Host Controllers
>           found in NVIDIA Tegra SoCs. The controllers are EHCI compliant.

That seems like an unrelated change. The indentation and space after
first "---" looks wrong too. It looks pretty random which of "help" and
"---help---" is used in this file; if you're going to fix that, I think
fix them all, but in a separate patch.
