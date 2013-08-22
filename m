Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab3HVDvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 23:51:51 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40904 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab3HVDvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 23:51:49 -0400
Date: Wed, 21 Aug 2013 20:51:48 -0700 (PDT)
Message-Id: <20130821.205148.804691292072117400.davem@davemloft.net>
To: libo.chen@huawei.com
Cc: grant.likely@linaro.org, rob.herring@calxeda.com, david.daney@cavium.com,
        wfp5p@virginia.edu, gregkh@linuxfoundation.org,
        sachin.kamat@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCH] net: phy: mdio-octeon: use platform_set_drvdata()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1377080115-58636-1-git-send-email-libo.chen@huawei.com>
References: <1377080115-58636-1-git-send-email-libo.chen@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 21 Aug 2013 20:51:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Libo Chen <libo.chen@huawei.com>
Date: Wed, 21 Aug 2013 18:15:15 +0800

> Use the wrapper functions for getting and setting the driver data using
> platform_device instead of using dev_set_drvdata() with &pdev->dev,
> so we can directly pass a struct platform_device.
> 
> Signed-off-by: Libo Chen <libo.chen@huawei.com>

Applied.
