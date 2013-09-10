Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab3IJAMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 20:12:53 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:48398 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab3IJAMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 20:12:52 -0400
MIME-Version: 1.0
In-Reply-To: <1378770719-24070-1-git-send-email-jon.mason@intel.com>
References: <1378770719-24070-1-git-send-email-jon.mason@intel.com>
Date: Mon, 9 Sep 2013 17:12:51 -0700
X-Google-Sender-Auth: 07qQQDdtIAqIPFdwLjtaNOJ92LE
Message-ID: <CAA9_cmdkkUNqXgB8rWpPOY3szMuGe-x9y2v4+EKaPpZYmmPSZA@mail.gmail.com>
Subject: Re: [PATCH] dmadevices: dma_sync_wait and dma_find_channel undefined
From: Dan Williams <dan.j.williams@intel.com>
To: Jon Mason <jon.mason@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 9, 2013 at 4:51 PM, Jon Mason <jon.mason@intel.com> wrote:
> dma_sync_wait and dma_find_channel are declared regardless of whether
> CONFIG_DMA_ENGINE is enabled, but calling the function without
> CONFIG_DMA_ENGINE enabled results "undefined reference" errors.
>
> To get around this, declare dma_sync_wait and dma_find_channel as inline
> functions if CONFIG_DMA_ENGINE is undefined.
>
> Signed-off-by: Jon Mason <jon.mason@intel.com>

Applied with a s/dmadevices/dmaengine/ on the subject.

--
Dan
