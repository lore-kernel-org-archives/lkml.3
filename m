Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab3D3EoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 00:44:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39689 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab3D3EoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 00:44:21 -0400
Date: Tue, 30 Apr 2013 00:44:19 -0400 (EDT)
Message-Id: <20130430.004419.627894415518165601.davem@davemloft.net>
To: bpoirier@suse.de
Cc: edumazet@google.com, xemul@parallels.com, xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] unix/stream: fix peeking with an offset larger
 than data in queue
From: David Miller <davem@davemloft.net>
In-Reply-To: <1367271734-14379-3-git-send-email-bpoirier@suse.de>
References: <kll5si$544$1@ger.gmane.org>
	<1367271734-14379-1-git-send-email-bpoirier@suse.de>
	<1367271734-14379-3-git-send-email-bpoirier@suse.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 29 Apr 2013 21:44:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Poirier <bpoirier@suse.de>
Date: Mon, 29 Apr 2013 17:42:14 -0400

> Currently, peeking on a unix stream socket with an offset larger than len of
> the data in the sk receive queue returns immediately with bogus data.
> 
> This patch fixes this so that the behavior is the same as peeking with no
> offset on an empty queue: the caller blocks.
> 
> Signed-off-by: Benjamin Poirier <bpoirier@suse.de>

Applied.
