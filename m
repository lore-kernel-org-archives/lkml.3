Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab3GJJsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 05:48:21 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:64808 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab3GJJsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 05:48:20 -0400
MIME-Version: 1.0
In-Reply-To: <20130710093055.GW24642@n2100.arm.linux.org.uk>
References: <1373446263-7772-1-git-send-email-jonas.jensen@gmail.com>
	<20130710093055.GW24642@n2100.arm.linux.org.uk>
Date: Wed, 10 Jul 2013 11:48:19 +0200
Message-ID: <CACmBeS1SQ=nuYqrMiQmSr6ANfZD9cGyeHQ1+zZyfPeTjoFtgQQ@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: Add MOXA ART DMA engine driver
From: Jonas Jensen <jonas.jensen@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, vinod.koul@intel.com, djbw@fb.com, arnd@arndb.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 July 2013 11:30, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> Do you actually make any use what so ever of the vchan support?

Only because it was inspired by the edma driver:

static inline struct moxart_dma_chan *to_moxart_dma_chan(struct dma_chan *c)
{
        return container_of(c, struct moxart_dma_chan, vchan.chan);
}

It could use struct dma_chan instead I think.


Best regards,
Jonas
