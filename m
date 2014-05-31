Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934921AbaEaAVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 20:21:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60776 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934624AbaEaAVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 20:21:10 -0400
Date: Fri, 30 May 2014 17:21:09 -0700 (PDT)
Message-Id: <20140530.172109.1758735676902083194.davem@davemloft.net>
To: pebolle@tiscali.nl
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arcnet: remove check for CONFIG_SA1100_CT6001
From: David Miller <davem@davemloft.net>
In-Reply-To: <1401220424.28714.17.camel@x220>
References: <1401220424.28714.17.camel@x220>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 May 2014 17:21:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>
Date: Tue, 27 May 2014 21:53:44 +0200

> A check for CONFIG_SA1100_CT6001 was added in v2.6.11. But the related
> Kconfig symbol was never added to the tree. Remove this check and do
> some related cleaning up.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Applied to net-next, thanks.
