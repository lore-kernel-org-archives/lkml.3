Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbaGUXlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 19:41:12 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:44292 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaGUXlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 19:41:09 -0400
MIME-Version: 1.0
In-Reply-To: <1404954350-26343-1-git-send-email-abrestic@chromium.org>
References: <1404954350-26343-1-git-send-email-abrestic@chromium.org>
Date: Mon, 21 Jul 2014 16:41:08 -0700
X-Google-Sender-Auth: _EjeBdZLEOD0SinKiNSUEVC15K0
Message-ID: <CAL1qeaEDSUmh8p___T5HVp7ERGRHDR3BSBoA2Bb+WCz+=RoM3w@mail.gmail.com>
Subject: Re: [PATCH 0/4] Allow xHCI drivers to be built as separate modules
From: Andrew Bresticker <abrestic@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Julius Werner <jwerner@chromium.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <treding@nvidia.com>,
        gregory.clement@free-electrons.com
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Andrew Bresticker <abrestic@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 6:05 PM, Andrew Bresticker <abrestic@chromium.org> wrote:
> It was suggested in the review of the Tegra xHCI driver [1] that we
> allow xHCI drivers to be built as individual modules (like EHCI) instead
> of building them all into the single xhci-hcd module as they are today.
>
> Patches 1-3 prepare for making the xHCI PCI and platform drivers able
> to be built as individual modules and patch 4 actually creates the 3
> separate modules (core, platform, PCI).
>
> Based on 3.16-rc4.
>
> [1] http://patchwork.ozlabs.org/patch/361265/
>
> Andrew Bresticker (4):
>   xhci: Introduce xhci_init_driver()
>   xhci: Check for XHCI_COMP_MODE_QUIRK when disabling D3cold
>   xhci: Export symbols used by host-controller drivers
>   xhci: Allow xHCI drivers to be built as separate modules

Ping.  I was hoping to get these in for 3.17 (though it may be too
late now...) as they're a dependency for the upcoming Tegra XHCI
driver.

Thanks!
Andrew
