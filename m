Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab3IWHpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 03:45:30 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:36832 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab3IWHp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 03:45:28 -0400
Date: Mon, 23 Sep 2013 10:45:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, sfr@canb.auug.org.au,
        LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH] pinctrl: pinctrl-adi2: Add dependency to arch BLACKFIN
 in Kconfig.
Message-ID: <20130923074508.GF6247@mwanda>
References: <1379908620-4036-1-git-send-email-sonic.adi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379908620-4036-1-git-send-email-sonic.adi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The other two Coccinelle warnings were real bugs as well:

drivers/pinctrl/pinctrl-adi2.c:250:1-18: ERROR: nested lock+irqsave that reuses flags from line 249.
The second spinlock_irq_save() should just be a spinlock.

drivers/pinctrl/pinctrl-adi2.c:326:16-19: ERROR: port is NULL but dereferenced.
The error message dereferences a NULL pointer.

regards,
dan carpenter

