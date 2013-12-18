Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751159Ab3LRHPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 02:15:05 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:61542 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3LRHPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 02:15:03 -0500
Date: Tue, 17 Dec 2013 23:14:57 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, grygorii.strashko@ti.com,
        dwmw2@infradead.org
Subject: Re: [PATCH v4 0/9] Reuse davinci-nand driver for Keystone arch
Message-ID: <20131218071457.GB5551@norris-Latitude-E6410>
References: <1387285155-19182-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387285155-19182-1-git-send-email-ivan.khoronzhuk@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 02:59:06PM +0200, Ivan Khoronzhuk wrote:
> This series contains fixes and updates of Davinci nand driver in
> order to reuse it for Keystone platform.
> 
> v3..v4:
> - mtd: nand: davinci: fix driver registration
> 	dropped __init/__exit/__exit_p as module_platform_driver() is used
> - mtd: nand: davinci: adjust DT properties to MTD generic
> 	used of_get_nand_bus_width() helper
> - mtd: nand: davinci: don't request AEMIF address range
> 	added comment at code change

Pushed the series to l2-mtd.git. Thanks!

Brian
