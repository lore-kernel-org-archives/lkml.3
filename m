Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbaICQT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 12:19:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:32885 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbaICQTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 12:19:54 -0400
Message-ID: <54073FAC.8030702@wwwdotorg.org>
Date: Wed, 03 Sep 2014 10:19:56 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: linux-tegra@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
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
Subject: Re: [PATCH v3 1/9] of: Add NVIDIA Tegra XUSB mailbox binding
References: <1409693701-16520-1-git-send-email-abrestic@chromium.org> <1409693701-16520-2-git-send-email-abrestic@chromium.org>
In-Reply-To: <1409693701-16520-2-git-send-email-abrestic@chromium.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2014 03:34 PM, Andrew Bresticker wrote:
> Add device-tree bindings for the Tegra XUSB mailbox which will be used
> for communication between the Tegra xHCI controller's firmware and the
> host processor.

The series,
Reviewed-by: Stephen Warren <swarren@nvidia.com>

I'd like Thierry to review at least the XUSB pinctrl and all DT binding 
changes too, if possible.
