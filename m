Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaK3JJE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 04:09:04 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:49128 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbaK3JI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 04:08:57 -0500
Date: Sun, 30 Nov 2014 01:08:53 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Zhou Wang <wangzhou.bry@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        devicetree@vger.kernel.org, mark.rutland@arm.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
        galak@codeaurora.org, caizhiyong@huawei.com, haojian.zhuang@gmail.com,
        xuwei5@hisilicon.com, wangzhou1@hisilicon.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] mtd: hisilicon: add a new driver for NAND
 controller of hisilicon hip04 Soc
Message-ID: <20141130090853.GG3608@norris-Latitude-E6410>
References: <1415105221-7732-1-git-send-email-wangzhou.bry@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415105221-7732-1-git-send-email-wangzhou.bry@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 08:46:59PM +0800, Zhou Wang wrote:
> This patchset adds the support for NAND controller of hisilicon hip04 Soc.
> The NAND controller IP was developed by hisilicon and needs a new driver to
> support it. This patchset is based on v3.18-rc1. I have tested that NAND flash
> controller works fine in Hip04 D01 board.

Have you tested on the MTD test modules (drivers/mtd/tests/*)? This is
important, as we seem to regularly get UBIFS bug reports from users
whose drivers have not even passed some of the simple tests.

Also, it might be worth testing out the UBI tests found in the mtd-utils
package.

Brian
