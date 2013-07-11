Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab3GKSgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 14:36:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58201 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab3GKSgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 14:36:32 -0400
Date: Thu, 11 Jul 2013 11:36:30 -0700 (PDT)
Message-Id: <20130711.113630.663397013864889538.davem@davemloft.net>
To: sasha.levin@oracle.com
Cc: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 9p: fix off by one causing access violations and
 memory corruption
From: David Miller <davem@davemloft.net>
In-Reply-To: <1373563014-4645-1-git-send-email-sasha.levin@oracle.com>
References: <1373563014-4645-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>
Date: Thu, 11 Jul 2013 13:16:54 -0400

> p9_release_pages() would attempt to dereference one value past the end of
> pages[]. This would cause the following crashes:
 ...
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Applied and queued up for -stable.
