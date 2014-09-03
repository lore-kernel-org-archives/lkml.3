Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbaICTv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 15:51:28 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:47289 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbaICTv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 15:51:26 -0400
MIME-Version: 1.0
In-Reply-To: <1408467712-27497-1-git-send-email-abrestic@chromium.org>
References: <1408467712-27497-1-git-send-email-abrestic@chromium.org>
Date: Wed, 3 Sep 2014 12:51:25 -0700
X-Google-Sender-Auth: 2LVbksVB-nKENXDj4-hAXEqxNi8
Message-ID: <CAL1qeaFwGYgzL=n0My4eBQMhvtNQfHpU5d1tif0twtYyjw5yqg@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] Allow xHCI drivers to be built as separate modules
From: Andrew Bresticker <abrestic@chromium.org>
To: Mathias Nyman <mathias.nyman@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Julius Werner <jwerner@chromium.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathias,

On Tue, Aug 19, 2014 at 10:01 AM, Andrew Bresticker
<abrestic@chromium.org> wrote:
> It was suggested in the review of the Tegra xHCI driver [1] that we
> allow xHCI drivers to be built as individual modules (like EHCI) instead
> of building them all into the single xhci-hcd module as they are today.
>
> Patches 1-3 prepare for making the xHCI PCI and platform drivers able
> to be built as individual modules and patch 4 actually creates the 3
> separate modules (core, platform, PCI).
>
> Based on 3.17-rc1.
>
> Changes from v2:
>  - fixed typo in xhci_register_plat
>  - exported another symbol needed by xhci-pci module
> Changes from v1:
>  - rebased on changes introduced by xhci-rcar driver
>
> [1] http://patchwork.ozlabs.org/patch/361265/
>
> Andrew Bresticker (4):
>   xhci: Introduce xhci_init_driver()
>   xhci: Check for XHCI_COMP_MODE_QUIRK when disabling D3cold
>   xhci: Export symbols used by host-controller drivers
>   xhci: Allow xHCI drivers to be built as separate modules

Any thoughts/comments on this series?

Thanks,
Andrew
