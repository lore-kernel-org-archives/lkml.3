Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab3HOIYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 04:24:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37693 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab3HOIYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 04:24:06 -0400
Date: Thu, 15 Aug 2013 01:24:04 -0700 (PDT)
Message-Id: <20130815.012404.1180223951215075384.davem@davemloft.net>
To: divy@chelsio.com
Cc: aik@ozlabs.ru, linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        santosh@chelsio.com, fenlason@redhat.com
Subject: Re: [PATCH] Revert "cxgb3: Check and handle the dma mapping errors"
From: David Miller <davem@davemloft.net>
In-Reply-To: <520BA8E4.3010406@chelsio.com>
References: <1376471941-2914-1-git-send-email-aik@ozlabs.ru>
	<520BA8E4.3010406@chelsio.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 15 Aug 2013 01:24:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le ray <divy@chelsio.com>
Date: Wed, 14 Aug 2013 08:57:24 -0700

> On 08/14/2013 02:19 AM, Alexey Kardashevskiy wrote:
>> This reverts commit f83331bab149e29fa2c49cf102c0cd8c3f1ce9f9.
>>
>> As the tests PPC64 (powernv platform) show, IOMMU pages are leaking
>> when transferring big amount of small packets (<=64 bytes),
>> "ping -f" and waiting for 15 seconds is the simplest way to confirm
>> the bug.
>>
>> Cc: Linus Torvalds<torvalds@linux-foundation.org>
>> Cc: Santosh Rastapur<santosh@chelsio.com>
>> Cc: Jay Fenlason<fenlason@redhat.com>
>> Cc: David S. Miller<davem@davemloft.net>
>> Cc: Divy Le ray<divy@chelsio.com>
>> Signed-off-by: Alexey Kardashevskiy<aik@ozlabs.ru>
> 
> Acked-by: Divy Le Ray <divy@chelsio.com>

Applied, thanks.
