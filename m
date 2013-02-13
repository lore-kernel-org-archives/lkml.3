Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab3BMSd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:33:26 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42898 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3BMSdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:33:25 -0500
Date: Wed, 13 Feb 2013 13:33:22 -0500 (EST)
Message-Id: <20130213.133322.923786540726232949.davem@davemloft.net>
To: xiong@qca.qualcomm.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        qca-linux-team@qca.qualcomm.com, nic-devel@qca.qualcomm.com,
        jwboyer@redhat.com
Subject: Re: [PATCH] atl1c: add error checking for pci_map_single functions
From: David Miller <davem@davemloft.net>
In-Reply-To: <1360629880-9920-1-git-send-email-xiong@qca.qualcomm.com>
References: <1360629880-9920-1-git-send-email-xiong@qca.qualcomm.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xiong <xiong@qca.qualcomm.com>
Date: Tue, 12 Feb 2013 08:44:40 +0800

> it is reported that code hit DMA-API errors on 3.8-rc6+,
> (see https://bugzilla.redhat.com/show_bug.cgi?id=908436, and
>      https://bugzilla.redhat.com/show_bug.cgi?id=908550)
> 
> this patch just adds error handler for
>     pci_map_single and skb_frag_dma_map.
> 
> Signed-off-by: xiong <xiong@qca.qualcomm.com>

Applied, thanks.
