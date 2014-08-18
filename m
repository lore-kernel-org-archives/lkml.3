Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbaHRR3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 13:29:51 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42119 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaHRR3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 13:29:47 -0400
Message-ID: <53F2381B.8020801@wwwdotorg.org>
Date: Mon, 18 Aug 2014 11:30:03 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 0/9] Tegra xHCI support
References: <1408381705-3623-1-git-send-email-abrestic@chromium.org>
In-Reply-To: <1408381705-3623-1-git-send-email-abrestic@chromium.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2014 11:08 AM, Andrew Bresticker wrote:
> This series adds support for xHCI on NVIDIA Tegra SoCs.  This includes:
>   - adding a driver for the mailbox used to communicate with the xHCI
>     controller's firmware,
>   - extending the XUSB pad controller driver to support the USB PHY
>     types (UTMI, HSIC, and USB3), and
>   - adding a xHCI host-controller driver.

Can you please remind us what dependencies exist between the patches? In 
other words, is it possible to apply parts of the series to their usual 
subsystem branches, or does the whole thing need to go into a single 
topic branch in order to avoid compile-time problems, or run-time 
problems in features unrelated to the new functionality? Thanks.
