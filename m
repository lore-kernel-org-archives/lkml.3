Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbaH2NgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 09:36:15 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:40066 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbaH2NgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 09:36:12 -0400
MIME-Version: 1.0
In-Reply-To: <53FB8CFE.3090007@wwwdotorg.org>
References: <1408381705-3623-1-git-send-email-abrestic@chromium.org>
	<1408381705-3623-5-git-send-email-abrestic@chromium.org>
	<53FB8CFE.3090007@wwwdotorg.org>
Date: Fri, 29 Aug 2014 15:36:11 +0200
Message-ID: <CACRpkdZD2Ww44ExnLQgJvaw64rSiTZAMdphBV3gQSMZpRPj50g@mail.gmail.com>
Subject: Re: [PATCH v2 4/9] pinctrl: tegra-xusb: Add USB PHY support
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 9:22 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/18/2014 11:08 AM, Andrew Bresticker wrote:
>>
>> In addition to the PCIe and SATA PHYs, the XUSB pad controller also
>> supports 3 UTMI, 2 HSIC, and 2 USB3 PHYs.  Each USB3 PHY uses a single
>> PCIe or SATA lane and is mapped to one of the three UTMI ports.
>>
>> The xHCI controller will also send messages intended for the PHY driver,
>> so request and listen for messages on the mailbox's PHY channel.
>
>
> I'd like a review from Thierry here as the HW expert.
>
> I need an ack from LinusW in order to take this pinctrl patch through the
> Tegra tree.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
