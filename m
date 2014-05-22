Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaEVU6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 16:58:48 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42781 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbaEVU6q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 16:58:46 -0400
Date: Thu, 22 May 2014 16:58:44 -0400 (EDT)
Message-Id: <20140522.165844.694155605608410652.davem@davemloft.net>
To: manuel.schoelling@gmx.de
Cc: jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
        bruce.w.allan@intel.com, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] e1000: Use time_after() for time comparison
From: David Miller <davem@davemloft.net>
In-Reply-To: <1400790090-13404-1-git-send-email-manuel.schoelling@gmx.de>
References: <1400790090-13404-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 May 2014 13:58:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manuel Schölling <manuel.schoelling@gmx.de>
Date: Thu, 22 May 2014 22:21:30 +0200

> To be future-proof and for better readability the time comparisons are modified
> to use time_after() instead of plain, error-prone math.
> 
> Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>

I'll let Jeff pick this up in his tree.
