Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933871AbaEFDDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 23:03:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35857 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933731AbaEFDDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 23:03:48 -0400
Date: Mon, 05 May 2014 23:03:47 -0400 (EDT)
Message-Id: <20140505.230347.627861494715804965.davem@davemloft.net>
To: andi@firstfloor.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com, ak@linux.intel.com
Subject: Re: [PATCH 01/24] net, diet: Reduce netdev name hash table for
 CONFIG_BASE_SMALL
From: David Miller <davem@davemloft.net>
In-Reply-To: <1399328773-6531-2-git-send-email-andi@firstfloor.org>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
	<1399328773-6531-2-git-send-email-andi@firstfloor.org>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 May 2014 20:03:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Mon,  5 May 2014 15:25:50 -0700

> Small systems typically only have two network devices, so use
> hash shift 2.

Maybe in terms of physical interfaces, but they may also have lots of
software interfaces.

Sorry, this doesn't make any sense, I'm not applying this.
