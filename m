Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab3A0Gni (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 01:43:38 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:55551 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078Ab3A0Gng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 01:43:36 -0500
Date: Sun, 27 Jan 2013 01:43:32 -0500 (EST)
Message-Id: <20130127.014332.1581803153001331935.davem@davemloft.net>
To: tj@kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, chas@cmf.nrl.navy.mil,
        netdev@vger.kernel.org
Subject: Re: [PATCH 02/14] atm/nicstar: don't use idr_remove_all()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1359163872-1949-3-git-send-email-tj@kernel.org>
References: <1359163872-1949-1-git-send-email-tj@kernel.org>
	<1359163872-1949-3-git-send-email-tj@kernel.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Fri, 25 Jan 2013 17:31:00 -0800

> idr_destroy() can destroy idr by itself and idr_remove_all() is being
> deprecated.  Drop its usage.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Chas Williams <chas@cmf.nrl.navy.mil>
> Cc: netdev@vger.kernel.org
> ---
> This patch depends on an earlier idr patch and given the trivial
> nature of the patch, I think it would be best to route these together
> through -mm.  Please holler if there's any objection.

Please do:

Acked-by: David S. Miller <davem@davemloft.net>
