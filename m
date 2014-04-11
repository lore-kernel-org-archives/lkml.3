Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbaDKUuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 16:50:10 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59211 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbaDKUuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 16:50:08 -0400
Date: Fri, 11 Apr 2014 16:50:06 -0400 (EDT)
Message-Id: <20140411.165006.1694951753458959411.davem@davemloft.net>
To: daniel@quora.org
Cc: mchan@broadcom.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Don't build unused suspend/resume functions not enabled
From: David Miller <davem@davemloft.net>
In-Reply-To: <1397204066-7389-1-git-send-email-daniel@quora.org>
References: <1397204066-7389-1-git-send-email-daniel@quora.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 11 Apr 2014 13:50:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel J Blueman <daniel@quora.org>
Date: Fri, 11 Apr 2014 16:14:26 +0800

> When CONFIG_PM_SLEEP isn't enabled, bnx2_suspend/resume are unused; don't
> build them when they aren't used.
> 
> Signed-off-by: Daniel J Blueman <daniel@quora.org>

Applied, thank you.
