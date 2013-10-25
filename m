Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab3JYX1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 19:27:13 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36187 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab3JYX1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 19:27:12 -0400
Date: Fri, 25 Oct 2013 19:27:10 -0400 (EDT)
Message-Id: <20131025.192710.1258412532222424226.davem@davemloft.net>
To: sebastian@breakpoint.cc
Cc: andi@firstfloor.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, ak@linux.intel.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: wan: sbni: remove assembly crc32 code
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131022183625.GA4382@breakpoint.cc>
References: <1382458346-24811-12-git-send-email-andi@firstfloor.org>
	<20131022.135928.2040131908206663695.davem@davemloft.net>
	<20131022183625.GA4382@breakpoint.cc>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 25 Oct 2013 16:27:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Date: Tue, 22 Oct 2013 20:36:25 +0200

> There is also a C function doing the same thing. Unless the asm code is
> 110% faster we could stick to the C function.
> 
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

Applied.
