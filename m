Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab3JUVTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 17:19:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43256 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab3JUVTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 17:19:22 -0400
Date: Mon, 21 Oct 2013 17:19:21 -0400 (EDT)
Message-Id: <20131021.171921.650196864241149083.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: nf_tables*.h: Remove extern from function prototypes
From: David Miller <davem@davemloft.net>
In-Reply-To: <1382245531.2041.37.camel@joe-AO722>
References: <cover.1382129045.git.joe@perches.com>
	<1382245531.2041.37.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 21 Oct 2013 14:19:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sat, 19 Oct 2013 22:05:31 -0700

> There are a mix of function prototypes with and without extern
> in the kernel sources.  Standardize on not using extern for
> function prototypes.
> 
> Function prototypes don't need to be written with extern.
> extern is assumed by the compiler.  Its use is as unnecessary as
> using auto to declare automatic/local variables in a block.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

I'll apply this directly, thanks Joe.
