Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030183Ab3BFUC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:02:57 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43059 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757866Ab3BFUCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 15:02:54 -0500
Date: Wed, 06 Feb 2013 15:02:52 -0500 (EST)
Message-Id: <20130206.150252.1851469063501774626.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: core: Remove unnecessary alloc/OOM messages
From: David Miller <davem@davemloft.net>
In-Reply-To: <1360032496.4849.2.camel@joe-AO722>
References: <cover.1359939012.git.joe@perches.com>
	<20130204.132335.1757403310770538446.davem@davemloft.net>
	<1360032496.4849.2.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 04 Feb 2013 18:48:16 -0800

> alloc failures already get standardized OOM
> messages and a dump_stack.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
