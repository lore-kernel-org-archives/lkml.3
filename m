Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbaHNVkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 17:40:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932068AbaHNVkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 17:40:36 -0400
Date: Thu, 14 Aug 2014 14:39:11 -0700 (PDT)
Message-Id: <20140814.143911.339730226328001321.davem@redhat.com>
To: michal.simek@xilinx.com
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu, anirudh@xilinx.com,
        John.Linn@xilinx.com, manuel.schoelling@gmx.de, joe@perches.com,
        paul.gortmaker@windriver.com, edumazet@google.com,
        rob.herring@calxeda.com, ricardo.ribalda@gmail.com,
        libo.chen@huawei.com, sthokal@xilinx.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: xilinx: Remove .owner field for driver
From: David Miller <davem@redhat.com>
In-Reply-To: <a63aa03f310bb32779833fc905579458a34be6ce.1407930852.git.michal.simek@xilinx.com>
References: <a63aa03f310bb32779833fc905579458a34be6ce.1407930852.git.michal.simek@xilinx.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <michal.simek@xilinx.com>
Date: Wed, 13 Aug 2014 13:54:22 +0200

> There is no need to init .owner field.
> 
> Based on the patch from Peter Griffin <peter.griffin@linaro.org>
> "mmc: remove .owner field for drivers using module_platform_driver"
> 
> This patch removes the superflous .owner field for drivers which
> use the module_platform_driver API, as this is overriden in
> platform_driver_register anyway."
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

Applied.
