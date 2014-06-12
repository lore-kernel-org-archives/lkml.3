Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbaFLUjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:39:53 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55620 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbaFLUjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:39:10 -0400
Message-ID: <539A0FE9.1080802@wwwdotorg.org>
Date: Thu, 12 Jun 2014 14:39:05 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Bresticker <abrestic@chromium.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] pinctrl: Add NVIDIA Tegra XUSB pad controller
 support
References: <1402398708-10722-1-git-send-email-thierry.reding@gmail.com> <1402398708-10722-2-git-send-email-thierry.reding@gmail.com>
In-Reply-To: <1402398708-10722-2-git-send-email-thierry.reding@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2014 05:11 AM, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> The XUSB pad controller found on NVIDIA Tegra SoCs provides several pads
> that lanes can be assigned to in order to support a variety of interface
> options: USB 2.0, USB 3.0, PCIe and SATA.
> 
> In addition to the pin controller used to assign lanes to pads two PHYs
> are exposed to allow the bricks for PCIe and SATA to be powered up and
> down by PCIe and SATA drivers.

Aside from the issue Andrew pointed out, this series looks good to me.
I'll apply once that one issue is fixed.

Linus,

Patch 2 (pinctrl driver) depends on patch 1 (binding header), and there
are other patches that will also depend on the binding header in patch
1. I guess I should apply patch 1 in a topic branch and send you a pull
request which you can merge before applying patch 2. Does that sound OK
to you?
