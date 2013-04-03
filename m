Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350Ab3DCTfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 15:35:37 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47806 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759815Ab3DCTff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 15:35:35 -0400
Message-ID: <515C8484.507@wwwdotorg.org>
Date: Wed, 03 Apr 2013 13:35:32 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: gregkh@linuxfoundation.org, balbi@ti.com, stern@rowland.harvard.edu,
        linux-tegra@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] usb: phy: tegra: Add error handling & clean up.
References: <1364978502-22887-1-git-send-email-vbyravarasu@nvidia.com> <1364978502-22887-7-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1364978502-22887-7-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 02:41 AM, Venu Byravarasu wrote:
> Check return values from all GPIO APIs and handle errors accordingly.
> Remove clk_disable_unprepare which is no more needed.

checkpatch fails:

> WARNING: line over 80 characters
> #27: FILE: drivers/usb/phy/phy-tegra-usb.c:547:
> +		dev_err(phy->dev, "gpio %d direction not set\n", phy->reset_gpio);
> 
> WARNING: line over 80 characters
> #34: FILE: drivers/usb/phy/phy-tegra-usb.c:553:
> +		dev_err(phy->dev, "gpio %d direction not set\n", phy->reset_gpio);
> 
> total: 0 errors, 2 warnings, 72 lines checked
> 
> 0006-usb-phy-tegra-Add-error-handling-clean-up.patch has style problems, please review.

