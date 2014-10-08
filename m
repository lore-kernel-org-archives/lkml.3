Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbaJHUJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:09:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57297 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbaJHUJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:09:01 -0400
Date: Wed, 08 Oct 2014 16:08:59 -0400 (EDT)
Message-Id: <20141008.160859.1038322519780535077.davem@davemloft.net>
To: standby24x7@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        dan.j.williams@intel.com
Subject: Re: [PATCH] net: description of dma_cookie cause make xmldocs
 warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412780019-32475-1-git-send-email-standby24x7@gmail.com>
References: <1412780019-32475-1-git-send-email-standby24x7@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Oct 2014 13:09:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masanari Iida <standby24x7@gmail.com>
Date: Wed,  8 Oct 2014 23:53:39 +0900

> In commit 7bced397510ab569d31de4c70b39e13355046387,
> dma_cookie was removed from struct skbuff.
> But the description of dma_cookie still exist.
> So the "make xmldocs" output following warning.
> 
> Warning(.//include/linux/skbuff.h:609): Excess struct/union
> /enum/typedef member 'dma_cookie' description in 'sk_buff'
> 
> Remove description of dma_cookie fix the symptom.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Applied.
