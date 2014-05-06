Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933831AbaEFDDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 23:03:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35848 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933731AbaEFDDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 23:03:01 -0400
Date: Mon, 05 May 2014 23:02:59 -0400 (EDT)
Message-Id: <20140505.230259.1803147080660592366.davem@davemloft.net>
To: andi@firstfloor.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com, ak@linux.intel.com,
        robert.olsson@its.uu.se
Subject: Re: [PATCH 22/24] net, diet: Support simpler routing table
From: David Miller <davem@davemloft.net>
In-Reply-To: <1399328773-6531-23-git-send-email-andi@firstfloor.org>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
	<1399328773-6531-23-git-send-email-andi@firstfloor.org>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 May 2014 20:03:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Mon,  5 May 2014 15:26:11 -0700

> Add an optional fib_list that uses a simple list to store routes.
> This is suitable for single homed client system which typically
> have only a handful of routes.

Sorry I'm not applying this.

We had two routing table implementations for some time and it sucked,
it meant two code paths and two places for bugs to hide.

I want only one data structure which does the job well, and we have
that now.
