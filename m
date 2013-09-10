Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab3IJTkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 15:40:05 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:35847 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab3IJTkB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 15:40:01 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: [PATCH 0/3] ARM: dts: Enable EDMA, MMC and SPI on AM33XX for v3.13
From: Koen Kooi <koen@dominion.thruhere.net>
In-Reply-To: <1378841079-15796-1-git-send-email-joelf@ti.com>
Date: Tue, 10 Sep 2013 21:39:55 +0200
Cc: Benoit Cousson <bcousson@baylibre.com>, Nishanth Menon <nm@ti.com>,
        Devicetree Discuss <devicetree@vger.kernel.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <5EB8AE91-A996-4CF1-86B7-C8FDEC177E89@dominion.thruhere.net>
References: <1378841079-15796-1-git-send-email-joelf@ti.com>
To: Joel Fernandes <joelf@ti.com>
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Op 10 sep. 2013, om 21:24 heeft Joel Fernandes <joelf@ti.com> het volgende geschreven:

> Here are last few patches required to add EDMA and MMC/SPI support for AM33xx.
> 
> Now that all dependent DMA patches and fixes are in linux next or mainline, except
> for [1] which should go in for 3.12 -rc cycle, it is safe to enable MMC and SPI support
> and this patch series enables it. These are originally Matt Porter's patches with
> changes to make it work with recent kernels, addition of irq, memory resources and
> enable other extra properties.
> 
> These patches should cleanly apply on master branch after Koen's patch [2] for basic
> BBB DT support is applied.
> 
> MMC support is enabled for: Beaglebone, AM335x EVM and EVM-SK boards. MMC support
> for BBB is intentionally not added due to custom fixes and other patches that are
> in Koen's tree and which will be separately submitted by him.

Correct, but your patches for MMC support on BBW are missing the card detect entries to make it hotplug work.

