Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067AbaIRWh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 18:37:56 -0400
Received: from hauke-m.de ([5.39.93.123]:59757 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604AbaIRWhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 18:37:55 -0400
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Sep 2014 18:37:54 EDT
Message-ID: <541B5D5A.10800@hauke-m.de>
Date: Fri, 19 Sep 2014 00:31:54 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Jonathan Richardson <jonathar@broadcom.com>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, JD Zheng <jdzheng@broadcom.com>
CC: devicetree@vger.kernel.org, Scott Branden <sbranden@broadcom.com>,
        Ray Jui <rjui@broadcom.com>, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Florian Fainelli <florian@openwrt.org>
Subject: Re: [PATCH 0/6] Add initial support for Broadcom Cygnus SoC
References: <Jonathan Richardson <jonathar@broadcom.com> <1410897497-27527-1-git-send-email-jonathar@broadcom.com>
In-Reply-To: <1410897497-27527-1-git-send-email-jonathar@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2014 09:58 PM, Jonathan Richardson wrote:
> Hi,
> 
> This patchset contains initial support for Broadcom's Cygnus SoC based on our
> iProc architecture. Initial support is minimal and includes just the mach
> platform code, clock driver, and a basic device tree configuration. Peripheral
> drivers will be submitted soon, as will device tree configurations for other
> Cygnus board variants.

This SoC looks similar to the BCM5301X (Northstar) SoCs even some cores
are at the same memory addresses. Does this SoC use an AXI bus with
Broadcom Plugins at address 0x18000000 ?

The BCM5301X (Northstar) SoCs also has an iProc Clock Control Unit and I
will try to use your driver for that SoC.

Is Broadcom Cygnus similar to BCM563XX or is it actually the same SoC?

Do you have some description of the hardware features of this SoC? Does
it have PCIe, or Ethernet?

Hauke
