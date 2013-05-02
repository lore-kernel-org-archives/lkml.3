Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578Ab3EBR7B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 13:59:01 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58829 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932435Ab3EBR67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 13:58:59 -0400
Date: Thu, 02 May 2013 13:58:56 -0400 (EDT)
Message-Id: <20130502.135856.2001406508082430880.davem@davemloft.net>
To: kaber@trash.net
Cc: torvalds@linux-foundation.org, hayeswang@realtek.com,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130502083619.GA22010@macbook.localnet>
References: <20130502070256.GA29502@macbook.localnet>
	<20130502.041625.412316202038784117.davem@davemloft.net>
	<20130502083619.GA22010@macbook.localnet>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 02 May 2013 10:58:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 2 May 2013 10:36:49 +0200

> commit d0ed96507b21da2668766207f68518bef3193111
> Author: Patrick McHardy <kaber@trash.net>
> Date:   Thu May 2 10:35:02 2013 +0200
> 
>     net: use netdev_features_t in skb_needs_linearize()
>     
>     Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied and queued up for -stable, thanks.
