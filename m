Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbaIDVkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:40:22 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:41315 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbaIDVkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:40:20 -0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Cc: linux-sh@vger.kernel.org, yoshihiro.shimoda.uh@renesas.com,
        Peter.Chen@freescale.com, stern@rowland.harvard.edu,
        swarren@wwwdotorg.org, thierry.reding@gmail.com, balbi@ti.com,
        linux-tegra@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, antoine.tenart@free-electrons.com
Subject: [PATCH v5 0/2] Add generic PHY support to USB HCD
Date: Fri, 05 Sep 2014 01:40:15 +0400
Message-ID: <5072811.p8odmvpxdS@wasted.cogentembedded.com>
Organization: Cogent Embedded Inc.
User-Agent: KMail/4.13.3 (Linux/3.15.10-200.fc20.x86_64; KDE/4.13.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

   This patchset is against the usb-next' branch of Greg KH's 'usb.git' repo.
Here I add support for the generic PHY to the 'struct usb_hcd' (having to
rename the existing 'phy' field to 'usb_phy' beforehand). This was mainly
intended to be used with the PCI OHCI/EHCI drivers and also xHCI driver;
however there are several more dependent patchsets now posted to 'linux-usb'.
   Greg, if you want links to these patchsets and the device tree patches using
this patchset in order to link the PCI OHCI/EHCI devices to the PHY, just ask
(I have already posted the previously but will probably have to repost them
again)...

[1/2] usb: rename phy to usb_phy in HCD
[2/2] usb: hcd: add generic PHY support

WBR, Sergei

