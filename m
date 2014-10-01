Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbaJARmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 13:42:13 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34631 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbaJARmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 13:42:11 -0400
Date: Wed, 01 Oct 2014 13:42:07 -0400 (EDT)
Message-Id: <20141001.134207.1431827965473600903.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexander.h.duyck@intel.com,
        jeffrey.t.kirsher@intel.com
Subject: Re: linux-next: build failure after merge of the net-next tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141001170403.7a319458@canb.auug.org.au>
References: <20141001170403.7a319458@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Oct 2014 10:42:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 1 Oct 2014 17:04:03 +1000

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 1 Oct 2014 17:00:49 +1000
> Subject: [PATCH] fm10k: using vmalloc requires including linux/vmalloc.h
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Applied, thanks Stephen.
