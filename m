Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab3HOWX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 18:23:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46686 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab3HOWX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 18:23:28 -0400
Date: Thu, 15 Aug 2013 15:23:20 -0700 (PDT)
Message-Id: <20130815.152320.567038346349607100.davem@davemloft.net>
To: clbchenlibo.chen@huawei.com
Cc: michal.simek@xilinx.com, renner@efe-gmbh.de, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com,
        sergei.shtylyov@cogentembedded.com, monstr@monstr.eu
Subject: Re: [PATCH v3 6/7] net: xilinx_emaclite: use
 platform_{get,set}_drvdata()
From: David Miller <davem@davemloft.net>
In-Reply-To: <520CD13B.2060702@huawei.com>
References: <520CD13B.2060702@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 15 Aug 2013 15:23:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Libo Chen <clbchenlibo.chen@huawei.com>
Date: Thu, 15 Aug 2013 21:01:47 +0800

> Use the wrapper functions for getting and setting the driver data using
> platform_device instead of using dev_{get,set}_drvdata() with &of_dev->dev,
> so we can directly pass a struct platform_device.
> 
> Signed-off-by: Libo Chen <libo.chen@huawei.com>

Why did you not CC: netdev on this patch?
