Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389Ab3E2FoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 01:44:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42272 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab3E2FoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 01:44:10 -0400
Date: Tue, 28 May 2013 22:44:06 -0700 (PDT)
Message-Id: <20130528.224406.1354723685523430708.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, horms@verge.net.au
Subject: Re: linux-next: build warning after merge of the final tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130529152915.efba860c7e825fe786b1ee99@canb.auug.org.au>
References: <20130529152915.efba860c7e825fe786b1ee99@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 29 May 2013 15:29:15 +1000

> Introduced by commit 1a37e412a022 ("net: Use 16bits for *_headers fields
> of struct skbuff") from the net-next tree.

Simon just posted fixes for this, sorry about that.
