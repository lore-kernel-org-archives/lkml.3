Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaCQVUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 17:20:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43301 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaCQVUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 17:20:22 -0400
Date: Mon, 17 Mar 2014 17:20:19 -0400 (EDT)
Message-Id: <20140317.172019.167960066441598788.davem@davemloft.net>
To: peter.senna@gmail.com
Cc: jcliburn@gmail.com, chris.snook@gmail.com, johannes@sipsolutions.net,
        jg1.han@samsung.com, wangyijing@huawei.com, linux@hahnjo.de,
        sd@queasysnail.net, hahnjo@hahnjo.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH V2] ATHEROS-ALX: Use dma_set_mask_and_coherent and fix
 a bug
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394926252-2269-1-git-send-email-peter.senna@gmail.com>
References: <1394926252-2269-1-git-send-email-peter.senna@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Mar 2014 14:20:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>
Date: Sun, 16 Mar 2014 00:30:52 +0100

>  1. For the 64 bits dma mask use dma_set_mask_and_coherent instead of
>  dma_set_mask and dma_set_coherent_mask.
> 
>  2. For the 32 bits dma mask dma_set_coherent_mask is only called if
>  dma_set_mask fails, which is unusual. Assuming this as a bug, fixes
>  it by replacing calls to dma_set_mask and dma_set_coherent_mask by a
>  call to dma_set_mask_and_coherent.
>  
>  Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

Applied, thanks.
