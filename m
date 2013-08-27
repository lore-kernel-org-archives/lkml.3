Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab3H0UCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 16:02:32 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59381 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab3H0UCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 16:02:31 -0400
Date: Tue, 27 Aug 2013 16:02:26 -0400 (EDT)
Message-Id: <20130827.160226.1047540632131698779.davem@davemloft.net>
To: acking@vmware.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        pv-drivers@vmware.com
Subject: Re: [PATCH] VMXNET3: Add support for virtual IOMMU
From: David Miller <davem@davemloft.net>
In-Reply-To: <1377275629-14587-1-git-send-email-acking@vmware.com>
References: <1377275629-14587-1-git-send-email-acking@vmware.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 27 Aug 2013 13:02:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy King <acking@vmware.com>
Date: Fri, 23 Aug 2013 09:33:49 -0700

> This patch adds support for virtual IOMMU to the vmxnet3 module.  We
> switch to DMA consistent mappings for anything we pass to the device.
> There were a few places where we already did this, but using pci_blah();
> these have been fixed to use dma_blah(), along with all new occurrences
> where we've replaced kmalloc() and friends.
> 
> Also fix two small bugs:
> 1) use after free of rq->buf_info in vmxnet3_rq_destroy()
> 2) a cpu_to_le32() that should have been a cpu_to_le64()
> 
> Acked-by: George Zhang <georgezhang@vmware.com>
> Acked-by: Aditya Sarwade <asarwade@vmware.com>
> Signed-off-by: Andy King <acking@vmware.com>

Applied, thanks.
