Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934075AbaEFDOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 23:14:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35964 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933776AbaEFDOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 23:14:35 -0400
Date: Mon, 05 May 2014 23:14:33 -0400 (EDT)
Message-Id: <20140505.231433.1853863657752503508.davem@davemloft.net>
To: andi@firstfloor.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com, ak@linux.intel.com
Subject: Re: [PATCH 19/24] net, diet: Make RPS configurable
From: David Miller <davem@davemloft.net>
In-Reply-To: <1399328773-6531-20-git-send-email-andi@firstfloor.org>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
	<1399328773-6531-20-git-send-email-andi@firstfloor.org>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 May 2014 20:14:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Mon,  5 May 2014 15:26:08 -0700

> Multiple receive queues are not needed on small systems,
> so allow disabling them.

It's only enabled with SMP...

I'm really totally, and completely, convinced that you wrote this
entire patch series with your brain turned off.

I'm not applying any patch in this series Andi, come back when
you have something specific and small and reasonable to discuss,
rather than this huge patch bomb of total and complete crap.

