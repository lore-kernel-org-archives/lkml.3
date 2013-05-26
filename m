Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab3EZRLy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 13:11:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52426 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423Ab3EZRLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 13:11:52 -0400
Date: Sun, 26 May 2013 10:11:49 -0700 (PDT)
Message-Id: <20130526.101149.1610187533096408265.davem@davemloft.net>
To: liuj97@gmail.com
Cc: bhelgaas@google.com, yinghai@kernel.org, jiang.liu@huawei.com, rjw@sisk.pl,
        gregkh@linuxfoundation.org, guz.fnst@cn.fujitsu.com, toshi.kani@hp.com,
        myron.stowe@redhat.com, wangyijing@huawei.com,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH v3, part2 11/20] PCI, SPARC: use hotplug-safe iterators
 to walk PCI buses
From: David Miller <davem@davemloft.net>
In-Reply-To: <1369583597-3801-12-git-send-email-jiang.liu@huawei.com>
References: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com>
	<1369583597-3801-12-git-send-email-jiang.liu@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <liuj97@gmail.com>
Date: Sun, 26 May 2013 23:53:08 +0800

> Enhance SPARC architecture specific code to use hotplug-safe iterators
> to walk PCI buses.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>

Acked-by: David S. Miller <davem@davemloft.net>
