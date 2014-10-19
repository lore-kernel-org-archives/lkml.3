Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbaJSEcP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 00:32:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50879 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaJSEcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 00:32:12 -0400
Date: Sun, 19 Oct 2014 00:32:09 -0400 (EDT)
Message-Id: <20141019.003209.2286339581794609198.davem@davemloft.net>
To: mroos@linux.ee
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.11.1410170012130.19924@adalberg.ut.ee>
References: <alpine.LRH.2.11.1410152310080.11974@adalberg.ut.ee>
	<20141015.231154.1804074463934900124.davem@davemloft.net>
	<alpine.LRH.2.11.1410170012130.19924@adalberg.ut.ee>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 Oct 2014 21:32:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Fri, 17 Oct 2014 00:38:20 +0300 (EEST)

> arch/sparc/kernel/setup_64.c is the only culprit.
> 
> Attached are 2 versions of the object file as of v3.17-rc1-22-g480cadc 
> that I tested.

Just to confirm, a gcc-4.9 compiled kernel works if just setup_64.c
is built with gcc-4.6, is that correct?

I'm looking through these two object files now, thanks!
